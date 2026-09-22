# frozen_string_literal: true

class Schemas::ActionTaskResponse
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "ActionTaskResponse returns a ActionTask",
    "type" => "object",
    "properties" => {
      "total_count" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "TotalCount",
      },
      "workflow_runs" => {
        "type" => "array",
        "items" => {"$ref" => "#/components/schemas/ActionTask"},
        "x-go-name" => "Entries",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
