# frozen_string_literal: true

class Schemas::LabelTemplate
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "LabelTemplate info of a Label template",
    "type" => "object",
    "properties" => {
      "color" => {
        "type" => "string",
        "x-go-name" => "Color",
        "example" => "00aabb",
      },
      "description" => {"type" => "string", "x-go-name" => "Description"},
      "exclusive" => {
        "type" => "boolean",
        "x-go-name" => "Exclusive",
        "example" => false,
      },
      "name" => {"type" => "string", "x-go-name" => "Name"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
