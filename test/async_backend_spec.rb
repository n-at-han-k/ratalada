# frozen_string_literal: true

Adapter.load("ratalada/async")

# Async::HTTP::Server speaks Protocol::HTTP, so on this backend the rack
# adapter is only worth paying for when the frontend needs translating. The
# frontend decides, and every frontend but ProtocolRoutes is rack.
RSpec.describe Ratalada::Backends::AsyncHTTP, adapter: "ratalada/async" do
  let(:app) { ->(_message) { nil } }

  # Reloading the backend file is how the "installs a frontend" examples below
  # observe the require's side effects — and it sets config.backend too, which
  # leaks to every later example (streaming_spec forks a server and would get
  # this one instead of falcon). Put both back.
  around do |example|
    frontend = Ratalada.config.frontend
    backend = Ratalada.config.backend
    example.run
  ensure
    Ratalada.config.frontend = frontend
    Ratalada.config.backend = backend
  end

  describe ".adapt" do
    it "hands a Protocol::HTTP frontend's app to the server whole" do
      Ratalada.config.frontend = Ratalada::Frontends::ProtocolRoutes

      expect(described_class.adapt(app)).to be(app)
    end

    it "wraps the rack router" do
      Ratalada.config.frontend = Ratalada::Frontends::Routes

      expect(described_class.adapt(app)).to be_a(Protocol::Rack::Adapter::Generic)
    end

    # Sinatra, Grape, Hanami and Roda never declare anything; rack is what a
    # frontend is unless it says otherwise.
    it "wraps a frontend that says nothing about rack" do
      Ratalada.config.frontend = Module.new { def self.build(block) = block }

      expect(described_class.adapt(app)).to be_a(Protocol::Rack::Adapter::Generic)
    end
  end

  # Requiring the backend is what installs the frontend, so this is the
  # behaviour `require "ratalada/async"` buys on its own.
  describe "the frontend it installs" do
    it "replaces the default rack router" do
      Ratalada.config.frontend = Ratalada::Frontends::Routes
      load "ratalada/async.rb"

      expect(Ratalada.config.frontend).to be(Ratalada::Frontends::ProtocolRoutes)
    end

    it "leaves a frontend that was explicitly required alone" do
      explicit = Module.new { def self.build(block) = block }
      Ratalada.config.frontend = explicit
      load "ratalada/async.rb"

      expect(Ratalada.config.frontend).to be(explicit)
    end
  end

  # Why this backend is not Backends::Async. A sibling of that name shadows
  # the async gem for the whole namespace: an unqualified `Async::Service`
  # inside Backends::Falcon resolved to `Ratalada::Backends::Async::Service`
  # and broke that backend outright in any process that required both --
  # which the docs invite ("if you require both, the last require wins").
  # streaming_spec boots falcon for real and is what catches it; these pin the
  # two things that keep it from coming back, because the lookup is only wrong
  # at the point of use and nothing notices until a server fails to come up.
  it "does not take the name the async gem uses" do
    expect(Ratalada::Backends.const_defined?(:Async, false)).to be(false)
    expect(described_class.name).to eq("Ratalada::Backends::AsyncHTTP")
  end

  it "leaves the falcon backend's Async:: references rooted at ::" do
    source = File.read(File.expand_path("../lib/ratalada/falcon.rb", __dir__))
    code = source.lines.grep_v(/^\s*#/).join

    expect(code.scan(/(?<![:\w.])Async::/))
      .to be_empty, "lib/ratalada/falcon.rb must write ::Async::, so a sibling named Async cannot shadow it"
  end

  # Server.use on this frontend is Protocol::HTTP middleware: new(delegate),
  # call(request). That is the same contract Server.use already chains for
  # rack, so there is nothing between the middleware and the server.
  describe "Server.use" do
    # Native: sees the request, and the response, in Protocol::HTTP terms.
    tagger = Class.new(Protocol::HTTP::Middleware) do
      def call(request)
        super.tap do |response|
          response.headers["x-native"] = request.path
        end
      end
    end

    before { Ratalada.config.frontend = Ratalada::Frontends::ProtocolRoutes }

    # Headers#[] hands back an Array for a field it has no policy for, which
    # is every x- header, so these read the one value out rather than
    # pretending a custom header is a String.
    def header(response, name) = Array(response.headers[name]).first

    def run_stack(stack)
      app = stack.to_app(proc { |_request| "ok" })
      app.call(Protocol::HTTP::Request["GET", "/where"])
    end

    it "chains Protocol::HTTP middleware with no adapter" do
      response = run_stack(Ratalada::Server.use(tagger))

      expect(header(response, "x-native")).to eq("/where")
      expect(response.body.join).to eq("ok")
    end

    # First use is outermost, as everywhere else in ratalada, so the outer one
    # sees what the inner one did.
    it "keeps the first use outermost" do
      order = []
      outer = Class.new(Protocol::HTTP::Middleware) do
        define_method(:call) do |request|
          order << :outer_in
          super(request).tap { order << :outer_out }
        end
      end
      inner = Class.new(Protocol::HTTP::Middleware) do
        define_method(:call) do |request|
          order << :inner_in
          super(request).tap { order << :inner_out }
        end
      end
      run_stack(Ratalada::Server.use(outer).use(inner))

      expect(order).to eq([:outer_in, :inner_in, :inner_out, :outer_out])
    end

    # Middleware#close walks the chain on shutdown; the bottom of it is the
    # router, and a chain that raises there takes the server down with it.
    it "closes cleanly down the whole chain" do
      app = Ratalada::Server.use(tagger).use(tagger).to_app(proc { "ok" })

      expect { app.close }.not_to raise_error
    end
  end
end
