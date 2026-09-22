# frozen_string_literal: true

class Schemas::CreateLabelOption
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "CreateLabelOption options for creating a label",
    "type" => "object",
    "required" => ["name", "color"],
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
