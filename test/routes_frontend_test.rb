# frozen_string_literal: true

require "test_helper"
require "stringio"

class RoutesFrontendTest < Minitest::Test
  def test_string_handler_becomes_plain_text_200
    app = build do |request|
      case request
      in ["GET", "/"] then "ok"
      end
    end

    assert_equal [200, { "content-type" => "text/plain" }, ["ok"]], app.call(env_for("GET", "/"))
  end

  def test_callable_handler_is_called_with_the_request
    app = build do |request|
      case request
      in ["POST", "/echo"] then ->(req) { req.body }
      end
    end

    assert_equal [200, { "content-type" => "text/plain" }, ["hello"]],
                 app.call(env_for("POST", "/echo", body: "hello"))
  end

  def test_response_triplet_passes_through_with_string_body_wrapped
    app = build do |_request|
      [201, { "content-type" => "application/json" }, "{}"]
    end

    assert_equal [201, { "content-type" => "application/json" }, ["{}"]], app.call(env_for("GET", "/"))
  end

  def test_unmatched_pattern_is_a_404
    app = build do |request|
      case request
      in ["GET", "/"] then "ok"
      end
    end

    status, = app.call(env_for("GET", "/nope"))
    assert_equal 404, status
  end

  def test_nil_handler_is_a_404
    app = build { |_request| nil }

    status, = app.call(env_for("GET", "/"))
    assert_equal 404, status
  end

  def test_hash_pattern_matching_on_request
    app = build do |request|
      case request
      in { verb: "GET", path: "/users", query: } then "query=#{query}"
      end
    end

    assert_equal [200, { "content-type" => "text/plain" }, ["query=page=2"]],
                 app.call(env_for("GET", "/users", query: "page=2"))
  end

  private

  def build(&block)
    Ratalada::Frontends::Routes.build(block)
  end

  def env_for(verb, path, query: "", body: "")
    { "REQUEST_METHOD" => verb, "PATH_INFO" => path, "QUERY_STRING" => query, "rack.input" => StringIO.new(body) }
  end
end
