# frozen_string_literal: true

class Schemas::CreatePullRequestOption
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "CreatePullRequestOption options when creating a pull request",
    "type" => "object",
    "properties" => {
      "assignee" => {"type" => "string", "x-go-name" => "Assignee"},
      "assignees" => {
        "type" => "array",
        "items" => {"type" => "string"},
        "x-go-name" => "Assignees",
      },
      "base" => {"type" => "string", "x-go-name" => "Base"},
      "body" => {"type" => "string", "x-go-name" => "Body"},
      "due_date" => {
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "Deadline",
      },
      "head" => {"type" => "string", "x-go-name" => "Head"},
      "labels" => {
        "type" => "array",
        "items" => {"type" => "integer", "format" => "int64"},
        "x-go-name" => "Labels",
      },
      "milestone" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "Milestone",
      },
      "title" => {"type" => "string", "x-go-name" => "Title"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
