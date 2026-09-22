# frozen_string_literal: true

class Schemas::Identity
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "Identity for a person's identity like an author or committer",
    "type" => "object",
    "properties" => {
      "email" => {
        "type" => "string",
        "format" => "email",
        "x-go-name" => "Email",
      },
      "name" => {"type" => "string", "x-go-name" => "Name"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
