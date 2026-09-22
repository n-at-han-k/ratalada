# frozen_string_literal: true

class Schemas::CreateIssueOption
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "CreateIssueOption options to create one issue",
    "type" => "object",
    "required" => ["title"],
    "properties" => {
      "assignee" => {
        "description" => "deprecated",
        "type" => "string",
        "x-go-name" => "Assignee",
      },
      "assignees" => {
        "type" => "array",
        "items" => {"type" => "string"},
        "x-go-name" => "Assignees",
      },
      "body" => {"type" => "string", "x-go-name" => "Body"},
      "closed" => {"type" => "boolean", "x-go-name" => "Closed"},
      "due_date" => {
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "Deadline",
      },
      "labels" => {
        "description" => "list of label ids",
        "type" => "array",
        "items" => {"type" => "integer", "format" => "int64"},
        "x-go-name" => "Labels",
      },
      "milestone" => {
        "description" => "milestone id",
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "Milestone",
      },
      "ref" => {"type" => "string", "x-go-name" => "Ref"},
      "title" => {"type" => "string", "x-go-name" => "Title"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
