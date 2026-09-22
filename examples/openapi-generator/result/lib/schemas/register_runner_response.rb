# frozen_string_literal: true

class Schemas::RegisterRunnerResponse
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "type" => "object",
    "title" => "RegisterRunnerResponse contains the details of the just registered runner.",
    "properties" => {
      "id" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "ID",
      },
      "token" => {"type" => "string", "x-go-name" => "Token"},
      "uuid" => {"type" => "string", "x-go-name" => "UUID"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
