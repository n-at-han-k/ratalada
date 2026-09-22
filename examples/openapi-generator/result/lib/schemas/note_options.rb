# frozen_string_literal: true

class Schemas::NoteOptions
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "type" => "object",
    "properties" => {
      "message" => {"type" => "string", "x-go-name" => "Message"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
