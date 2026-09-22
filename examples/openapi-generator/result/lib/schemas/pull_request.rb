# frozen_string_literal: true

class Schemas::PullRequest
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "PullRequest represents a pull request",
    "type" => "object",
    "properties" => {
      "additions" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "Additions",
      },
      "allow_maintainer_edit" => {"type" => "boolean", "x-go-name" => "AllowMaintainerEdit"},
      "assignee" => {"$ref" => "#/components/schemas/User"},
      "assignees" => {
        "type" => "array",
        "items" => {"$ref" => "#/components/schemas/User"},
        "x-go-name" => "Assignees",
      },
      "base" => {"$ref" => "#/components/schemas/PRBranchInfo"},
      "body" => {"type" => "string", "x-go-name" => "Body"},
      "changed_files" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "ChangedFiles",
      },
      "closed_at" => {
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "Closed",
      },
      "comments" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "Comments",
      },
      "created_at" => {
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "Created",
      },
      "deletions" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "Deletions",
      },
      "diff_url" => {"type" => "string", "x-go-name" => "DiffURL"},
      "draft" => {"type" => "boolean", "x-go-name" => "Draft"},
      "due_date" => {
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "Deadline",
      },
      "flow" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "Flow",
      },
      "head" => {"$ref" => "#/components/schemas/PRBranchInfo"},
      "html_url" => {"type" => "string", "x-go-name" => "HTMLURL"},
      "id" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "ID",
      },
      "is_locked" => {"type" => "boolean", "x-go-name" => "IsLocked"},
      "labels" => {
        "type" => "array",
        "items" => {"$ref" => "#/components/schemas/Label"},
        "x-go-name" => "Labels",
      },
      "merge_base" => {"type" => "string", "x-go-name" => "MergeBase"},
      "merge_commit_sha" => {"type" => "string", "x-go-name" => "MergedCommitID"},
      "mergeable" => {"type" => "boolean", "x-go-name" => "Mergeable"},
      "merged" => {"type" => "boolean", "x-go-name" => "HasMerged"},
      "merged_at" => {
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "Merged",
      },
      "merged_by" => {"$ref" => "#/components/schemas/User"},
      "milestone" => {"$ref" => "#/components/schemas/Milestone"},
      "number" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "Index",
      },
      "patch_url" => {"type" => "string", "x-go-name" => "PatchURL"},
      "pin_order" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "PinOrder",
      },
      "requested_reviewers" => {
        "type" => "array",
        "items" => {"$ref" => "#/components/schemas/User"},
        "x-go-name" => "RequestedReviewers",
      },
      "requested_reviewers_teams" => {
        "type" => "array",
        "items" => {"$ref" => "#/components/schemas/Team"},
        "x-go-name" => "RequestedReviewersTeams",
      },
      "review_comments" => {
        "description" => "number of review comments made on the diff of a PR review (not including comments on commits or issues in a PR)",
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "ReviewComments",
      },
      "state" => {"$ref" => "#/components/schemas/StateType"},
      "title" => {"type" => "string", "x-go-name" => "Title"},
      "updated_at" => {
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "Updated",
      },
      "url" => {"type" => "string", "x-go-name" => "URL"},
      "user" => {"$ref" => "#/components/schemas/User"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
