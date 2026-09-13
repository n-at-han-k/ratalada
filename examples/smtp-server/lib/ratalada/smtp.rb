# frozen_string_literal: true

require "async/smtp"
require "ratalada"

module Ratalada
  module Frontends
    # SMTP's answer to Frontends::Routes. The Server.run block is a router: it
    # is called with each Protocol::SMTP::Message and returns a handler for
    # it, which this turns into the reply the client is given.
    #
    # async-smtp already reads a String as the text of a 250 and an exception
    # as a 451, so what is left here is the rest of ratalada's contract: a
    # callable, a bare code, a [code, text] pair, and no match at all.
    module Messages
      def self.build(block)
        App.new(block)
      end

      class App
        def initialize(router)
          @router = router
        end

        def call(message)
          respond(route(message), message)
        end

        private

          def route(message)
            @router.call(message)
          rescue NoMatchingPatternError, NoMatchingPatternKeyError
            nil
          end

          def respond(handler, message)
            case handler
            when nil
              # A fall-through `case ... in` is SMTP's 404.
              ::Protocol::SMTP::Reply.rejected
            when Proc, Method
              respond(handler.call(message), message)
            when Integer
              ::Protocol::SMTP::Reply.new(handler, "Ok")
            when Array
              status, text = handler
              ::Protocol::SMTP::Reply.new(status, text)
            else
              # A Reply as it stands, or a String async-smtp sends as a 250.
              handler
            end
          end
      end
    end
  end

  module Backends
    # Runs the app on async-smtp. Same contract as the puma and falcon
    # backends — run(app, host:, port:, count:) — for a socket that speaks
    # SMTP instead of HTTP.
    module Smtp
      module_function

      DEFAULT_DOMAIN = ENV.fetch("SMTP_DOMAIN", "ratalada.local")
      DEFAULT_PORT = Integer(ENV.fetch("PORT", "1025"))

      def run(app, host:, port:, count: 1, domain: DEFAULT_DOMAIN, **options)
        case count
        when 1 then nil
        else warn "ratalada: smtp backend ignores count: (not yet implemented)"
        end

        endpoint = ::Async::SMTP::Endpoint.for(host, smtp_port(port))
        warn "ratalada: async-smtp listening on smtp://#{host}:#{smtp_port(port)}"
        ::Async::SMTP::Server.new(app, endpoint, domain: domain, **options).run.wait
      rescue Interrupt
        # clean shutdown
      end

      # ratalada's default port is rack's, 9292, which no mail client will
      # look for — so an unasked-for port means 1025 here. PORT sets both, and
      # any other port: passes through. (Asking for 9292 explicitly is the one
      # thing this cannot hear; use PORT=9292.)
      def smtp_port(port)
        case port
        when Ratalada::DEFAULT_PORT then DEFAULT_PORT
        else port
        end
      end
    end
  end

  self.backend = Backends::Smtp
  self.frontend = Frontends::Messages
end
