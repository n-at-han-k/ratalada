# frozen_string_literal: true

class Schemas::Package
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "Package represents a package",
    "type" => "object",
    "properties" => {
      "created_at" => {
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "CreatedAt",
      },
      "creator" => {"$ref" => "#/components/schemas/User"},
      "html_url" => {"type" => "string", "x-go-name" => "HTMLURL"},
      "id" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "ID",
      },
      "name" => {"type" => "string", "x-go-name" => "Name"},
      "owner" => {"$ref" => "#/components/schemas/User"},
      "repository" => {"$ref" => "#/components/schemas/Repository"},
      "type" => {"type" => "string", "x-go-name" => "Type"},
      "version" => {"type" => "string", "x-go-name" => "Version"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
