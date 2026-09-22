# frozen_string_literal: true

class Schemas::PullReview
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "PullReview represents a pull request review",
    "type" => "object",
    "properties" => {
      "body" => {"type" => "string", "x-go-name" => "Body"},
      "comments_count" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "CodeCommentsCount",
      },
      "commit_id" => {"type" => "string", "x-go-name" => "CommitID"},
      "dismissed" => {"type" => "boolean", "x-go-name" => "Dismissed"},
      "html_url" => {"type" => "string", "x-go-name" => "HTMLURL"},
      "id" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "ID",
      },
      "official" => {"type" => "boolean", "x-go-name" => "Official"},
      "pull_request_url" => {"type" => "string", "x-go-name" => "HTMLPullURL"},
      "stale" => {"type" => "boolean", "x-go-name" => "Stale"},
      "state" => {"$ref" => "#/components/schemas/ReviewStateType"},
      "submitted_at" => {
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "Submitted",
      },
      "team" => {"$ref" => "#/components/schemas/Team"},
      "updated_at" => {
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "Updated",
      },
      "user" => {"$ref" => "#/components/schemas/User"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
