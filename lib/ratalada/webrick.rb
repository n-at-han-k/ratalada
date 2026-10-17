# frozen_string_literal: true

require "rackup/handler/webrick"
require_relative "../ratalada"

module Ratalada
  module Backends
    # Stdlib WEBrick, via rackup's handler; one thread per connection.
    module Webrick
      module_function

      def run(app, host:, port:, count: 1)
        if count > 1
          warn "ratalada: webrick backend ignores count: (single process)"
        end

        warn "ratalada: webrick listening on http://#{host}:#{port}"
        ::Rackup::Handler::WEBrick.run(app, Host: host, Port: port)
      rescue Interrupt
        ::Rackup::Handler::WEBrick.shutdown
      end
    end
  end

  config.backend = Backends::Webrick
end
