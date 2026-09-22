# frozen_string_literal: true

class Schemas::Note
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "Note contains information related to a git note",
    "type" => "object",
    "properties" => {
      "commit" => {"$ref" => "#/components/schemas/Commit"},
      "message" => {"type" => "string", "x-go-name" => "Message"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
