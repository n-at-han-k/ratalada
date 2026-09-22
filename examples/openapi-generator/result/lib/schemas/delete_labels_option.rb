# frozen_string_literal: true

class Schemas::DeleteLabelsOption
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "DeleteLabelOption options for deleting a label",
    "type" => "object",
    "properties" => {
      "updated_at" => {
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "Updated",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
