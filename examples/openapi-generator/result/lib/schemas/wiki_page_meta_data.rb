# frozen_string_literal: true

class Schemas::WikiPageMetaData
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "WikiPageMetaData wiki page meta information",
    "type" => "object",
    "properties" => {
      "html_url" => {"type" => "string", "x-go-name" => "HTMLURL"},
      "last_commit" => {"$ref" => "#/components/schemas/WikiCommit"},
      "sub_url" => {"type" => "string", "x-go-name" => "SubURL"},
      "title" => {"type" => "string", "x-go-name" => "Title"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
