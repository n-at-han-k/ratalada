# frozen_string_literal: true

require "test_helper"
require "stringio"

# The Roda frontend class-evals the Server.run block into a Roda subclass and
# serves the frozen rack app. Roda's own DSL — `route`, `plugin` and `use` —
# is what the block sees; this test proves those survive the frontend intact.
class RodaFrontendTest < Minitest::Test
  # Requiring the adapter sets Ratalada.frontend; put the default router back so
  # the rest of the suite (Server.run tests) keeps building via Frontends::Routes.
  ADAPTER_AVAILABLE =
    begin
      require "ratalada/roda"
      Ratalada.frontend = Ratalada::Frontends::Routes
      true
    rescue LoadError
      false
    end

  def setup
    unless ADAPTER_AVAILABLE
      skip "ratalada/roda is not in the active bundle"
    end
  end

  def test_root_block_return_value_is_the_body
    app = build do
      route do |r|
        r.root do
          "ok"
        end
      end
    end

    status, _, body = app.call(env_for("GET", "/"))
    assert_equal 200, status
    assert_equal ["ok"], body
  end

  # The routing tree is the reason to pick Roda: branch first, act on the way
  # down, match the verb last.
  def test_routing_tree_branches_and_yields_segments
    app = build do
      route do |r|
        r.on "users", Integer do |id|
          @greeting = "user #{id}"

          r.get "posts" do
            "#{@greeting} posts"
          end

          r.is do
            @greeting
          end
        end
      end
    end

    assert_equal ["user 42"], app.call(env_for("GET", "/users/42"))[2]
    assert_equal ["user 42 posts"], app.call(env_for("GET", "/users/42/posts"))[2]
  end

  def test_unmatched_path_is_a_404
    app = build do
      route do |r|
        r.root do
          "ok"
        end
      end
    end

    assert_equal 404, app.call(env_for("GET", "/nope"))[0]
  end

  def test_middleware_runs_around_the_route
    middleware = header_tagging_middleware

    app = build do
      use middleware

      route do |r|
        r.root do
          "ok"
        end
      end
    end

    status, headers, body = app.call(env_for("GET", "/"))
    assert_equal 200, status
    assert_equal "roda-ran", headers["X-Middleware"]
    assert_equal ["ok"], body
  end

  # Roda is built out of plugins, so the class body has to be the block's
  # scope for the frontend to be worth anything.
  def test_plugins_are_available_in_the_block
    app = build do
      plugin :json

      route do |r|
        r.root do
          { ok: true }
        end
      end
    end

    assert_equal ['{"ok":true}'], app.call(env_for("GET", "/"))[2]
  end

  def test_the_app_is_frozen
    app = build do
      route do |r|
        r.root do
          "ok"
        end
      end
    end

    assert_predicate app, :frozen?
  end

  private

  def build(&block)
    Ratalada::Frontends::Roda.build(block)
  end

  def header_tagging_middleware
    Class.new do
      def initialize(app)
        @app = app
      end

      def call(env)
        status, headers, body = @app.call(env)
        headers["X-Middleware"] = "roda-ran"
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
