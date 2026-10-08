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
    # Frontends::Routes, in Protocol::HTTP terms: the same Server.run block,
    # the same handler kinds, no rack in the middle. Requiring ratalada/async
    # installs it in place of the rack router, because Async::HTTP::Server
    # already speaks this protocol and the adapter between them exists only to
    # translate for a frontend that does not.
    #
    # The block is handed the server's own Protocol::HTTP::Request. It sees
    # the same [verb, path] and {verb:, path:, query:} it sees on any other
    # backend (ratalada/protocol_http_ext teaches that class the patterns),
    # and #body is the body as it arrived rather than a String read out of it.
    # What it does not see is Rack::Request: no cookies, no session, no
    # form-body params, no Rack::Utils helpers in scope. Query params are
    # there as #params; the rest is rack's, so require a rack frontend --
    # ratalada/sinatra, or Frontends::Routes back again -- if you want them.
    module ProtocolRoutes
      # Tells the async backend to hand the app to Async::HTTP::Server whole
      # rather than wrapping it in Protocol::Rack::Adapter.
      def self.rack? = false

      def self.build(block) = App.new(block)

      # Server.use needs nothing special here: it chains
      # `klass.new(inner, *args)`, which is exactly
      # Protocol::HTTP::Middleware's interface -- `new(delegate)` answering
      # `call(request)`. So middleware on this frontend is Protocol::HTTP
      # middleware, chained with no adapter anywhere. Rack middleware belongs
      # to a rack frontend, where the backend adapts the lot in one go.

      class App
        def initialize(router)
          @router = router
        end

        # The request is the server's own Protocol::HTTP::Request, handed to
        # the router as it arrived -- it patterns on [verb, path] and carries
        # #params, #headers and a #body that streams, so there is nothing for
        # a wrapper to add.
        def call(request)
          begin
            handler = @router.call(request)
          rescue NoMatchingPatternError
            handler = nil
          end
          respond(handler, request)
        end

        # Middleware#close delegates down the chain on shutdown, and this is
        # the bottom of it.
        def close = nil

        private

          # Callable is #call, not Proc -- a handler object with a #call is as
          # callable as a lambda. It is tested last for a reason that bites
          # here specifically: Body::Readable#call(stream) is how a body
          # writes itself out, so a Readable answers #call. Tested any earlier
          # and `->(req) { req.body }` would have that body called with the
          # request instead of becoming the response.
          def respond(handler, request)
            case handler
            when nil
              ::Protocol::HTTP::Response[404, { "content-type" => "text/plain" }, ["not found"]]
            when String
              ::Protocol::HTTP::Response[200, { "content-type" => "text/plain" }, [handler]]
            # A body handed back as-is -- most usefully the request's own,
            # which makes an echo or a proxy a pass-through, nothing buffered.
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
    # Falcon without falcon: one Async::HTTP::Server in this process, no
    # container, no supervision, no restarts. Use ratalada/falcon when you
    # want those; this is the fiber-based server on its own.
    #
    # Named for the server it runs rather than the gem, because `Async` here
    # would shadow the async gem for every sibling in this namespace: an
    # unqualified `Async::Service` inside Backends::Falcon resolved to
    # `Ratalada::Backends::Async::Service` and broke that backend outright.
    module AsyncHTTP
      module_function

      def run(app, host:, port:, count: 1)
        if count > 1
          warn "ratalada: async backend ignores count: (single process — use ratalada/falcon)"
        end

        endpoint = ::Async::HTTP::Endpoint.parse("http://#{host}:#{port}")
        server = ::Async::HTTP::Server.new(adapt(app), endpoint)

        warn "ratalada: async listening on http://#{host}:#{port}"
        # #run wraps itself in Async{}, which outside a reactor starts one and
        # blocks until the accept loop ends.
        server.run
      rescue Interrupt
        # clean shutdown
      end

      # Async::HTTP::Server speaks Protocol::HTTP natively, so the adapter is
      # only in the way when the frontend does too -- which ProtocolRoutes,
      # installed below, does. Every other frontend (Routes, Builder, Sinatra,
      # Grape, Hanami, Roda) is rack and gets wrapped, without having to
      # declare anything: Ratalada.rack_frontend? assumes rack unless a
      # frontend says `def self.rack? = false`.
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

  # Only the default is replaced. A frontend require sets config.frontend
  # itself, so `require "ratalada/sinatra"` on either side of this one keeps
  # Sinatra (and its rack adapter) rather than racing with it.
  if config.frontend == Frontends::Routes
    config.frontend = Frontends::ProtocolRoutes
  end
end
