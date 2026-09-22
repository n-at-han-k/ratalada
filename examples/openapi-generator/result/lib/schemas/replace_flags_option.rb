# frozen_string_literal: true

class Schemas::ReplaceFlagsOption
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "ReplaceFlagsOption options when replacing the flags of a repository",
    "type" => "object",
    "properties" => {
      "flags" => {
        "type" => "array",
        "items" => {"type" => "string"},
        "x-go-name" => "Flags",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
