# frozen_string_literal: true

require "test_helper"
require "stringio"

# Server.use(A).use(B).run { ... } wraps the app the frontend built, once, at
# boot. The middleware is plain rack middleware — it sees the env — so any
# existing rack middleware works, whichever frontend is active.
class ServerStackTest < Minitest::Test
  def test_use_chains_and_wraps_the_app_outermost_first
    app = stack_for(tag("outer"), tag("inner"))
    env = env_for("GET", "/")

    _, _, body = app.call(env)
    assert_equal %w[outer inner], env["tags"]
    assert_equal ["ok"], body
  end

  def test_middleware_is_instantiated_once_not_per_request
    counter = Class.new do
      def self.count = @count ||= 0
      def self.count! = @count = count + 1
    end
    middleware = Class.new do
      define_method(:initialize) { |app| counter.count! and @app = app }
      def call(env) = @app.call(env)
    end

    app = Ratalada::Server.use(middleware).to_app(->(_request) { "ok" })
    3.times { app.call(env_for("GET", "/")) }

    assert_equal 1, counter.count
  end

  def test_middleware_can_short_circuit_before_the_router_runs
    blocker = Class.new do
      def initialize(app) = @app = app
      def call(_env) = [403, { "content-type" => "text/plain" }, ["nope"]]
    end
    router = ->(_request) { flunk("router must not run") }

    status, = Ratalada::Server.use(blocker).to_app(router).call(env_for("GET", "/"))
    assert_equal 403, status
  end

  def test_run_without_use_still_builds_a_bare_app
    app = Ratalada::Server::Stack.new.to_app(->(_request) { "ok" })

    assert_equal [200, { "content-type" => "text/plain" }, ["ok"]], app.call(env_for("GET", "/"))
  end

  def test_run_still_rejects_a_missing_block_and_a_bad_count
    assert_raises(ArgumentError) { Ratalada::Server.use(tag("a")).run }
    assert_raises(ArgumentError) { Ratalada::Server.run(count: 0) { |_r| "ok" } }
  end

  private

  def stack_for(*middleware)
    middleware.inject(Ratalada::Server) { |chain, m| chain.use(m) }.to_app(->(_request) { "ok" })
  end

  # Records its name in the env on the way in, so env["tags"] is the order
  # the stack was entered: outermost first.
  def tag(name)
    Class.new do
      define_method(:initialize) { |app| @app = app }
      define_method(:call) do |env|
        (env["tags"] ||= []) << name
        @app.call(env)
      end
    end
  end

  def env_for(verb, path, query: "", body: "")
    { "REQUEST_METHOD" => verb, "PATH_INFO" => path, "QUERY_STRING" => query, "rack.input" => StringIO.new(body) }
  end
end
