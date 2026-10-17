# frozen_string_literal: true

require "async/http/server"
require "async/http/endpoint"
require "protocol/http"
require "protocol/url"
require "protocol/rack/adapter"
require_relative "protocol_http_ext"
require_relative "../ratalada"

module Ratalada
  module Frontends
    # Frontends::Routes, in Protocol::HTTP terms.
    module ProtocolRoutes
      # Tells the async backend to skip the rack adapter.
      #
      # @returns [Boolean] false.
      def self.rack? = false

      def self.build(block) = App.new(block)

      # Server.use needs nothing special here: it chains `klass.new(inner, *args)`, which is exactly Protocol::HTTP::Middleware's interface -- `new(delegate)` answering `call(request)`. So middleware on this frontend is Protocol::HTTP middleware, chained with no adapter anywhere. Rack middleware belongs to a rack frontend, where the backend adapts the lot in one go.

      class App
        def initialize(router)
          @router = router
        end

        # Hands the router the server's own request, unwrapped.
        #
        # @parameter request [Protocol::HTTP::Request] the request as it arrived.
        # @returns [Object] the handler's response.
        def call(request)
          begin
            handler = @router.call(request)
          rescue NoMatchingPatternError
            handler = nil
          end
          respond(handler, request)
        end

        # The bottom of the middleware chain; delegates on shutdown.
        #
        # @returns [nil] nothing to close.
        def close = nil

        private

          # A handler object's #call is invoked; a Readable body is returned as-is.
          #
          # @parameter handler [Object] the router's return value.
          # @parameter request [Protocol::HTTP::Request] the current request.
          # @returns [Protocol::HTTP::Response] the response.
          def respond(handler, request)
            case handler
            when nil
              ::Protocol::HTTP::Response[404, { "content-type" => "text/plain" }, ["not found"]]
            when String
              ::Protocol::HTTP::Response[200, { "content-type" => "text/plain" }, [handler]]
            # A body handed back as-is -- most usefully the request's own, which makes an echo or a proxy a pass-through, nothing buffered.
            when ::Protocol::HTTP::Body::Readable
              ::Protocol::HTTP::Response[200, {}, handler]
            when Array
              status, headers, body = handler
              ::Protocol::HTTP::Response[status, headers, body.is_a?(String) ? [body] : body]
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

  module Backends
    # Falcon's server on its own, in this process.
    module AsyncHTTP
      module_function

      def run(app, host:, port:, count: 1)
        if count > 1
          warn "ratalada: async backend ignores count: (single process — use ratalada/falcon)"
        end

        endpoint = ::Async::HTTP::Endpoint.parse("http://#{host}:#{port}")
        server = ::Async::HTTP::Server.new(adapt(app), endpoint)

        warn "ratalada: async listening on http://#{host}:#{port}"
        # #run wraps itself in Async{}, which outside a reactor starts one and blocks until the accept loop ends.
        server.run
      rescue Interrupt
        # clean shutdown
      end

      # Wraps a rack frontend in Protocol::Rack::Adapter; others pass through.
      #
      # @parameter app [Object] the built app.
      # @returns [Object] the adapted app.
      def adapt(app)
        if Ratalada.rack_frontend?
          ::Protocol::Rack::Adapter.new(app)
        else
          app
        end
      end
    end
  end

  config.backend = Backends::AsyncHTTP

  # Only the default is replaced. A frontend require sets config.frontend itself, so `require "ratalada/sinatra"` on either side of this one keeps Sinatra (and its rack adapter) rather than racing with it.
  if config.frontend == Frontends::Routes
    config.frontend = Frontends::ProtocolRoutes
  end
end
