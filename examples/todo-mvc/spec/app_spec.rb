# frozen_string_literal: true

require "tmpdir"

ENV["TODO_DB"] = File.join(Dir.mktmpdir, "test.db")

require "rack/test"
require "ratalada/falcon"

# server.rb boots the app the only way the example should show it: a
# Server.run block. Swapping the backend for one that keeps the app instead of
# listening on a socket gives the spec that same stack, middleware and all.
module BootedApp
  class << self
    attr_accessor :rack_app

    def run(app, **) = self.rack_app = app
  end
end

Ratalada.config.backend = BootedApp

require_relative "../server"

# One pass over the file-based routes: every verb, the modal routes' page
# object, validation and the catch-all.
RSpec.describe "todo-mvc" do
  include Rack::Test::Methods

  def app = BootedApp.rack_app

  # Sinatra's host authorization rejects rack-test's default example.org.
  def default_host = "127.0.0.1"

  # The Inertia client sends the XSRF cookie back as a header; rack-test won't.
  def token = rack_mock_session.cookie_jar["XSRF-TOKEN"]

  def page = JSON.parse(last_response.body)

  before do
    header("X-Inertia", "true")
    header("X-Inertia-Version", "1")
    get("/")
    header("X-XSRF-TOKEN", token)
  end

  # The Inertia client posts JSON, not a form body, so that is what the spec
  # sends: a form-encoded post would pass without JSONParams in the stack.
  def post_json(path, payload)
    post(path, JSON.generate(payload), "CONTENT_TYPE" => "application/json")
  end

  def patch_json(path, payload)
    patch(path, JSON.generate(payload), "CONTENT_TYPE" => "application/json")
  end

  it "walks a task from creation to deletion" do
    post_json("/tasks", title: "Buy milk")
    expect(last_response.status).to eq(303)

    get("/")
    expect(page["component"]).to eq("index")
    task = page.dig("props", "tasks").first
    expect(task).to include("title" => "Buy milk", "done" => 0)

    patch_json("/tasks/#{task['id']}", done: 1)
    patch_json("/tasks/#{task['id']}/edit", title: "Buy oat milk")
    get("/")
    expect(page.dig("props", "tasks").first).to include("title" => "Buy oat milk", "done" => 1)

    delete("/tasks/#{task['id']}")
    get("/")
    expect(page.dig("props", "tasks")).to be_empty
  end

  it "renders a modal route as the list plus the dialog's own component" do
    post_json("/tasks", title: "Buy milk")
    get("/")
    id = page.dig("props", "tasks").first["id"]

    get("/tasks/new")
    expect(page["component"]).to eq("index")
    expect(page.dig("props", "modal", "component")).to eq("tasks/new")

    get("/tasks/#{id}/edit")
    expect(page.dig("props", "modal", "component")).to eq("tasks/[id]/edit")
    expect(page.dig("props", "modal", "props", "task", "title")).to eq("Buy milk")
  end

  it "keeps a validation error over the redirect, then sweeps it" do
    post_json("/tasks", title: "   ")
    expect(last_response.headers["location"]).to end_with("/tasks/new")

    get("/tasks/new")
    expect(page.dig("props", "errors", "title")).to eq("Give the task a title")

    get("/tasks/new")
    expect(page["props"]).not_to have_key("errors")
  end

  it "answers an unknown path with the not-found page" do
    get("/nope")
    expect(last_response.status).to eq(404)
    expect(page["component"]).to eq("+not-found")
  end

  it "404s an edit for a task that is gone" do
    get("/tasks/99/edit")
    expect(last_response.status).to eq(404)
  end
end
