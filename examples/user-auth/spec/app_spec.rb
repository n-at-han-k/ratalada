# frozen_string_literal: true

require "rack/test"
require "ratalada/falcon"

# server.rb boots the app the only way the example should show it: a
# Server.run block. Swapping the backend for one that keeps the app instead of
# listening on a socket gives the spec that same stack, middleware and all —
# which here includes OmniAuth, the thing under test.
module BootedApp
  class << self
    attr_accessor :rack_app

    def run(app, **) = self.rack_app = app
  end
end

Ratalada.config.backend = BootedApp

require_relative "../server"

RSpec.describe "user-auth" do
  include Rack::Test::Methods

  def app = BootedApp.rack_app

  # Sinatra's host authorization rejects rack-test's default example.org.
  def default_host = "127.0.0.1"

  # The Inertia client sends the XSRF cookie back as a header; rack-test won't.
  def token = rack_mock_session.cookie_jar["XSRF-TOKEN"]

  def page = JSON.parse(last_response.body)

  before do
    Account.dataset.delete
    header("X-Inertia", "true")
    header("X-Inertia-Version", "1")
    get("/login")
    header("X-XSRF-TOKEN", token)
  end

  # The Inertia client posts JSON, not a form body, so that is what the spec
  # sends: a form-encoded post would pass without JSONParams in the stack.
  def post_json(path, payload)
    post(path, JSON.generate(payload), "CONTENT_TYPE" => "application/json")
  end

  def sign_up(email: "ada@example.com", password: "correct horse battery")
    post_json(
      "/auth/identity/register",
      email: email, password: password, password_confirmation: password,
    )
  end

  def log_in(email: "ada@example.com", password: "correct horse battery")
    post_json("/auth/identity/callback", auth_key: email, password: password)
  end

  it "sends an anonymous visitor to the login page, then back where they were" do
    get("/")
    expect(last_response.status).to eq(303)
    expect(last_response.headers["location"]).to end_with("/login?return_to=%2F")

    get("/login?return_to=%2F")
    expect(page["component"]).to eq("login")
    expect(page.dig("props", "auth", "user")).to be_nil

    sign_up
    expect(last_response.status).to eq(303)

    get("/")
    expect(page["component"]).to eq("index")
    expect(page.dig("props", "auth", "user", "email")).to eq("ada@example.com")
  end

  it "signs a registered account back in with its password" do
    sign_up
    delete("/session")

    get("/")
    expect(last_response.headers["location"]).to include("/login")

    log_in
    expect(last_response.status).to eq(303)
    get("/")
    expect(page.dig("props", "auth", "user", "email")).to eq("ada@example.com")
  end

  it "refuses the wrong password and says so on the login page" do
    sign_up
    delete("/session")

    log_in(password: "not it")
    # OmniAuth's failure phase, routed to app/failure.rb by server.rb.
    follow_redirect!
    expect(last_response.headers["location"]).to end_with("/login")

    get("/login")
    expect(page.dig("props", "errors", "auth_key")).to eq("Those credentials are not right")
    expect(page.dig("props", "auth", "user")).to be_nil
  end

  it "keeps a registration validation error over the redirect" do
    sign_up
    delete("/session")

    # Same address twice: validates_unique on the model.
    sign_up
    expect(last_response.headers["location"]).to end_with("/signup")

    get("/signup")
    expect(page.dig("props", "errors", "email")).to eq("is already taken")
  end

  # CSRFMiddleware sits above OmniAuth, so the registration path is refused
  # before a strategy — and the account it would have created — exists.
  it "rejects a write with no CSRF token, OmniAuth's routes included" do
    header("X-XSRF-TOKEN", nil)
    sign_up
    expect(last_response.status).to eq(403)
    expect(Account.count).to eq(0)
  end

  it "sends a signed-in visitor away from the login page" do
    sign_up
    get("/login")
    expect(last_response.status).to eq(303)
    expect(last_response.headers["location"]).to end_with("/")
  end

  it "answers an unknown path with the not-found page" do
    get("/nope")
    expect(last_response.status).to eq(404)
    expect(page["component"]).to eq("+not-found")
  end
end
