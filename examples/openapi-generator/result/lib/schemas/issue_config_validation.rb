# frozen_string_literal: true

class Schemas::IssueConfigValidation
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "type" => "object",
    "properties" => {
      "message" => {"type" => "string", "x-go-name" => "Message"},
      "valid" => {"type" => "boolean", "x-go-name" => "Valid"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
