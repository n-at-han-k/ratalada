# frozen_string_literal: true

class Schemas::GitignoreTemplateInfo
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "GitignoreTemplateInfo name and text of a gitignore template",
    "type" => "object",
    "properties" => {
      "name" => {"type" => "string", "x-go-name" => "Name"},
      "source" => {"type" => "string", "x-go-name" => "Source"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
