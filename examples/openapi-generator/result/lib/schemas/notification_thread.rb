# frozen_string_literal: true

class Schemas::NotificationThread
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "NotificationThread expose Notification on API",
    "type" => "object",
    "properties" => {
      "id" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "ID",
      },
      "pinned" => {"type" => "boolean", "x-go-name" => "Pinned"},
      "repository" => {"$ref" => "#/components/schemas/Repository"},
      "subject" => {"$ref" => "#/components/schemas/NotificationSubject"},
      "unread" => {"type" => "boolean", "x-go-name" => "Unread"},
      "updated_at" => {
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "UpdatedAt",
      },
      "url" => {"type" => "string", "x-go-name" => "URL"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
