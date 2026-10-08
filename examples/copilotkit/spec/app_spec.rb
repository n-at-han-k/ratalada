# frozen_string_literal: true

require "tmpdir"

ENV["COPILOT_DB"] = File.join(Dir.mktmpdir, "test.db")

require "rack/test"
require "ratalada/falcon"

# server.rb boots the app the only way the example should show it: a
# Server.run block. Swapping the backend for one that keeps the app instead of
# listening on a socket gives the spec that same stack, middleware and all --
# including the copilot mount, which is the first middleware in it.
module BootedApp
  class << self
    attr_accessor :rack_app

    def run(app, **) = self.rack_app = app
  end
end

Ratalada.config.backend = BootedApp

require_relative "../server"

RSpec.describe "copilotkit" do
  include Rack::Test::Methods

  def app = BootedApp.rack_app

  # Sinatra's host authorization rejects rack-test's default example.org.
  def default_host = "127.0.0.1"

  # The Inertia client sends the XSRF cookie back as a header; rack-test won't.
  def token = rack_mock_session.cookie_jar["XSRF-TOKEN"]

  def page = JSON.parse(last_response.body)

  before do
    DB.execute("delete from items")
    header("X-Inertia", "true")
    header("X-Inertia-Version", "1")
    get("/")
    header("X-XSRF-TOKEN", token)
  end

  # The Inertia client posts JSON, not a form body, and so do the copilot's
  # frontend tools -- a form-encoded post would pass without JSONParams in the
  # stack.
  def post_json(path, payload)
    post(path, JSON.generate(payload), "CONTENT_TYPE" => "application/json")
  end

  def patch_json(path, payload)
    patch(path, JSON.generate(payload), "CONTENT_TYPE" => "application/json")
  end

  # The app half: the routes the UI posts to are the ones the agent's tools post
  # to, so this is also the test of what the agent can do.
  it "walks an item from creation to deletion" do
    post_json("/items", title: "Order the timber")
    expect(last_response.status).to eq(303)

    get("/")
    expect(page["component"]).to eq("index")
    item = page.dig("props", "items").first
    expect(item).to include("title" => "Order the timber", "done" => 0)

    patch_json("/items/#{item['id']}", done: 1)
    get("/")
    expect(page.dig("props", "items").first).to include("done" => 1)

    delete("/items/#{item['id']}")
    get("/")
    expect(page.dig("props", "items")).to be_empty
  end

  it "keeps a validation error over the redirect, then sweeps it" do
    post_json("/items", title: "   ")
    get("/")
    expect(page.dig("props", "errors", "title")).to eq("Give the item a title")

    get("/")
    expect(page["props"]).not_to have_key("errors")
  end

  it "answers an unknown path with the not-found page" do
    get("/nope")
    expect(last_response.status).to eq(404)
    expect(page["component"]).to eq("+not-found")
  end

  describe "the copilot mount" do
    around do |example|
      key = ENV["OPENROUTER_API_KEY"]
      ENV["OPENROUTER_API_KEY"] = key_for_example
      example.run
      ENV["OPENROUTER_API_KEY"] = key
    end

    let(:key_for_example) { "sk-or-test" }

    # What the CopilotKit client asks for first. A 200 here means the prefix was
    # moved to SCRIPT_NAME correctly -- left on PATH_INFO, the runtime reads
    # every request as a bare run and this would not be the descriptor.
    it "serves the runtime descriptor the client boots from" do
      get("/api/copilotkit/info")
      expect(last_response.status).to eq(200)
      expect(JSON.parse(last_response.body)).to include("agents")
    end

    context "with no model key" do
      let(:key_for_example) { "" }

      it "says so instead of raising" do
        get("/api/copilotkit/info")
        expect(last_response.status).to eq(503)
      end

      # And the page says so too, which is what hides the launcher.
      it "shares copilot: false with every page" do
        get("/")
        expect(page.dig("props", "copilot")).to be(false)
      end
    end
  end

  it "leaves a lookalike path to the router" do
    get("/api/copilotkitten")
    expect(last_response.status).to eq(404)
    expect(page["component"]).to eq("+not-found")
  end
end
