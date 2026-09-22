# frozen_string_literal: true

class Schemas::APINotFound
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "type" => "object",
    "properties" => {
      "errors" => {
        "type" => "array",
        "items" => {"type" => "string"},
        "x-go-name" => "Errors",
      },
      "message" => {"type" => "string", "x-go-name" => "Message"},
      "url" => {"type" => "string", "x-go-name" => "URL"},
    },
    "x-go-package" => "forgejo.org/services/context",
  })
end
