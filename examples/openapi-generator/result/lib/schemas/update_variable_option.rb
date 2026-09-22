# frozen_string_literal: true

class Schemas::UpdateVariableOption
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "type" => "object",
    "title" => "UpdateVariableOption defines the properties of the variable to update.",
    "required" => ["value"],
    "properties" => {
      "name" => {
        "description" => "New name for the variable. If the field is empty, the variable name won't be updated. Forgejo will convert it to\nuppercase.",
        "type" => "string",
        "x-go-name" => "Name",
      },
      "value" => {
        "description" => "Value of the variable to update. Special characters will be retained. Line endings will be normalized to LF to\nmatch the behaviour of browsers. Encode the data with Base64 if line endings should be retained.",
        "type" => "string",
        "x-go-name" => "Value",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
