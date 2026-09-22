# frozen_string_literal: true

class Schemas::EditHookOption
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "EditHookOption options when modify one hook",
    "type" => "object",
    "properties" => {
      "active" => {"type" => "boolean", "x-go-name" => "Active"},
      "authorization_header" => {"type" => "string", "x-go-name" => "AuthorizationHeader"},
      "branch_filter" => {"type" => "string", "x-go-name" => "BranchFilter"},
      "config" => {
        "type" => "object",
        "additionalProperties" => {"type" => "string"},
        "x-go-name" => "Config",
      },
      "events" => {
        "type" => "array",
        "items" => {"type" => "string"},
        "x-go-name" => "Events",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
