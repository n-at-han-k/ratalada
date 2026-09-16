# frozen_string_literal: true

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

# One pass over the file-based routes: booking a slot, the availability the
# booking removes, validation, cancelling, and the catch-all.
RSpec.describe "book-a-slot" do
  include Rack::Test::Methods

  def app = BootedApp.rack_app

  # Sinatra's host authorization rejects rack-test's default example.org.
  def default_host = "127.0.0.1"

  # The Inertia client sends the XSRF cookie back as a header; rack-test won't.
  def token = rack_mock_session.cookie_jar["XSRF-TOKEN"]

  def page = JSON.parse(last_response.body)

  before do
    DB.execute("delete from bookings")
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

  def first_open_date
    get("/")
    page.dig("props", "availableDates").first
  end

  def book(date:, time: "09:00", name: "Ada", email: "ada@example.com")
    post_json("/bookings", date: date, time: time, name: name, email: email)
  end

  it "books a slot, then shows it as taken" do
    date = first_open_date

    book(date: date)
    expect(last_response.status).to eq(303)
    expect(last_response.headers["location"]).to end_with("/bookings")

    get("/bookings")
    expect(page["component"]).to eq("bookings")
    booking = page.dig("props", "bookings").first
    expect(booking).to include("date" => date, "time" => "09:00", "name" => "Ada")

    get("/")
    expect(page.dig("props", "booked", date)).to eq(["09:00"])
  end

  it "offers only weekdays that still have a free slot" do
    date = first_open_date
    expect(Date.parse(date)).to satisfy { |d| !d.saturday? && !d.sunday? }

    SLOT_TIMES.each { |time| book(date: date, time: time) }

    get("/")
    expect(page.dig("props", "availableDates")).not_to include(date)
  end

  it "refuses a slot that is already taken" do
    date = first_open_date
    book(date: date)
    book(date: date, name: "Grace", email: "grace@example.com")

    get("/")
    expect(page.dig("props", "errors", "slot")).to eq("Someone just took that slot")
    get("/bookings")
    expect(page.dig("props", "bookings").size).to eq(1)
  end

  it "keeps validation errors over the redirect, then sweeps them" do
    date = first_open_date
    book(date: date, name: "  ", email: "nope")

    get("/")
    expect(page.dig("props", "errors")).to include(
      "name" => "Give us a name for the booking",
      "email" => "We need an email to send the invite",
    )

    get("/")
    expect(page["props"]).not_to have_key("errors")
  end

  it "refuses a date outside the booking window" do
    book(date: (Date.today - 1).to_s)

    get("/")
    expect(page.dig("props", "errors", "slot")).to eq("That slot is no longer open")
  end

  it "frees the slot again when a booking is cancelled" do
    date = first_open_date
    book(date: date)

    get("/bookings")
    id = page.dig("props", "bookings").first["id"]

    delete("/bookings/#{id}")
    get("/")
    expect(page.dig("props", "booked")).to be_empty
  end

  it "answers an unknown path with the not-found page" do
    get("/nope")
    expect(last_response.status).to eq(404)
    expect(page["component"]).to eq("+not-found")
  end
end
