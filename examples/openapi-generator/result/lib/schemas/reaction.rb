# frozen_string_literal: true

class Schemas::Reaction
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "Reaction contain one reaction",
    "type" => "object",
    "properties" => {
      "content" => {"type" => "string", "x-go-name" => "Reaction"},
      "created_at" => {
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "Created",
      },
      "user" => {"$ref" => "#/components/schemas/User"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
