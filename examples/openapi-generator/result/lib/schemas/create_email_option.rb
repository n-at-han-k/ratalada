# frozen_string_literal: true

class Schemas::CreateEmailOption
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "CreateEmailOption options when creating email addresses",
    "type" => "object",
    "properties" => {
      "emails" => {
        "description" => "email addresses to add",
        "type" => "array",
        "items" => {"type" => "string"},
        "x-go-name" => "Emails",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
