# frozen_string_literal: true

class Schemas::PullReviewComment
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "PullReviewComment represents a comment on a pull request review",
    "type" => "object",
    "properties" => {
      "body" => {"type" => "string", "x-go-name" => "Body"},
      "commit_id" => {"type" => "string", "x-go-name" => "CommitID"},
      "created_at" => {
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "Created",
      },
      "diff_hunk" => {"type" => "string", "x-go-name" => "DiffHunk"},
      "extra_lines_count" => {
        "description" => "number of additional lines after the commented line (0 = single line comment)",
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "ExtraLinesCount",
      },
      "html_url" => {"type" => "string", "x-go-name" => "HTMLURL"},
      "id" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "ID",
      },
      "original_commit_id" => {"type" => "string", "x-go-name" => "OrigCommitID"},
      "original_position" => {
        "type" => "integer",
        "format" => "uint64",
        "x-go-name" => "OldLineNum",
      },
      "path" => {"type" => "string", "x-go-name" => "Path"},
      "position" => {
        "type" => "integer",
        "format" => "uint64",
        "x-go-name" => "LineNum",
      },
      "pull_request_review_id" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "ReviewID",
      },
      "pull_request_url" => {"type" => "string", "x-go-name" => "HTMLPullURL"},
      "resolver" => {"$ref" => "#/components/schemas/User"},
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
