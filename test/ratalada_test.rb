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
      attr_reader :app, :host, :port, :count

      def run(app, host:, port:, count:)
        @app = app
        @host = host
        @port = port
        @count = count
      end
    end.new

    with_backend(backend) do
      Server.run(host: "example.test", port: 1234) { |_request| "ok" }
    end

    assert_equal "example.test", backend.host
    assert_equal 1234, backend.port
    assert_equal 1, backend.count
    assert_equal [200, { "content-type" => "text/plain" }, ["ok"]], backend.app.call(env_for("GET", "/"))
  end

  # The router block is called as a plain block: self and ivars stay whatever
  # they were at the call site, so `@state ||= ...` inside it keeps working.
  def test_run_block_keeps_caller_self_and_ivars
    backend = Class.new do
      attr_reader :app

      def run(app, host:, port:, count:) = @app = app
    end.new

    @counter = 0
    with_backend(backend) do
      Server.run { |_request| (@counter += 1).to_s }
    end

    assert_equal [200, { "content-type" => "text/plain" }, ["1"]], backend.app.call(env_for("GET", "/"))
    assert_equal 1, @counter
  end

  # Rack::Utils' helpers are callable unqualified inside a Server.run block
  # with no include at the call site, and without changing self or its ivars.
  def test_run_block_can_call_rack_utils_helpers_unqualified
    backend = Class.new do
      attr_reader :app

      def run(app, host:, port:, count:) = @app = app
    end.new

    with_backend(backend) do
      Server.run { |request| escape_html(parse_query(request.query)["name"]) }
    end

    assert_equal(
      [200, { "content-type" => "text/plain" }, ["Bobby &lt;b&gt;"]],
      backend.app.call(env_for("GET", "/", query: "name=Bobby+%3Cb%3E"))
    )
    refute Object.new.respond_to?(:escape_html, true), "must not leak past the block's own scope"
  end

  # A block written inside an object gets the helpers there too, and the
  # include is confined to that one object: siblings and Object never see it.
  def test_rack_utils_include_is_confined_to_the_blocks_own_receiver
    author = Class.new do
      def router = proc { |request| escape_html(request.query) }
    end
    writer = author.new
    block = writer.router

    with_backend(recording_backend) do |backend|
      Server.run(&block)
      assert_equal(
        [200, { "content-type" => "text/plain" }, ["&lt;b&gt;"]],
        backend.app.call(env_for("GET", "/", query: "<b>"))
      )
    end

    assert writer.respond_to?(:escape_html, true), "the block's own receiver must get the helpers"
    refute author.new.respond_to?(:escape_html, true), "leaked to a sibling instance"
    refute Object.new.respond_to?(:escape_html, true), "leaked to Object"
    refute self.class.new(name).respond_to?(:escape_html, true), "leaked to unrelated objects"
  end

  # Proc#binding raises on a C-level proc (Symbol#to_proc, Proc#curry); the
  # helpers are simply unavailable there rather than Server.run blowing up.
  def test_run_accepts_a_block_with_no_binding
    assert_raises(ArgumentError, "precondition: this proc must have no binding") do
      :handler_for.to_proc.binding
    end

    with_backend(recording_backend) do |backend|
      Server.run(&:query)
      assert_equal(
        [200, { "content-type" => "text/plain" }, ["ok"]],
        backend.app.call(env_for("GET", "/", query: "ok"))
      )
    end
  end

  def test_run_accepts_a_block_from_a_frozen_receiver
    block = "frozen".freeze.instance_eval { proc { |request| request.query } }
    assert_raises(TypeError, "precondition: receiver must reject a singleton") do
      block.binding.receiver.singleton_class.include(::Rack::Utils)
    end

    with_backend(recording_backend) do |backend|
      Server.run(&block)
      assert_equal(
        [200, { "content-type" => "text/plain" }, ["ok"]],
        backend.app.call(env_for("GET", "/", query: "ok"))
      )
    end
  end

  def test_run_rejects_invalid_count
    backend = Class.new do
      def run(app, host:, port:, count:); end
    end.new

    with_backend(backend) do
      assert_raises(ArgumentError) { Server.run(count: 0) { |_request| "ok" } }
      assert_raises(ArgumentError) { Server.run(count: "2") { |_request| "ok" } }
    end
  end

  private

  # Captures the app Server.run hands the backend, for tests that then call it.
  def recording_backend
    Class.new do
      attr_reader :app

      def run(app, host:, port:, count:) = @app = app
    end.new
  end

  def with_backend(backend)
    original = Ratalada.instance_variable_get(:@backend)
    Ratalada.backend = backend
    yield backend
  ensure
    Ratalada.backend = original
  end

  def env_for(verb, path, body: "", query: "")
    { "REQUEST_METHOD" => verb, "PATH_INFO" => path, "QUERY_STRING" => query, "rack.input" => StringIO.new(body) }
  end
end
