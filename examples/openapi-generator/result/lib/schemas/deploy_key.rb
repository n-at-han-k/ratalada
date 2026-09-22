# frozen_string_literal: true

class Schemas::DeployKey
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "DeployKey a deploy key",
    "type" => "object",
    "properties" => {
      "created_at" => {
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "Created",
      },
      "fingerprint" => {"type" => "string", "x-go-name" => "Fingerprint"},
      "id" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "ID",
      },
      "key" => {"type" => "string", "x-go-name" => "Key"},
      "key_id" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "KeyID",
      },
      "read_only" => {"type" => "boolean", "x-go-name" => "ReadOnly"},
      "repository" => {"$ref" => "#/components/schemas/Repository"},
      "title" => {"type" => "string", "x-go-name" => "Title"},
      "url" => {"type" => "string", "x-go-name" => "URL"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
