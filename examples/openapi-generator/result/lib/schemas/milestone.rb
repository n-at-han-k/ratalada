# frozen_string_literal: true

class Schemas::Milestone
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "Milestone milestone is a collection of issues on one repository",
    "type" => "object",
    "properties" => {
      "closed_at" => {
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "Closed",
      },
      "closed_issues" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "ClosedIssues",
      },
      "created_at" => {
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "Created",
      },
      "description" => {"type" => "string", "x-go-name" => "Description"},
      "due_on" => {
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "Deadline",
      },
      "id" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "ID",
      },
      "open_issues" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "OpenIssues",
      },
      "state" => {"$ref" => "#/components/schemas/StateType"},
      "title" => {"type" => "string", "x-go-name" => "Title"},
      "updated_at" => {
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "Updated",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
