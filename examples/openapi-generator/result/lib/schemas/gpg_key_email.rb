# frozen_string_literal: true

class Schemas::GPGKeyEmail
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "GPGKeyEmail an email attached to a GPGKey",
    "type" => "object",
    "properties" => {
      "email" => {"type" => "string", "x-go-name" => "Email"},
      "verified" => {"type" => "boolean", "x-go-name" => "Verified"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
