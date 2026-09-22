# frozen_string_literal: true

class Schemas::EditGitHookOption
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "EditGitHookOption options when modifying one Git hook",
    "type" => "object",
    "properties" => {
      "content" => {"type" => "string", "x-go-name" => "Content"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
