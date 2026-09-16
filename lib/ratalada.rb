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

  # Rack::Request plus just enough sugar to pattern match on, so everything
  # rack already parses — params, cookies, headers, host, ip, session — comes
  # along for free.
  class Request < ::Rack::Request
    # #path is PATH_INFO, not rack's own #path (SCRIPT_NAME + PATH_INFO):
    # mounted under a `map`, routing here should match the path within this
    # app, not the one the outer app was reached by.
    def verb  = env["REQUEST_METHOD"]
    def path  = env["PATH_INFO"]
    def query = env["QUERY_STRING"]

    # Rack's own #body is the rack.input stream; this is the whole of it as a
    # String, memoized because rack 3 input reads once and does not rewind.
    # To stream instead, chunk through #read and never touch #body.
    def body = @body ||= read
    def read(...) = env["rack.input"].read(...)

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
        # Rack::Utils' helpers (escape_html, parse_query, set_cookie_header,
        # ...) are callable unqualified inside the block, with no include at the
        # call site and without instance_exec'ing it — self and ivars in the
        # block stay the caller's. The include goes on the singleton of the
        # object the block was written in, so nothing else in the process sees
        # it, and since Rack::Utils is module_function'd they arrive as private
        # methods that a receiver's own escape/status_code still overrides.
        # ArgumentError: a C-level proc, which has no binding (&:symbol, #curry).
        # TypeError: a frozen receiver. Neither can take the include; skip it.
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

    # Server.use(Middleware).use(Other).run { ... } — plain rack middleware
    # (it wraps the built app, so it is handed the env), instantiated once at
    # boot and applied outside whichever frontend built the app.
    def use(middleware, *args, &block)
      Stack.new.use(middleware, *args, &block)
    end

    # count runs that many worker processes accepting from a shared socket,
    # like node's cluster module. Each worker has its own state — anything
    # shared (sessions, caches) needs an external store or count: 1.
    #
    # host:, port: and count: are written through to Ratalada.config before
    # boot, so Server.run(port: 3000) is shorthand for configuring first.
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

      # Every option is a Ratalada.config setting name (host, port, count);
      # each is applied to the config verbatim — coercion and rejection of
      # unknown names are the settings' own. Skipped entirely when no
      # options are given so a finalized config can still boot.
      def run(**options, &block)
        raise ArgumentError, "Server.run requires a block" unless block

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

      # First `use` in the chain is the outermost, as in Rack::Builder.
      def to_app(block)
        @middleware.reverse.inject(Ratalada.frontend.build(block)) do |inner, (klass, args, blk)|
          klass.new(inner, *args, &blk)
        end
      end
    end
  end
end

# The whole point is a zero-ceremony top-level DSL.
Server = Ratalada::Server unless defined?(Server)

# Core settings. Contrib gems (ratalada-contrib et al.) register theirs the
# same way — Ratalada.setting at the bottom of their own file.
Ratalada.setting :host, default: Ratalada::DEFAULT_HOST
Ratalada.setting :port, default: Ratalada::DEFAULT_PORT, constructor: ->(value) { Integer(value) }
Ratalada.setting :count, default: Ratalada::DEFAULT_COUNT, constructor: ->(value) { Integer(value) }
