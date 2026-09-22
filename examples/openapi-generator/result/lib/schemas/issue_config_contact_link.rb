# frozen_string_literal: true

class Schemas::IssueConfigContactLink
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "type" => "object",
    "properties" => {
      "about" => {"type" => "string", "x-go-name" => "About"},
      "name" => {"type" => "string", "x-go-name" => "Name"},
      "url" => {"type" => "string", "x-go-name" => "URL"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
