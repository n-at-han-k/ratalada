# frozen_string_literal: true

class Schemas::WikiPage
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "WikiPage a wiki page",
    "type" => "object",
    "properties" => {
      "commit_count" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "CommitCount",
      },
      "content_base64" => {
        "description" => "Page content, base64 encoded",
        "type" => "string",
        "x-go-name" => "ContentBase64",
      },
      "footer" => {"type" => "string", "x-go-name" => "Footer"},
      "html_url" => {"type" => "string", "x-go-name" => "HTMLURL"},
      "last_commit" => {"$ref" => "#/components/schemas/WikiCommit"},
      "sidebar" => {"type" => "string", "x-go-name" => "Sidebar"},
      "sub_url" => {"type" => "string", "x-go-name" => "SubURL"},
      "title" => {"type" => "string", "x-go-name" => "Title"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
