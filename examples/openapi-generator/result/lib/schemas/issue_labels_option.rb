# frozen_string_literal: true

class Schemas::IssueLabelsOption
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "IssueLabelsOption a collection of labels",
    "type" => "object",
    "properties" => {
      "labels" => {
        "description" => "Labels can be a list of integers representing label IDs\nor a list of strings representing label names",
        "type" => "array",
        "items" => {},
        "x-go-name" => "Labels",
      },
      "updated_at" => {
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "Updated",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
