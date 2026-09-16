# frozen_string_literal: true

RSpec.describe Ratalada do
  it "has a version" do
    expect(Ratalada::VERSION).not_to be_nil
  end

  it "aliases Server at the top level" do
    expect(::Server).to be(Ratalada::Server)
  end

  describe ".run", :backend do
    context "when no backend is loaded" do
      let(:backend) { nil }

      it "raises a helpful error naming a backend to require" do
        expect { Server.run { |_request| "ok" } }
          .to raise_error(Ratalada::NoBackendError, /ratalada\/puma/)
      end
    end

    it "raises without a block" do
      expect { Server.run }.to raise_error(ArgumentError)
    end

    it "builds the app and hands it to the backend with the run options" do
      Server.run(host: "example.test", port: 1234) { |_request| "ok" }

      expect(backend.host).to eq("example.test")
      expect(backend.port).to eq(1234)
      expect(backend.count).to eq(1)
      expect(backend.app.call(env_for("GET", "/")))
        .to eq([200, { "content-type" => "text/plain" }, ["ok"]])
    end

    # The router block is called as a plain block: self and ivars stay whatever
    # they were at the call site, so `@state ||= ...` inside it keeps working.
    it "keeps the caller's self and ivars inside the block" do
      @counter = 0

      Server.run { |_request| (@counter += 1).to_s }

      expect(backend.app.call(env_for("GET", "/")))
        .to eq([200, { "content-type" => "text/plain" }, ["1"]])
      expect(@counter).to eq(1)
    end

    # Rack::Utils' helpers are callable unqualified inside a Server.run block
    # with no include at the call site, and without changing self or its ivars.
    it "exposes Rack::Utils helpers unqualified inside the block" do
      Server.run { |request| escape_html(parse_query(request.query)["name"]) }

      expect(backend.app.call(env_for("GET", "/", query: "name=Bobby+%3Cb%3E")))
        .to eq([200, { "content-type" => "text/plain" }, ["Bobby &lt;b&gt;"]])
      expect(Object.new.respond_to?(:escape_html, true))
        .to be(false), "must not leak past the block's own scope"
    end

    # A block written inside an object gets the helpers there too, and the
    # include is confined to that one object: siblings and Object never see it.
    it "confines the Rack::Utils include to the block's own receiver" do
      author = Class.new do
        def router = proc { |request| escape_html(request.query) }
      end
      writer = author.new

      Server.run(&writer.router)

      expect(backend.app.call(env_for("GET", "/", query: "<b>")))
        .to eq([200, { "content-type" => "text/plain" }, ["&lt;b&gt;"]])
      expect(writer.respond_to?(:escape_html, true))
        .to be(true), "the block's own receiver must get the helpers"
      expect(author.new.respond_to?(:escape_html, true))
        .to be(false), "leaked to a sibling instance"
      expect(Object.new.respond_to?(:escape_html, true))
        .to be(false), "leaked to Object"
      expect(respond_to?(:escape_html, true))
        .to be(false), "leaked to unrelated objects"
    end

    # Proc#binding raises on a C-level proc (Symbol#to_proc, Proc#curry); the
    # helpers are simply unavailable there rather than Server.run blowing up.
    it "accepts a block with no binding" do
      expect { :handler_for.to_proc.binding }
        .to raise_error(ArgumentError), "precondition: this proc must have no binding"

      Server.run(&:query)

      expect(backend.app.call(env_for("GET", "/", query: "ok")))
        .to eq([200, { "content-type" => "text/plain" }, ["ok"]])
    end

    it "accepts a block from a frozen receiver" do
      block = "frozen".freeze.instance_eval { proc { |request| request.query } }
      expect { block.binding.receiver.singleton_class.include(::Rack::Utils) }
        .to raise_error(TypeError), "precondition: receiver must reject a singleton"

      Server.run(&block)

      expect(backend.app.call(env_for("GET", "/", query: "ok")))
        .to eq([200, { "content-type" => "text/plain" }, ["ok"]])
    end

    # Numeric strings are valid: the count setting's constructor coerces before
    # validation (covered in configuration_spec.rb).
    it "rejects an invalid count" do
      expect { Server.run(count: 0) { |_request| "ok" } }.to raise_error(ArgumentError)
    end
  end
end
