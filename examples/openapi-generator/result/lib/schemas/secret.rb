# frozen_string_literal: true

class Schemas::Secret
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "Secret represents a secret",
    "type" => "object",
    "properties" => {
      "created_at" => {
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "Created",
      },
      "name" => {
        "description" => "the secret's name",
        "type" => "string",
        "x-go-name" => "Name",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
