# frozen_string_literal: true

class Schemas::PublicKey
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "PublicKey publickey is a user key to push code to repository",
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
      "key_type" => {"type" => "string", "x-go-name" => "KeyType"},
      "read_only" => {"type" => "boolean", "x-go-name" => "ReadOnly"},
      "title" => {"type" => "string", "x-go-name" => "Title"},
      "updated_at" => {
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "Updated",
      },
      "url" => {"type" => "string", "x-go-name" => "URL"},
      "user" => {"$ref" => "#/components/schemas/User"},
      "verified" => {"type" => "boolean", "x-go-name" => "Verified"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
