# frozen_string_literal: true

class Schemas::GitHook
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "GitHook represents a Git repository hook",
    "type" => "object",
    "properties" => {
      "content" => {"type" => "string", "x-go-name" => "Content"},
      "is_active" => {"type" => "boolean", "x-go-name" => "IsActive"},
      "name" => {"type" => "string", "x-go-name" => "Name"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
