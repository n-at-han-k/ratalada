# frozen_string_literal: true

require "test_helper"
require "stringio"

class RataladaTest < Minitest::Test
  def test_version
    refute_nil Ratalada::VERSION
  end

  def test_server_is_aliased_at_top_level
    assert_same Ratalada::Server, ::Server
  end

  def test_run_without_backend_raises_helpful_error
    with_backend(nil) do
      error = assert_raises(Ratalada::NoBackendError) do
        Server.run { |_request| "ok" }
      end
      assert_includes error.message, "ratalada/puma"
    end
  end

  def test_run_without_block_raises
    assert_raises(ArgumentError) { Server.run }
  end

  def test_run_builds_app_and_hands_it_to_backend
    backend = Class.new do
      attr_reader :app, :host, :port

      def run(app, host:, port:)
        @app = app
        @host = host
        @port = port
      end
    end.new

    with_backend(backend) do
      Server.run(host: "example.test", port: 1234) { |_request| "ok" }
    end

    assert_equal "example.test", backend.host
    assert_equal 1234, backend.port
    assert_equal [200, { "content-type" => "text/plain" }, ["ok"]], backend.app.call(env_for("GET", "/"))
  end

  private

  def with_backend(backend)
    original = Ratalada.instance_variable_get(:@backend)
    Ratalada.backend = backend
    yield
  ensure
    Ratalada.backend = original
  end

  def env_for(verb, path, body: "")
    { "REQUEST_METHOD" => verb, "PATH_INFO" => path, "QUERY_STRING" => "", "rack.input" => StringIO.new(body) }
  end
end
