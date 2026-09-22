# frozen_string_literal: true

class Schemas::Email
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "Email an email address belonging to a user",
    "type" => "object",
    "properties" => {
      "email" => {
        "type" => "string",
        "format" => "email",
        "x-go-name" => "Email",
      },
      "primary" => {"type" => "boolean", "x-go-name" => "Primary"},
      "user_id" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "UserID",
      },
      "username" => {"type" => "string", "x-go-name" => "UserName"},
      "verified" => {"type" => "boolean", "x-go-name" => "Verified"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
