# frozen_string_literal: true

class Schemas::EditReactionOption
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "EditReactionOption contain the reaction type",
    "type" => "object",
    "properties" => {
      "content" => {"type" => "string", "x-go-name" => "Reaction"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
