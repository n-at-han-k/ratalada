# frozen_string_literal: true

require "async/http/server"
require "async/http/endpoint"
require "protocol/rack/adapter"
require_relative "../ratalada"

module Ratalada
  module Backends
    # Falcon without falcon: one Async::HTTP::Server in this process, no
    # container, no supervision, no restarts. Use ratalada/falcon when you
    # want those; this is the fiber-based server on its own.
    module Async
      module_function

      def run(app, host:, port:, count: 1)
        if count > 1
          warn "ratalada: async backend ignores count: (single process — use ratalada/falcon)"
        end

        endpoint = ::Async::HTTP::Endpoint.parse("http://#{host}:#{port}")
        server = ::Async::HTTP::Server.new(::Protocol::Rack::Adapter.new(app), endpoint)

        warn "ratalada: async listening on http://#{host}:#{port}"
        # #run wraps itself in Async{}, which outside a reactor starts one and
        # blocks until the accept loop ends.
        server.run
      rescue Interrupt
        # clean shutdown
      end
    end
  end

  config.backend = Backends::Async
end
