# frozen_string_literal: true

Adapter.load("ratalada/async")

# The router matches the request the server built, so the patterns live on Protocol::HTTP::Request itself. Without them every `case request in [...]` raises NoMatchingPatternError and every route 404s, which is a silent failure -- hence a spec per method rather than one that just routes.
RSpec.describe "Protocol::HTTP::Request pattern matching", adapter: "ratalada/async" do
  def request(verb, path) = Protocol::HTTP::Request[verb, path]

  it "deconstructs to verb and path, with the query string split off" do
    expect(request("GET", "/users/1?a=b").deconstruct).to eq(["GET", "/users/1"])
  end

  it "matches an array pattern" do
    matched = []

    case request("GET", "/users/1?a=b")
    in ["GET", "/users/1"] then matched << :array
    end

    expect(matched).to eq([:array])
  end

  it "matches a hash pattern" do
    matched = []

    case request("POST", "/users?page=2")
    in {verb: "POST", path: "/users", query: "page=2"} then matched << :hash
    end

    expect(matched).to eq([:hash])
  end

  it "decodes query parameters, nesting and all" do
    expect(request("GET", "/?a=b&tags[]=x&tags[]=y").params)
      .to eq({"a" => "b", "tags" => ["x", "y"]})
  end

  it "reports an empty query as the rack router does, not as nil" do
    plain = request("GET", "/users")

    expect(plain.query).to eq("")
    expect(plain.params).to eq({})
  end

  # #path is the raw target: protocol-http1 writes it, and anything else reading the request expects it. Only the patterns see the split path.
  it "leaves #path as the raw target" do
    expect(request("GET", "/users/1?a=b").path).to eq("/users/1?a=b")
  end

  # The class already overrides #method as a zero-arg reader for the HTTP verb, so Object#method is gone there whatever we do -- #verb is the name the patterns use, and reads better in `in {verb:}` either way.
  it "mirrors the verb under a name that is not #method" do
    message = request("GET", "/")

    expect(message.verb).to eq(message.method)
    expect(message.verb).to eq("GET")
  end
end
