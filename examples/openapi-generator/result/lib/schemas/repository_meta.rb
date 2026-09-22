# frozen_string_literal: true

class Schemas::RepositoryMeta
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "RepositoryMeta basic repository information",
    "type" => "object",
    "properties" => {
      "full_name" => {"type" => "string", "x-go-name" => "FullName"},
      "id" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "ID",
      },
      "name" => {"type" => "string", "x-go-name" => "Name"},
      "owner" => {"type" => "string", "x-go-name" => "Owner"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
