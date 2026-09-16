# frozen_string_literal: true

module Ratalada
  module Contrib
    module Inertia
      # Rack middleware for the Inertia protocol. Mirrors
      # InertiaRails::Middleware but built on plain Rack rather than
      # ActionDispatch — the gem's version also manages its Rails flash and
      # session keys, which this app does not use (errors live in
      # session[:_inertia_errors] and are swept by the render helpers).
      class Middleware
        INERTIA_HEADER = "HTTP_X_INERTIA"
        INERTIA_VERSION_HEADER = "HTTP_X_INERTIA_VERSION"
        REDIRECT_STATUSES = [301, 302, 303].freeze
        REWRITABLE_REDIRECT_STATUSES = [301, 302].freeze

        def initialize(app, version: -> { Ratalada::Contrib::Inertia.current_version })
          @app = app
          @version = version
        end

        def call(env)
          copy_xsrf_to_csrf!(env)
          status, headers, body = @app.call(env)

          if external_redirect?(env, status, headers)
            status, headers, body = convert_to_location_response!(headers, body)
          end

          # Only 301/302 are rewritten to 303: a 303 already forces a GET on
          # follow, and 307/308 preserve the request method by design.
          if inertia_non_get_redirect?(env, status)
            status = 303
          end

          # A response with X-Inertia-Location is already a full page visit —
          # nothing to refresh.
          if stale_inertia_get?(env) && !headers["X-Inertia-Location"]
            force_refresh(env)
          else
            [status, headers, body]
          end
        end

        private

          # XHR follows redirects transparently, so a cross-origin target is only
          # reachable through a window.location visit (409 + X-Inertia-Location).
          # 307/308 are excluded: a full page visit is always a GET.
          def external_redirect?(env, status, headers)
            inertia_request?(env) &&
              REDIRECT_STATUSES.include?(status) &&
              external_origin?(env, headers["Location"])
          end

          def external_origin?(env, location)
            uri = URI.parse(location.to_s)
            if uri.host.nil? || uri.host.empty?
              false
            else
              request = Rack::Request.new(env)
              scheme = uri.scheme || request.scheme
              port = uri.port || (scheme == "https" ? 443 : 80)

              scheme != request.scheme ||
                !uri.host.casecmp?(request.host) ||
                port != request.port
            end
          rescue URI::InvalidURIError
            false
          end

          # Mutates the headers in place to keep the rest of the response,
          # notably Set-Cookie (which matters mid-OAuth).
          def convert_to_location_response!(headers, body)
            headers["X-Inertia-Location"] = headers.delete("Location")
            headers.delete("Content-Type")
            headers.delete("Content-Length")
            if body.respond_to?(:close)
              body.close
            end

            [409, headers, []]
          end

          def inertia_non_get_redirect?(env, status)
            inertia_request?(env) &&
              REWRITABLE_REDIRECT_STATUSES.include?(status) &&
              %w[POST PUT PATCH DELETE].include?(env["REQUEST_METHOD"])
          end

          def stale_inertia_get?(env)
            env["REQUEST_METHOD"] == "GET" && inertia_request?(env) && version_mismatch?(env)
          end

          def inertia_request?(env)
            env[INERTIA_HEADER] == "true"
          end

          def version_mismatch?(env)
            current = current_version
            if current.nil? || current.empty?
              false
            else
              env[INERTIA_VERSION_HEADER].to_s != current
            end
          end

          def current_version
            if @version.respond_to?(:call)
              v = @version.call
            else
              v = @version
            end
            v.to_s
          end

          def force_refresh(env)
            location = env["REQUEST_URI"] || build_url(env)
            [409, { "x-inertia-location" => location, "vary" => "X-Inertia" }, []]
          end

          def copy_xsrf_to_csrf!(env)
            if env["HTTP_X_XSRF_TOKEN"]
              env["HTTP_X_CSRF_TOKEN"] = env["HTTP_X_XSRF_TOKEN"]
            end
          end

          def build_url(env)
            scheme = env["rack.url_scheme"] || "http"
            host = env["HTTP_HOST"] || env["SERVER_NAME"]
            path = env["PATH_INFO"]
            qs = env["QUERY_STRING"]
            full = +"#{scheme}://#{host}#{path}"
            if qs && !qs.empty?
              full << "?#{qs}"
            end
            full
          end
      end
    end
  end
end
