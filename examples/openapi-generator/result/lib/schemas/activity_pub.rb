# frozen_string_literal: true

class Schemas::ActivityPub
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "ActivityPub type",
    "type" => "object",
    "properties" => {
      "@context" => {"type" => "string", "x-go-name" => "Context"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
