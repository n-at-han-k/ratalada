# frozen_string_literal: true

class Schemas::TrackedTime
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "TrackedTime worked time for an issue / pr",
    "type" => "object",
    "properties" => {
      "created" => {
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "Created",
      },
      "id" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "ID",
      },
      "issue" => {"$ref" => "#/components/schemas/Issue"},
      "issue_id" => {
        "description" => "deprecated (only for backwards compatibility)",
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "IssueID",
      },
      "time" => {
        "description" => "Time in seconds",
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "Time",
      },
      "user_id" => {
        "description" => "deprecated (only for backwards compatibility)",
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "UserID",
      },
      "user_name" => {"type" => "string", "x-go-name" => "UserName"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
