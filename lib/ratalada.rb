# frozen_string_literal: true

require "rack"
require "dry-configurable"
require_relative "ratalada/version"

module Ratalada
  DEFAULT_HOST = ENV.fetch("HOST", "127.0.0.1")
  DEFAULT_PORT = Integer(ENV.fetch("PORT", "9292"))
  DEFAULT_COUNT = Integer(ENV.fetch("COUNT", "1"))

  extend Dry::Configurable

  class Error < StandardError; end

  class NoBackendError < Error
    def initialize(msg = nil)
      super(msg || <<~MSG)
        No server backend selected. Require one before calling Server.run:

          require "ratalada/puma"     # or
          require "ratalada/falcon"   # or
          require "ratalada/async"    # or
          require "ratalada/webrick"
      MSG
    end
  end

  class << self
    # The backend runs a rack app; the frontend builds one from Server.run.
    #
    # @returns [Object] the configured backend.
    def backend
      config.backend or raise NoBackendError
    end

    def frontend = config.frontend

    # Whether the frontend speaks rack.
    #
    # @returns [Boolean] true unless the frontend declares `def self.rack? = false`.
    def rack_frontend?
      frontend = config.frontend

      !(frontend.respond_to?(:rack?) && !frontend.rack?)
    end
  end

  # Rack::Request plus just enough sugar to pattern match on, so everything rack already parses — params, cookies, headers, host, ip, session — comes along for free.
  class Request < ::Rack::Request
    # @returns [String] the request method; `path` is PATH_INFO, never rack's SCRIPT_NAME + PATH_INFO.
    def verb  = env["REQUEST_METHOD"]
    def path  = env["PATH_INFO"]
    def query = env["QUERY_STRING"]

    # The whole request body as a String, memoized because rack 3 reads once.
    #
    # @returns [String] the body.
    def body = @body ||= read
    def read(...) = env["rack.input"].read(...)

    # Enables `in ["GET", "/"]`.
    #
    # @returns [Array(String)] the verb and path.
    def deconstruct = [verb, path]

    # Enables `in {verb: "GET", path: "/users"}`.
    #
    # @parameter _keys [Array(Symbol)] ignored.
    # @returns [Hash] the request's matchable fields.
    def deconstruct_keys(_keys) = { verb:, path:, query:, env: }
  end

  module Frontends
    # The default DSL: the Server.run block is a router.
    module Routes
      def self.build(block)
        # Rack::Utils' helpers (escape_html, parse_query, set_cookie_header, ...) are callable unqualified inside the block, with no include at the call site and without instance_exec'ing it — self and ivars in the block stay the caller's. The include goes on the singleton of the object the block was written in, so nothing else in the process sees it, and since Rack::Utils is module_function'd they arrive as private methods that a receiver's own escape/status_code still overrides. ArgumentError: a C-level proc, which has no binding (&:symbol, #curry). TypeError: a frozen receiver. Neither can take the include; skip it.
        begin
          block.binding.receiver.singleton_class.include(::Rack::Utils)
        rescue ArgumentError, TypeError
          nil
        end
        App.new(block)
      end

      class App
        def initialize(router)
          @router = router
        end

        def call(env)
          request = Request.new(env)
          begin
            handler = @router.call(request)
          rescue NoMatchingPatternError
            handler = nil
          end
          respond(handler, request)
        end

        private

          # A handler that answers #call is called; every other shape is a response.
          #
          # @parameter handler [Object] the router's return value.
          # @parameter request [Request] the current request.
          # @returns [Array] the rack triplet.
          def respond(handler, request)
            case handler
            when nil
              [404, { "content-type" => "text/plain" }, ["not found"]]
            when String
              [200, { "content-type" => "text/plain" }, [handler]]
            when Array
              status, headers, body = handler
              [status, headers, body.is_a?(String) ? [body] : body]
            else
              if handler.respond_to?(:call)
                respond(handler.call(request), request)
              else
                handler
              end
            end
          end
      end
    end
  end

  module Server
    module_function

    # Adds rack middleware around the built app.
    #
    # @parameter middleware [Class] the middleware class.
    # @parameter args [Array] extra constructor arguments.
    # @parameter block [Proc] passed through to the middleware.
    # @returns [Stack] the chain, for further `use` calls.
    def use(middleware, *args, &block)
      Stack.new.use(middleware, *args, &block)
    end

    # Runs the app, in `count` worker processes sharing one socket.
    #
    # @parameter options [Hash] config settings written before boot.
    # @parameter block [Proc] builds the rack app.
    # @returns [Object] the backend's return value.
    def run(**options, &block)
      Stack.new.run(**options, &block)
    end

    # The chain Server.use returns. Collects middleware until run ends it.
    class Stack
      def initialize
        @middleware = []
      end

      def use(middleware, *args, &block)
        @middleware << [middleware, args, block]
        self
      end

      # Writes every option to Ratalada.config, then boots the backend.
      #
      # @parameter options [Hash] config settings (host, port, count).
      # @parameter block [Proc] builds the rack app.
      # @returns [Object] the backend's return value.
      def run(**options, &block)
        unless block
          raise ArgumentError, "Server.run requires a block"
        end

        if options.any?
          Ratalada.configure do |config|
            options.each do |key, value|
              config[key] = value
            end
          end
        end

        config = Ratalada.config
        unless config.count.is_a?(Integer) && config.count.positive?
          raise ArgumentError, "count must be a positive Integer"
        end

        Ratalada.backend.run(to_app(block), host: config.host, port: config.port, count: config.count)
      end

      # Wraps the frontend's app in the collected middleware; the first `use` is outermost.
      #
      # @parameter block [Proc] the Server.run body.
      # @returns [Object] the rack or Protocol::HTTP app.
      def to_app(block)
        @middleware.reverse.inject(Ratalada.frontend.build(block)) do |inner, (klass, args, blk)|
          klass.new(inner, *args, &blk)
        end
      end
    end
  end
end

# The whole point is a zero-ceremony top-level DSL.
unless defined?(Server)
  Server = Ratalada::Server
end

# Core settings. Contrib gems (ratalada-contrib et al.) register theirs the same way — Ratalada.setting at the bottom of their own file.
Ratalada.setting :backend
Ratalada.setting :frontend, default: Ratalada::Frontends::Routes
Ratalada.setting :host, default: Ratalada::DEFAULT_HOST
Ratalada.setting :port, default: Ratalada::DEFAULT_PORT, constructor: ->(value) { Integer(value) }
Ratalada.setting :count, default: Ratalada::DEFAULT_COUNT, constructor: ->(value) { Integer(value) }
