# frozen_string_literal: true

require "openapi_ruby"

# The document's own info and basePath. `prefix` scopes the validation
# middleware to the API, leaving anything else mounted alongside it alone.
OpenapiRuby.configure do |config|
  config.schemas = {
    <%= schema_name %>: {
      info: {title: <%= info["title"].to_s.inspect %>, version: <%= info.fetch("version", "1.0").to_s.inspect %>},
      servers: [{url: <%= (base.empty? ? "/" : base).inspect %>}],
      prefix: <%= (base.empty? ? "/" : base).inspect %>,
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
