# frozen_string_literal: true

class Schemas::FileLinksResponse
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "FileLinksResponse contains the links for a repo's file",
    "type" => "object",
    "properties" => {
      "git" => {"type" => "string", "x-go-name" => "GitURL"},
      "html" => {"type" => "string", "x-go-name" => "HTMLURL"},
      "self" => {"type" => "string", "x-go-name" => "Self"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
