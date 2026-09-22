# frozen_string_literal: true

class Schemas::PRBranchInfo
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "PRBranchInfo information about a branch",
    "type" => "object",
    "properties" => {
      "label" => {"type" => "string", "x-go-name" => "Name"},
      "ref" => {"type" => "string", "x-go-name" => "Ref"},
      "repo" => {"$ref" => "#/components/schemas/Repository"},
      "repo_id" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "RepoID",
      },
      "sha" => {"type" => "string", "x-go-name" => "Sha"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
