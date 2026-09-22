# frozen_string_literal: true

class Schemas::GitObject
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "type" => "object",
    "title" => "GitObject represents a Git object.",
    "properties" => {
      "sha" => {"type" => "string", "x-go-name" => "SHA"},
      "type" => {"type" => "string", "x-go-name" => "Type"},
      "url" => {"type" => "string", "x-go-name" => "URL"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
