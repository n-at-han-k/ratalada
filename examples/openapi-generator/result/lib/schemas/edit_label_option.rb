# frozen_string_literal: true

class Schemas::EditLabelOption
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "EditLabelOption options for editing a label",
    "type" => "object",
    "properties" => {
      "color" => {
        "type" => "string",
        "x-go-name" => "Color",
        "example" => "#00aabb",
      },
      "description" => {"type" => "string", "x-go-name" => "Description"},
      "exclusive" => {
        "type" => "boolean",
        "x-go-name" => "Exclusive",
        "example" => false,
      },
      "is_archived" => {
        "type" => "boolean",
        "x-go-name" => "IsArchived",
        "example" => false,
      },
      "name" => {"type" => "string", "x-go-name" => "Name"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
