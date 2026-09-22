# frozen_string_literal: true

require "openapi_ruby"

# The document's own info and basePath. `prefix` scopes the validation
# middleware to the API, leaving anything else mounted alongside it alone.
OpenapiRuby.configure do |config|
  config.schemas = {
    public_api: {
      info: {title: "Forgejo API", version: "17.0.0-dev-555-733016624c+gitea-1.22.0"},
      servers: [{url: "/api/v1"}],
      prefix: "/api/v1",
    },
  }

  # The document is the source of truth for spelling; nothing is renamed.
  config.camelize_keys = false

  # The directory under this path names the namespace: lib/schemas/*.rb is
  # Schemas::*.
  config.component_paths = ["lib"]

  # Off for the specs, which validate against the declared operations
  # themselves. server.rb turns them on for the running app.
  config.request_validation = :disabled
  config.response_validation = :disabled
end
