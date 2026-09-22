# frozen_string_literal: true

class Schemas::Commit
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "type" => "object",
    "title" => "Commit contains information generated from a Git commit.",
    "properties" => {
      "author" => {"$ref" => "#/components/schemas/User"},
      "commit" => {"$ref" => "#/components/schemas/RepoCommit"},
      "committer" => {"$ref" => "#/components/schemas/User"},
      "created" => {
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "Created",
      },
      "files" => {
        "type" => "array",
        "items" => {"$ref" => "#/components/schemas/CommitAffectedFiles"},
        "x-go-name" => "Files",
      },
      "html_url" => {"type" => "string", "x-go-name" => "HTMLURL"},
      "parents" => {
        "type" => "array",
        "items" => {"$ref" => "#/components/schemas/CommitMeta"},
        "x-go-name" => "Parents",
      },
      "sha" => {"type" => "string", "x-go-name" => "SHA"},
      "stats" => {"$ref" => "#/components/schemas/CommitStats"},
      "url" => {"type" => "string", "x-go-name" => "URL"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
