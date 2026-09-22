# frozen_string_literal: true

class Schemas::ActionTask
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "ActionTask represents a ActionTask",
    "type" => "object",
    "properties" => {
      "created_at" => {
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "CreatedAt",
      },
      "display_title" => {"type" => "string", "x-go-name" => "DisplayTitle"},
      "event" => {"type" => "string", "x-go-name" => "Event"},
      "head_branch" => {"type" => "string", "x-go-name" => "HeadBranch"},
      "head_sha" => {"type" => "string", "x-go-name" => "HeadSHA"},
      "id" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "ID",
      },
      "name" => {"type" => "string", "x-go-name" => "Name"},
      "run_number" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "RunNumber",
      },
      "run_started_at" => {
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "RunStartedAt",
      },
      "status" => {"type" => "string", "x-go-name" => "Status"},
      "updated_at" => {
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "UpdatedAt",
      },
      "url" => {"type" => "string", "x-go-name" => "URL"},
      "workflow_id" => {"type" => "string", "x-go-name" => "WorkflowID"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
