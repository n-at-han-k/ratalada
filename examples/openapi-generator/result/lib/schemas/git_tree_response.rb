# frozen_string_literal: true

class Schemas::GitTreeResponse
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "GitTreeResponse returns a git tree",
    "type" => "object",
    "properties" => {
      "page" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "Page",
      },
      "sha" => {"type" => "string", "x-go-name" => "SHA"},
      "total_count" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "TotalCount",
      },
      "tree" => {
        "type" => "array",
        "items" => {"$ref" => "#/components/schemas/GitEntry"},
        "x-go-name" => "Entries",
      },
      "truncated" => {"type" => "boolean", "x-go-name" => "Truncated"},
      "url" => {"type" => "string", "x-go-name" => "URL"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
