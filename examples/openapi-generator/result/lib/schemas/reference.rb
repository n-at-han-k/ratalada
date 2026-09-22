# frozen_string_literal: true

class Schemas::Reference
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "type" => "object",
    "title" => "Reference represents a Git reference.",
    "properties" => {
      "object" => {"$ref" => "#/components/schemas/GitObject"},
      "ref" => {"type" => "string", "x-go-name" => "Ref"},
      "url" => {"type" => "string", "x-go-name" => "URL"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
