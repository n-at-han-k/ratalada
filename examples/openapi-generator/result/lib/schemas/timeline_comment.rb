# frozen_string_literal: true

class Schemas::TimelineComment
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "TimelineComment represents a timeline comment (comment of any type) on a commit or issue",
    "type" => "object",
    "properties" => {
      "assignee" => {"$ref" => "#/components/schemas/User"},
      "assignee_team" => {"$ref" => "#/components/schemas/Team"},
      "body" => {"type" => "string", "x-go-name" => "Body"},
      "created_at" => {
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "Created",
      },
      "dependent_issue" => {"$ref" => "#/components/schemas/Issue"},
      "html_url" => {"type" => "string", "x-go-name" => "HTMLURL"},
      "id" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "ID",
      },
      "issue_url" => {"type" => "string", "x-go-name" => "IssueURL"},
      "label" => {"$ref" => "#/components/schemas/Label"},
      "milestone" => {"$ref" => "#/components/schemas/Milestone"},
      "new_ref" => {"type" => "string", "x-go-name" => "NewRef"},
      "new_title" => {"type" => "string", "x-go-name" => "NewTitle"},
      "old_milestone" => {"$ref" => "#/components/schemas/Milestone"},
      "old_project_id" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "OldProjectID",
      },
      "old_ref" => {"type" => "string", "x-go-name" => "OldRef"},
      "old_title" => {"type" => "string", "x-go-name" => "OldTitle"},
      "project_id" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "ProjectID",
      },
      "pull_request_url" => {"type" => "string", "x-go-name" => "PRURL"},
      "ref_action" => {"type" => "string", "x-go-name" => "RefAction"},
      "ref_comment" => {"$ref" => "#/components/schemas/Comment"},
      "ref_commit_sha" => {
        "description" => "commit SHA where issue/PR was referenced",
        "type" => "string",
        "x-go-name" => "RefCommitSHA",
      },
      "ref_issue" => {"$ref" => "#/components/schemas/Issue"},
      "removed_assignee" => {
        "description" => "whether the assignees were removed or added",
        "type" => "boolean",
        "x-go-name" => "RemovedAssignee",
      },
      "resolve_doer" => {"$ref" => "#/components/schemas/User"},
      "review_id" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "ReviewID",
      },
      "tracked_time" => {"$ref" => "#/components/schemas/TrackedTime"},
      "type" => {"type" => "string", "x-go-name" => "Type"},
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
