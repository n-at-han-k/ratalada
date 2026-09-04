# frozen_string_literal: true

require "test_helper"
require "stringio"

# The Grape frontend class-evals the Server.run block into a Grape::API
# subclass. Grape's DSL exposes `use`, so the resulting rack app can be wrapped
# in middleware exactly like any other Rack builder — this test proves that
# path survives the frontend intact.
class GrapeFrontendTest < Minitest::Test
  # Requiring the adapter sets Ratalada.frontend; put the default router back so
  # the rest of the suite (Server.run tests) keeps building via Frontends::Routes.
  ADAPTER_AVAILABLE =
    begin
      require "ratalada/grape"
      Ratalada.frontend = Ratalada::Frontends::Routes
      true
    rescue LoadError
      false
    end

  def setup
    unless ADAPTER_AVAILABLE
      skip "ratalada/grape is not in the active bundle"
    end
  end

  def test_middleware_runs_around_the_route
    middleware = header_tagging_middleware

    app = build do
      use middleware
      format :txt

      get "/" do
        "ok"
      end
    end

    status, headers, body = app.call(env_for("GET", "/"))
    assert_equal 200, status
    assert_equal "grape-ran", headers["x-middleware"]
    assert_equal ["ok"], body
  end

  private

  def build(&block)
    Ratalada::Frontends::Grape.build(block)
  end

  def header_tagging_middleware
    Class.new do
      def initialize(app)
        @app = app
      end

      def call(env)
        status, headers, body = @app.call(env)
        headers["X-Middleware"] = "grape-ran"
        [status, headers, body]
      end
    end
  end

  def env_for(verb, path, body: "")
    { "REQUEST_METHOD" => verb, "PATH_INFO" => path, "QUERY_STRING" => "", "rack.input" => StringIO.new(body) }
  end
end