# frozen_string_literal: true

require "falcon"
require "falcon/environment/server"
require "async/service/configuration"
require "async/service/controller"
require "async/container"
require_relative "../ratalada"

module Ratalada
  module Backends
    module Falcon
      module_function

      # Runs the app the way `falcon host` does: declare a server environment,
      # hand it to Async::Service::Controller. The controller binds the socket
      # once in the parent, runs `count` supervised workers accepting from it
      # (restarts, health checks, INT/TERM/HUP handling all come with it).
      def run(app, host:, port:, count: 1)
        middleware = ::Falcon::Server.middleware(app)

        environment = Async::Service::Environment.new(::Falcon::Environment::Server).with(
          name: "ratalada",
          url: "http://#{host}:#{port}",
          middleware: -> { middleware },
          container_options: { count: count, restart: true },
        )

        configuration = Async::Service::Configuration.new
        configuration.add(environment)

        warn "ratalada: falcon listening on http://#{host}:#{port}#{" (#{count} workers)" if count > 1}"
        Async::Service::Controller.run(configuration, container_class: Async::Container.best_container_class)
      rescue Interrupt
        # clean shutdown
      end
    end
  end

  self.backend = Backends::Falcon
end
