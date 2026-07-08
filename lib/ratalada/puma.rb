# frozen_string_literal: true

require "puma"
require_relative "../ratalada"

module Ratalada
  module Backends
    module Puma
      module_function

      def run(app, host:, port:, count: 1)
        warn "ratalada: puma backend ignores count: (not yet implemented)" if count > 1
        server = ::Puma::Server.new(app)
        server.add_tcp_listener(host, port)
        warn "ratalada: puma listening on http://#{host}:#{port}"
        server.run.join
      rescue Interrupt
        server.stop(true)
      end
    end
  end

  self.backend = Backends::Puma
end
