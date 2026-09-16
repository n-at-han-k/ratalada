# frozen_string_literal: true

require "json"

module Ratalada
  module Contrib
    module Inertia
      # The Inertia client posts JSON, which Sinatra does not read into `params`.
      # This parses the body into the hash Rack::Request builds `params` from.
      class JSONParamsMiddleware
        def initialize(app) = @app = app

        def call(env)
          if env["CONTENT_TYPE"].to_s.start_with?("application/json")
            body = env["rack.input"]&.read
            env["rack.input"]&.rewind

            begin
              parsed = JSON.parse(body.to_s)
            rescue JSON::ParserError
              parsed = nil
            end

            if parsed.is_a?(Hash)
              env["rack.request.form_hash"] = parsed
              env["rack.request.form_input"] = env["rack.input"]
            end
          end

          @app.call(env)
        end
      end
    end
  end
end
