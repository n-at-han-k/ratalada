# frozen_string_literal: true

class Schemas::Compare
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "type" => "object",
    "title" => "Compare represents a comparison between two commits.",
    "properties" => {
      "commits" => {
        "type" => "array",
        "items" => {"$ref" => "#/components/schemas/Commit"},
        "x-go-name" => "Commits",
      },
      "files" => {
        "type" => "array",
        "items" => {"$ref" => "#/components/schemas/CommitAffectedFiles"},
        "x-go-name" => "Files",
      },
      "total_commits" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "TotalCommits",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
