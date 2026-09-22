# frozen_string_literal: true

class Schemas::AddTimeOption
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "AddTimeOption options for adding time to an issue",
    "type" => "object",
    "required" => ["time"],
    "properties" => {
      "created" => {
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "Created",
      },
      "time" => {
        "description" => "time in seconds",
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "Time",
      },
      "user_name" => {
        "description" => "User who spent the time (optional)",
        "type" => "string",
        "x-go-name" => "User",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
