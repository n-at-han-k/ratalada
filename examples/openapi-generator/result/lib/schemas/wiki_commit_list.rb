# frozen_string_literal: true

class Schemas::WikiCommitList
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "WikiCommitList commit/revision list",
    "type" => "object",
    "properties" => {
      "commits" => {
        "type" => "array",
        "items" => {"$ref" => "#/components/schemas/WikiCommit"},
        "x-go-name" => "WikiCommits",
      },
      "count" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "Count",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
