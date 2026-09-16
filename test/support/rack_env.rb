# frozen_string_literal: true

# One rack env builder for the whole suite. SCRIPT_NAME is always present
# because Rack::URLMap (what Rack::Builder's `map` builds) reads it
# unconditionally; the frontends that don't need it don't mind it.
module RackEnv
  def env_for(verb, path, query: "", body: "")
    {
      "REQUEST_METHOD" => verb,
      "SCRIPT_NAME"    => "",
      "PATH_INFO"      => path,
      "QUERY_STRING"   => query,
      "rack.input"     => StringIO.new(body),
    }
  end

  # Tags the response on the way out, so a spec can prove the middleware ran
  # around the route rather than instead of it.
  def header_tagging_middleware(tag)
    Class.new do
      define_method(:initialize) { |app| @app = app }
      define_method(:call) do |env|
        status, headers, body = @app.call(env)
        headers["X-Middleware"] = tag
        [status, headers, body]
      end
    end
  end

  # Records its name in the env on the way in, so env["tags"] reads as the
  # order the stack was entered: outermost first.
  def env_tagging_middleware(name)
    Class.new do
      define_method(:initialize) { |app| @app = app }
      define_method(:call) do |env|
        (env["tags"] ||= []) << name
        @app.call(env)
      end
    end
  end

  # Counts its own instantiations, to prove middleware is built at boot rather
  # than per request.
  def counting_middleware(counter)
    Class.new do
      define_method(:initialize) do |app|
        counter.count!
        @app = app
      end
      def call(env) = @app.call(env)
    end
  end

  def instantiation_counter
    Class.new do
      def self.count = @count ||= 0
      def self.count! = @count = count + 1
    end
  end
end
