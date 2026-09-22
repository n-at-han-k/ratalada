# frozen_string_literal: true

class Schemas::Cron
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "Cron represents a Cron task",
    "type" => "object",
    "properties" => {
      "exec_times" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "ExecTimes",
      },
      "name" => {"type" => "string", "x-go-name" => "Name"},
      "next" => {
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "Next",
      },
      "prev" => {
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "Prev",
      },
      "schedule" => {"type" => "string", "x-go-name" => "Schedule"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
