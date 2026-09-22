# frozen_string_literal: true

class Schemas::NotificationCount
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "NotificationCount number of unread notifications",
    "type" => "object",
    "properties" => {
      "new" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "New",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
