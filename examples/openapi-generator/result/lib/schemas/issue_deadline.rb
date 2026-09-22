# frozen_string_literal: true

class Schemas::IssueDeadline
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "IssueDeadline represents an issue deadline",
    "type" => "object",
    "properties" => {
      "due_date" => {
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "Deadline",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
