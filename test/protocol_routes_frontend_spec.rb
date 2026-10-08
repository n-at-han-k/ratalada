# frozen_string_literal: true

Adapter.load("ratalada/async")

# Requiring ratalada/async swaps the default rack router for this one, so the
# Server.run block on that backend is routed in Protocol::HTTP terms: a
# Protocol::HTTP::Request in, a Protocol::HTTP::Response out, no env and no
# triplet anywhere. The patterns the block writes are the same ones every
# other backend matches, which is the whole point of swapping it silently.
RSpec.describe "Protocol::HTTP routes frontend", adapter: "ratalada/async" do
  def build(&block) = Ratalada::Frontends::ProtocolRoutes.build(block)

  def request(verb, path, body: nil)
    Protocol::HTTP::Request[verb, path, {}, body && [body]]
  end

  it "turns a string handler into a plain text 200" do
    app = build do |request|
      case request
      in ["GET", "/"] then "ok"
      end
    end
    response = app.call(request("GET", "/"))

    expect(response.status).to eq(200)
    expect(response.headers["content-type"]).to eq("text/plain")
    expect(response.body.join).to eq("ok")
  end

  it "matches the path without its query string, and parses the query into params" do
    app = build do |request|
      case request
      in ["GET", "/hi"] then ->(req) { "hi #{req.params["name"]}" }
      end
    end

    expect(app.call(request("GET", "/hi?name=nathan")).body.join).to eq("hi nathan")
  end

  # The rack frontend's #query is "" when there is no query string; this one
  # matches it so a pattern means the same thing on either backend.
  it "deconstructs to verb, path and query like the rack router" do
    seen = nil
    app = build do |request|
      case request
      in {verb:, path:, query:} then seen = [verb, path, query]
      end

      "ok"
    end
    app.call(request("GET", "/users"))

    expect(seen).to eq(["GET", "/users", ""])
  end

  # There is no wrapper: the handler gets the object the server built, so the
  # whole Protocol::HTTP::Request is in scope and #body is the body itself.
  it "hands the router the server's own request" do
    seen = nil
    app = build do |request|
      seen = request
      "ok"
    end
    message = request("GET", "/")
    app.call(message)

    expect(seen).to be(message)
  end

  # The point of dropping the adapter: #body is a Readable that can be handed
  # straight back as the response body, so nothing is buffered in between.
  it "passes the request body through as the response body" do
    app = build do |request|
      case request
      in ["POST", "/echo"] then ->(req) { req.body }
      end
    end
    message = request("POST", "/echo", body: "streamed")
    response = app.call(message)

    expect(response.body).to be(message.body)
    expect(response.body.join).to eq("streamed")
  end

  it "reads the body whole when the handler asks for it" do
    app = build do |request|
      case request
      in ["POST", "/echo"] then ->(req) { req.body.join.upcase }
      end
    end

    expect(app.call(request("POST", "/echo", body: "hello")).body.join).to eq("HELLO")
  end

  it "calls a callable object handler with the request" do
    greet = Class.new do
      def call(req) = "hi #{req.path}"
    end

    app = build { |_request| greet.new }

    expect(app.call(request("GET", "/there")).body.join).to eq("hi /there")
  end

  # Body::Readable#call(stream) is how a body writes itself out, so a body
  # answers #call. Returning one has to mean "this is the response", not
  # "call this" — the pass-through test above is what pins the ordering, and
  # this is the same trap from the other side: a Response answers nothing.
  it "passes a Protocol::HTTP::Response through untouched" do
    response = Protocol::HTTP::Response[204, {}, nil]
    app = build { |_request| response }

    expect(app.call(request("GET", "/"))).to be(response)
  end

  it "passes a response triplet through, wrapping a string body" do
    app = build { |_request| [201, { "content-type" => "application/json" }, "{}"] }
    response = app.call(request("GET", "/"))

    expect(response.status).to eq(201)
    expect(response.headers["content-type"]).to eq("application/json")
    expect(response.body.join).to eq("{}")
  end

  it "404s on an unmatched pattern" do
    app = build do |request|
      case request
      in ["GET", "/"] then "ok"
      end
    end

    expect(app.call(request("GET", "/nope")).status).to eq(404)
  end

  it "404s on a nil handler" do
    app = build { |_request| nil }

    expect(app.call(request("GET", "/")).status).to eq(404)
  end
end
