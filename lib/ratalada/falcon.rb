# frozen_string_literal: true

require "falcon"
require "async"
require "async/container"
require "async/http/endpoint"
require_relative "../ratalada"

module Ratalada
  module Backends
    module Falcon
      module_function

      def run(app, host:, port:, count: 1)
        endpoint = Async::HTTP::Endpoint.parse("http://#{host}:#{port}")
        middleware = ::Falcon::Server.middleware(app)

        if count == 1
          server = ::Falcon::Server.new(middleware, endpoint)
          warn "ratalada: falcon listening on http://#{host}:#{port}"
          Sync { server.run.wait }
        else
          run_container(middleware, endpoint, count: count)
        end
      rescue Interrupt
        # clean shutdown
      end

      # One reactor handles any amount of concurrent IO, but only one core of
      # Ruby. Workers are forked processes accepting from a socket bound once
      # in the parent — node's cluster model. Worker state is per-process.
      def run_container(middleware, endpoint, count:)
        bound = Sync { endpoint.bound }
        container = Async::Container::Forked.new

        warn "ratalada: falcon listening on http://#{endpoint.authority} (#{count} workers)"

        container.run(count: count, restart: true) do |instance|
          Sync do
            server = ::Falcon::Server.new(
              middleware, bound,
              protocol: endpoint.protocol, scheme: endpoint.scheme,
            )
            instance.ready!
            server.run.wait
          end
        end

        container.wait
      ensure
        container&.stop
        bound&.close
      end
    end
  end

  self.backend = Backends::Falcon
end
