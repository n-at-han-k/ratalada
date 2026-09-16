# frozen_string_literal: true

require "securerandom"
require "rack/utils"

module Ratalada
  module Contrib
    module Inertia
      class CSRFMiddleware
        COOKIE_NAME = "XSRF-TOKEN"
        HEADER_KEY = "HTTP_X_XSRF_TOKEN"
        ENV_TOKEN_KEY = "ratalada.inertia.csrf_token"
        SAFE_METHODS = %w[GET HEAD OPTIONS].freeze

        def initialize(app, same_site: :Lax)
          @app = app
          @same_site = same_site
        end

        def call(env)
          existing = read_cookie(env)
          token = existing || SecureRandom.urlsafe_base64(32)
          env[ENV_TOKEN_KEY] = token

          if token_mismatch?(env, existing)
            forbidden(
              "CSRF token mismatch (expected matching X-XSRF-TOKEN header to XSRF-TOKEN cookie)",
            )
          else
            status, headers, body = @app.call(env)
            unless existing == token
              set_cookie!(headers, token)
            end
            [status, headers, body]
          end
        end

        private

          def safe_method?(env)
            SAFE_METHODS.include?(env["REQUEST_METHOD"])
          end

          def token_mismatch?(env, existing)
            if safe_method?(env)
              false
            else
              header = env[HEADER_KEY].to_s
              existing.nil? || header.empty? || !secure_compare(header, existing)
            end
          end

          def read_cookie(env)
            pairs = env["HTTP_COOKIE"].to_s.split(/;\s*/).map { |pair| pair.split("=", 2) }
            match = pairs.find { |name, _value| name == COOKIE_NAME }
            match && match[1]
          end

          def secure_compare(a, b)
            a = a.to_s
            b = b.to_s
            if a.bytesize != b.bytesize
              false
            else
              diff = 0
              a.bytes.zip(b.bytes) { |ai, bi| diff |= ai ^ bi }
              diff.zero?
            end
          end

          def set_cookie!(headers, token)
            cookie = ::Rack::Utils.set_cookie_header(
              COOKIE_NAME,
              value:     token,
              path:      "/",
              same_site: @same_site,
            )

            existing = headers["set-cookie"]
            if existing
              headers["set-cookie"] = Array(existing) + [cookie]
            else
              headers["set-cookie"] = cookie
            end
          end

          def forbidden(message)
            body = "#{message}\n"
            [
              403,
              {
                "content-type"   => "text/plain; charset=utf-8",
                "content-length" => body.bytesize.to_s,
              },
              [body]
            ]
          end
      end
    end
  end
end
