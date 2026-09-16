# frozen_string_literal: true

require "test_helper"
require "stringio"

class ConfigurationTest < Minitest::Test
  def test_defaults_come_from_the_constants
    assert_equal Ratalada::DEFAULT_HOST, Ratalada.config.host
    assert_equal Ratalada::DEFAULT_PORT, Ratalada.config.port
    assert_equal Ratalada::DEFAULT_COUNT, Ratalada.config.count
  end

  def test_configure_block_sets_values
    Ratalada.configure do |config|
      config.host = "0.0.0.0"
      config.port = 3000
      config.count = 4
    end

    assert_equal "0.0.0.0", Ratalada.config.host
    assert_equal 3000, Ratalada.config.port
    assert_equal 4, Ratalada.config.count
  end

  def test_port_and_count_coerce_strings
    Ratalada.configure do |config|
      config.port = "3000"
      config.count = "2"
    end

    assert_equal 3000, Ratalada.config.port
    assert_equal 2, Ratalada.config.count
  end

  def test_run_options_are_written_through_to_config
    with_backend(recording_backend) do |backend|
      Server.run(host: "example.test", port: 1234, count: 2) { |_request| "ok" }

      assert_equal "example.test", backend.host
      assert_equal 1234, backend.port
      assert_equal 2, backend.count
    end

    assert_equal "example.test", Ratalada.config.host
    assert_equal 1234, Ratalada.config.port
    assert_equal 2, Ratalada.config.count
  end

  def test_run_reads_configured_values_when_no_options_given
    Ratalada.configure do |config|
      config.port = 4567
    end

    with_backend(recording_backend) do |backend|
      Server.run { |_request| "ok" }

      assert_equal Ratalada::DEFAULT_HOST, backend.host
      assert_equal 4567, backend.port
      assert_equal Ratalada::DEFAULT_COUNT, backend.count
    end
  end

  def test_run_options_beat_configured_values
    Ratalada.configure do |config|
      config.port = 4567
    end

    with_backend(recording_backend) do |backend|
      Server.run(port: 8901) { |_request| "ok" }

      assert_equal 8901, backend.port
    end
  end

  def test_run_rejects_an_unknown_option_as_an_unknown_setting
    with_backend(recording_backend) do
      error = assert_raises(ArgumentError) do
        Server.run(floogle: 1) { |_request| "ok" }
      end
      assert_includes error.message, "floogle"
    end
  end

  def test_run_rejects_invalid_count
    with_backend(recording_backend) do
      assert_raises(ArgumentError) { Server.run(count: 0) { |_request| "ok" } }
      assert_raises(ArgumentError) { Server.run(count: -1) { |_request| "ok" } }
    end
  end

  # The constructor coerces before validation, so a numeric string is fine.
  def test_run_accepts_a_numeric_string_count
    with_backend(recording_backend) do |backend|
      Server.run(count: "2") { |_request| "ok" }

      assert_equal 2, backend.count
    end
  end

  private

  def recording_backend
    Class.new do
      attr_reader :app, :host, :port, :count

      def run(app, host:, port:, count:)
        @app = app
        @host = host
        @port = port
        @count = count
      end
    end.new
  end

  def with_backend(backend)
    original = Ratalada.instance_variable_get(:@backend)
    Ratalada.backend = backend
    yield backend
  ensure
    Ratalada.backend = original
  end
end
