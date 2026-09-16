# frozen_string_literal: true

RSpec.describe Ratalada::Frontends::Routes do
  def build(&block) = described_class.build(block)

  it "turns a string handler into a plain text 200" do
    app = build do |request|
      case request
      in ["GET", "/"] then "ok"
      end
    end

    expect(app.call(env_for("GET", "/")))
      .to eq([200, { "content-type" => "text/plain" }, ["ok"]])
  end

  it "calls a callable handler with the request" do
    app = build do |request|
      case request
      in ["POST", "/echo"] then ->(req) { req.body }
      end
    end

    expect(app.call(env_for("POST", "/echo", body: "hello")))
      .to eq([200, { "content-type" => "text/plain" }, ["hello"]])
  end

  # #body takes the one-shot stream whole; #read chunks through it instead.
  it "reads the body in chunks" do
    chunks = []

    app = build do |request|
      while (chunk = request.read(5))
        chunks << chunk
      end

      "ok"
    end
    app.call(env_for("POST", "/", body: "hello world"))

    expect(chunks).to eq(["hello", " worl", "d"])
  end

  it "passes a response triplet through, wrapping a string body" do
    app = build { |_request| [201, { "content-type" => "application/json" }, "{}"] }

    expect(app.call(env_for("GET", "/")))
      .to eq([201, { "content-type" => "application/json" }, ["{}"]])
  end

  it "404s on an unmatched pattern" do
    app = build do |request|
      case request
      in ["GET", "/"] then "ok"
      end
    end

    expect(app.call(env_for("GET", "/nope")).first).to eq(404)
  end

  it "404s on a nil handler" do
    app = build { |_request| nil }

    expect(app.call(env_for("GET", "/")).first).to eq(404)
  end

  it "supports hash pattern matching on the request" do
    app = build do |request|
      case request
      in { verb: "GET", path: "/users", query: } then "query=#{query}"
      end
    end

    expect(app.call(env_for("GET", "/users", query: "page=2")))
      .to eq([200, { "content-type" => "text/plain" }, ["query=page=2"]])
  end
end
