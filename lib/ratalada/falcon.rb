# frozen_string_literal: true

require "falcon"
require "async"
require "async/http/endpoint"
require_relative "../ratalada"

module Ratalada
  module Backends
    module Falcon
      module_function

      def run(app, host:, port:)
        endpoint = Async::HTTP::Endpoint.parse("http://#{host}:#{port}")
        server = ::Falcon::Server.new(::Falcon::Server.middleware(app), endpoint)
        warn "ratalada: falcon listening on http://#{host}:#{port}"
        Sync { server.run.wait }
      rescue Interrupt
        # clean shutdown
      end
    end
  end

  self.backend = Backends::Falcon
end
