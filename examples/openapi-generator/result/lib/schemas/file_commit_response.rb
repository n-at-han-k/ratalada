# frozen_string_literal: true

class Schemas::FileCommitResponse
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "type" => "object",
    "title" => "FileCommitResponse contains information generated from a Git commit for a repo's file.",
    "properties" => {
      "author" => {"$ref" => "#/components/schemas/CommitUser"},
      "committer" => {"$ref" => "#/components/schemas/CommitUser"},
      "created" => {
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "Created",
      },
      "html_url" => {"type" => "string", "x-go-name" => "HTMLURL"},
      "message" => {"type" => "string", "x-go-name" => "Message"},
      "parents" => {
        "type" => "array",
        "items" => {"$ref" => "#/components/schemas/CommitMeta"},
        "x-go-name" => "Parents",
      },
      "sha" => {"type" => "string", "x-go-name" => "SHA"},
      "tree" => {"$ref" => "#/components/schemas/CommitMeta"},
      "url" => {"type" => "string", "x-go-name" => "URL"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
