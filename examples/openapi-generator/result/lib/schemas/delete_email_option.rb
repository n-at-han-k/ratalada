# frozen_string_literal: true

class Schemas::DeleteEmailOption
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "DeleteEmailOption options when deleting email addresses",
    "type" => "object",
    "properties" => {
      "emails" => {
        "description" => "email addresses to delete",
        "type" => "array",
        "items" => {"type" => "string"},
        "x-go-name" => "Emails",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
