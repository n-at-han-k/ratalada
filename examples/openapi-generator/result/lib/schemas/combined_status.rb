# frozen_string_literal: true

class Schemas::CombinedStatus
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "CombinedStatus holds the combined state of several statuses for a single commit",
    "type" => "object",
    "properties" => {
      "commit_url" => {"type" => "string", "x-go-name" => "CommitURL"},
      "repository" => {"$ref" => "#/components/schemas/Repository"},
      "sha" => {"type" => "string", "x-go-name" => "SHA"},
      "state" => {"$ref" => "#/components/schemas/CommitStatusState"},
      "statuses" => {
        "type" => "array",
        "items" => {"$ref" => "#/components/schemas/CommitStatus"},
        "x-go-name" => "Statuses",
      },
      "total_count" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "TotalCount",
      },
      "url" => {"type" => "string", "x-go-name" => "URL"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
