# frozen_string_literal: true

class Schemas::IssueMeta
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "IssueMeta basic issue information",
    "type" => "object",
    "required" => ["index", "owner", "repo"],
    "properties" => {
      "index" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "Index",
      },
      "owner" => {"type" => "string", "x-go-name" => "Owner"},
      "repo" => {"type" => "string", "x-go-name" => "Name"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
