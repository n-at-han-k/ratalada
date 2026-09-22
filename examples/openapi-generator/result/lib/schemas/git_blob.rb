# frozen_string_literal: true

class Schemas::GitBlob
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "GitBlob represents a git blob",
    "type" => "object",
    "properties" => {
      "content" => {"type" => "string", "x-go-name" => "Content"},
      "encoding" => {"type" => "string", "x-go-name" => "Encoding"},
      "sha" => {"type" => "string", "x-go-name" => "SHA"},
      "size" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "Size",
      },
      "url" => {"type" => "string", "x-go-name" => "URL"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
