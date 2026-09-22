# frozen_string_literal: true

class Schemas::WatchInfo
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "WatchInfo represents an API watch status of one repository",
    "type" => "object",
    "properties" => {
      "created_at" => {
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "CreatedAt",
      },
      "ignored" => {"type" => "boolean", "x-go-name" => "Ignored"},
      "reason" => {"x-go-name" => "Reason"},
      "repository_url" => {"type" => "string", "x-go-name" => "RepositoryURL"},
      "subscribed" => {"type" => "boolean", "x-go-name" => "Subscribed"},
      "url" => {"type" => "string", "x-go-name" => "URL"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
