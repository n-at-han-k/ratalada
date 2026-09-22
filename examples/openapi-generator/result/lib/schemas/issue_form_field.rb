# frozen_string_literal: true

class Schemas::IssueFormField
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "IssueFormField represents a form field",
    "type" => "object",
    "properties" => {
      "attributes" => {
        "type" => "object",
        "additionalProperties" => {},
        "x-go-name" => "Attributes",
      },
      "id" => {"type" => "string", "x-go-name" => "ID"},
      "type" => {"$ref" => "#/components/schemas/IssueFormFieldType"},
      "validations" => {
        "type" => "object",
        "additionalProperties" => {},
        "x-go-name" => "Validations",
      },
      "visible" => {
        "type" => "array",
        "items" => {"$ref" => "#/components/schemas/IssueFormFieldVisible"},
        "x-go-name" => "Visible",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
