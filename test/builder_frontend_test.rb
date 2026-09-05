# frozen_string_literal: true

require "test_helper"
require "stringio"

# The Rack::Builder frontend hands the Server.run block straight to
# Rack::Builder, so `use`, `map` and `run` are rack's own and the app is built
# once. No Request sugar: `run` gets the raw env, like any rack app.
class BuilderFrontendTest < Minitest::Test
  # Requiring the adapter sets Ratalada.frontend; put the default router back
  # so the rest of the suite keeps building via Frontends::Routes.
  ADAPTER_AVAILABLE =
    begin
      require "ratalada/builder"
      Ratalada.frontend = Ratalada::Frontends::Routes
      true
    rescue LoadError
      false
    end

  def setup
    unless ADAPTER_AVAILABLE
      skip "rack is not in the active bundle"
    end
  end

  def test_use_and_run_build_a_middleware_wrapped_app
    middleware = header_tagging_middleware

    app = build do
      use middleware

      run ->(_env) { [200, { "content-type" => "text/plain" }, ["ok"]] }
    end

    status, headers, body = app.call(env_for("GET", "/"))
    assert_equal 200, status
    assert_equal "builder-ran", headers["X-Middleware"]
    assert_equal ["ok"], body
  end

  def test_map_mounts_an_app_under_a_prefix
    app = build do
      map "/admin" do
        run ->(_env) { [200, { "content-type" => "text/plain" }, ["admin"]] }
      end

      run ->(_env) { [200, { "content-type" => "text/plain" }, ["root"]] }
    end

    assert_equal ["admin"], app.call(env_for("GET", "/admin"))[2]
    assert_equal ["root"], app.call(env_for("GET", "/"))[2]
  end

  def test_middleware_is_built_once_not_per_request
    counter = Class.new do
      def self.count = @count ||= 0
      def self.count! = @count = count + 1
    end
    middleware = Class.new do
      define_method(:initialize) { |app| counter.count! and @app = app }
      def call(env) = @app.call(env)
    end

    app = build do
      use middleware

      run ->(_env) { [200, {}, ["ok"]] }
    end
    3.times { app.call(env_for("GET", "/")) }

    assert_equal 1, counter.count
  end

  private

  def build(&block)
    Ratalada::Frontends::Builder.build(block)
  end

  def header_tagging_middleware
    Class.new do
      def initialize(app)
        @app = app
      end

      def call(env)
        status, headers, body = @app.call(env)
        headers["X-Middleware"] = "builder-ran"
        [status, headers, body]
      end
    end
  end

  def env_for(verb, path, body: "")
    {
      "REQUEST_METHOD" => verb,
      "SCRIPT_NAME" => "", # Rack::URLMap (what `map` builds) reads it unconditionally
      "PATH_INFO" => path,
      "QUERY_STRING" => "",
      "rack.input" => StringIO.new(body),
    }
  end
end
