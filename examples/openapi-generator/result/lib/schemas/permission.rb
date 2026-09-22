# frozen_string_literal: true

class Schemas::Permission
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "Permission represents a set of permissions",
    "type" => "object",
    "properties" => {
      "admin" => {"type" => "boolean", "x-go-name" => "Admin"},
      "pull" => {"type" => "boolean", "x-go-name" => "Pull"},
      "push" => {"type" => "boolean", "x-go-name" => "Push"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
