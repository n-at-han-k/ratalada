# frozen_string_literal: true

class Schemas::Activity
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "type" => "object",
    "properties" => {
      "act_user" => {"$ref" => "#/components/schemas/User"},
      "act_user_id" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "ActUserID",
      },
      "comment" => {"$ref" => "#/components/schemas/Comment"},
      "comment_id" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "CommentID",
      },
      "content" => {"type" => "string", "x-go-name" => "Content"},
      "created" => {
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "Created",
      },
      "id" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "ID",
      },
      "is_private" => {"type" => "boolean", "x-go-name" => "IsPrivate"},
      "op_type" => {
        "description" => "the type of action",
        "type" => "string",
        "enum" => [
          "create_repo",
          "rename_repo",
          "star_repo",
          "watch_repo",
          "commit_repo",
          "create_issue",
          "create_pull_request",
          "transfer_repo",
          "push_tag",
          "comment_issue",
          "merge_pull_request",
          "close_issue",
          "reopen_issue",
          "close_pull_request",
          "reopen_pull_request",
          "delete_tag",
          "delete_branch",
          "mirror_sync_push",
          "mirror_sync_create",
          "mirror_sync_delete",
          "approve_pull_request",
          "reject_pull_request",
          "comment_pull",
          "publish_release",
          "pull_review_dismissed",
          "pull_request_ready_for_review",
          "auto_merge_pull_request",
        ],
        "x-go-name" => "OpType",
      },
      "ref_name" => {"type" => "string", "x-go-name" => "RefName"},
      "repo" => {"$ref" => "#/components/schemas/Repository"},
      "repo_id" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "RepoID",
      },
      "user_id" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "UserID",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
