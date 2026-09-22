# frozen_string_literal: true

class Schemas::CommitStats
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "CommitStats is statistics for a RepoCommit",
    "type" => "object",
    "properties" => {
      "additions" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "Additions",
      },
      "deletions" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "Deletions",
      },
      "total" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "Total",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
