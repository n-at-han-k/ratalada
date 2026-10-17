# frozen_string_literal: true

require "falcon"
require "falcon/environment/server"
require "async/service/configuration"
require "async/service/controller"
require "async/container"
require_relative "../ratalada"

module Ratalada
  module Backends
    # Falcon's backend; every Async constant is `::`-rooted.
    module Falcon
      module_function

      # Runs the app under Async::Service::Controller with supervised workers.
      #
      # @parameter app [Object] the rack app.
      # @parameter host [String] the bind host.
      # @parameter port [Integer] the bind port.
      # @parameter count [Integer] the number of workers.
      # @parameter cache [Boolean] enable the response cache (off by default: replay risk).
      # @returns [void]
      def run(app, host:, port:, count: 1, cache: false)
        middleware = ::Falcon::Server.rack_middleware(app, cache: cache)

        environment = ::Async::Service::Environment.new(::Falcon::Environment::Server).with(
          name:              "ratalada",
          url:               "http://#{host}:#{port}",
          middleware:        -> { middleware },
          container_options: { count: count, restart: true },
          # async-service >= 0.25 reads `root` in Managed::Service#preload! unconditionally (the default `preload` is `[]`, which is truthy), so an environment without one raises NoMethodError on boot.
          root:              Dir.pwd,
        )

        configuration = ::Async::Service::Configuration.new
        configuration.add(environment)

        if count > 1
          workers = " (#{count} workers)"
        else
          workers = ""
        end

        warn "ratalada: falcon listening on http://#{host}:#{port}#{workers}"
        ::Async::Service::Controller.run(
          configuration,
          container_class: ::Async::Container.best_container_class,
        )
      rescue Interrupt
        # clean shutdown
      end
    end
  end

  config.backend = Backends::Falcon
end
