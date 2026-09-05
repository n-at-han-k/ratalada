# frozen_string_literal: true

require "test_helper"
require "stringio"

# The Hanami frontend class-evals the Server.run block into a Hanami::API
# subclass and serves an instance of it. Hanami::API exposes `use` (scoped by
# path, unlike rack's) and a block context with `status`, `headers`, `json` and
# `halt` — this test proves those survive the frontend intact.
class HanamiFrontendTest < Minitest::Test
  # Requiring the adapter sets Ratalada.frontend; put the default router back so
  # the rest of the suite (Server.run tests) keeps building via Frontends::Routes.
  ADAPTER_AVAILABLE =
    begin
      require "ratalada/hanami"
      Ratalada.frontend = Ratalada::Frontends::Routes
      true
    rescue LoadError
      false
    end

  def setup
    unless ADAPTER_AVAILABLE
      skip "ratalada/hanami is not in the active bundle"
    end
  end

  def test_block_return_value_is_the_body
    app = build do
      get "/" do
        "ok"
      end
    end

    status, _, body = app.call(env_for("GET", "/"))
    assert_equal 200, status
    assert_equal ["ok"], body
  end

  def test_path_variables_arrive_as_params
    app = build do
      get "/users/:id" do
        "user #{params[:id]}"
      end
    end

    assert_equal ["user 42"], app.call(env_for("GET", "/users/42"))[2]
  end

  def test_unmatched_path_is_a_404
    app = build do
      get "/" do
        "ok"
      end
    end

    assert_equal 404, app.call(env_for("GET", "/nope"))[0]
  end

  def test_middleware_runs_around_the_route
    middleware = header_tagging_middleware

    app = build do
      use middleware

      get "/" do
        "ok"
      end
    end

    status, headers, body = app.call(env_for("GET", "/"))
    assert_equal 200, status
    assert_equal "hanami-ran", headers["X-Middleware"]
    assert_equal ["ok"], body
  end

  # The reason to reach for hanami-api over hanami-router: `use` inside a
  # `scope` only wraps that prefix. Rack's `use` can't do this.
  def test_middleware_inside_a_scope_only_wraps_that_prefix
    middleware = header_tagging_middleware

    app = build do
      scope "admin" do
        use middleware

        get "/" do
          "admin"
        end
      end

      get "/" do
        "root"
      end
    end

    assert_equal "hanami-ran", app.call(env_for("GET", "/admin"))[1]["X-Middleware"]
    assert_nil app.call(env_for("GET", "/"))[1]["X-Middleware"]
  end

  def test_block_context_helpers_are_available
    app = build do
      get "/secret" do
        halt(401)
      end

      get "/data" do
        json(ok: true)
      end
    end

    assert_equal 401, app.call(env_for("GET", "/secret"))[0]
    assert_equal ['{"ok":true}'], app.call(env_for("GET", "/data"))[2]
  end

  private

  def build(&block)
    Ratalada::Frontends::Hanami.build(block)
  end

  def header_tagging_middleware
    Class.new do
      def initialize(app)
        @app = app
      end

      def call(env)
        status, headers, body = @app.call(env)
        headers["X-Middleware"] = "hanami-ran"
        [status, headers, body]
      end
    end
  end

  def env_for(verb, path, body: "")
    {
      "REQUEST_METHOD" => verb,
      "SCRIPT_NAME" => "",
      "PATH_INFO" => path,
      "QUERY_STRING" => "",
      "rack.input" => StringIO.new(body),
    }
  end
end
