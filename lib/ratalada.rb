# frozen_string_literal: true

require_relative "ratalada/version"

module Ratalada
  DEFAULT_HOST = ENV.fetch("HOST", "127.0.0.1")
  DEFAULT_PORT = Integer(ENV.fetch("PORT", "9292"))

  class Error < StandardError; end

  class NoBackendError < Error
    def initialize(msg = nil)
      super(msg || <<~MSG)
        No server backend selected. Require one before calling Server.run:

          require "ratalada/puma"    # or
          require "ratalada/falcon"
      MSG
    end
  end

  class << self
    # The backend runs a rack app (set by requiring ratalada/puma or
    # ratalada/falcon); the frontend turns the Server.run block into a rack
    # app (the built-in router by default, ratalada/sinatra to swap it).
    attr_writer :backend, :frontend

    def backend
      @backend or raise NoBackendError
    end

    def frontend
      @frontend ||= Frontends::Routes
    end
  end

  # Wraps the Rack env with just enough sugar to pattern match on.
  class Request
    attr_reader :env

    def initialize(env)
      @env = env
    end

    def verb  = env["REQUEST_METHOD"]
    def path  = env["PATH_INFO"]
    def query = env["QUERY_STRING"]
    def body  = @body ||= env["rack.input"]&.read

    # Enables `in ["GET", "/"]`
    def deconstruct = [verb, path]

    # Enables `in {verb: "GET", path: "/users"}`
    def deconstruct_keys(_keys) = { verb:, path:, query:, env: }
  end

  module Frontends
    # The default DSL: the Server.run block is a router. It is called with
    # each Request and returns a handler for it — a callable (called with the
    # request), a response body String, or a full [status, headers, body]
    # triplet. No match (nil, or a fall-through `case ... in`) means 404.
    module Routes
      def self.build(block)
        App.new(block)
      end

      class App
        def initialize(router)
          @router = router
        end

        def call(env)
          request = Request.new(env)
          handler = begin
            @router.call(request)
          rescue NoMatchingPatternError
            nil
          end
          respond(handler, request)
        end

        private

        def respond(handler, request)
          case handler
          when nil
            [404, { "content-type" => "text/plain" }, ["not found"]]
          when Proc, Method
            respond(handler.call(request), request)
          when String
            [200, { "content-type" => "text/plain" }, [handler]]
          when Array
            status, headers, body = handler
            [status, headers, body.is_a?(String) ? [body] : body]
          else
            handler
          end
        end
      end
    end
  end

  module Server
    module_function

    def run(host: DEFAULT_HOST, port: DEFAULT_PORT, &block)
      raise ArgumentError, "Server.run requires a block" unless block

      app = Ratalada.frontend.build(block)
      Ratalada.backend.run(app, host: host, port: port)
    end
  end
end

# The whole point is a zero-ceremony top-level DSL.
Server = Ratalada::Server unless defined?(Server)
