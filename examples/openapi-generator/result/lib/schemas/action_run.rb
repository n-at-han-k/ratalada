# frozen_string_literal: true

class Schemas::ActionRun
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "ActionRun represents an action run",
    "type" => "object",
    "properties" => {
      "ScheduleID" => {
        "description" => "the cron id for the schedule trigger",
        "type" => "integer",
        "format" => "int64",
      },
      "approved_by" => {
        "description" => "who approved this action run",
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "ApprovedBy",
      },
      "commit_sha" => {
        "description" => "the commit sha the action run ran on",
        "type" => "string",
        "x-go-name" => "CommitSHA",
      },
      "created" => {
        "description" => "when the action run was created",
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "Created",
      },
      "duration" => {"$ref" => "#/components/schemas/Duration"},
      "event" => {
        "description" => "the webhook event that causes the workflow to run",
        "type" => "string",
        "x-go-name" => "Event",
      },
      "event_payload" => {
        "description" => "the payload of the webhook event that causes the workflow to run",
        "type" => "string",
        "x-go-name" => "EventPayload",
      },
      "html_url" => {
        "description" => "the url of this action run",
        "type" => "string",
        "x-go-name" => "HTMLURL",
      },
      "id" => {
        "description" => "the action run id",
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "ID",
      },
      "index_in_repo" => {
        "description" => "a unique number for each run of a repository",
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "Index",
      },
      "is_fork_pull_request" => {
        "description" => "If this is triggered by a PR from a forked repository or an untrusted user, we need to check if it is approved and limit permissions when running the workflow.",
        "type" => "boolean",
        "x-go-name" => "IsForkPullRequest",
      },
      "is_ref_deleted" => {
        "description" => "has the commit/tag/… the action run ran on been deleted",
        "type" => "boolean",
        "x-go-name" => "IsRefDeleted",
      },
      "need_approval" => {
        "description" => "may need approval if it's a fork pull request",
        "type" => "boolean",
        "x-go-name" => "NeedApproval",
      },
      "prettyref" => {
        "description" => "the commit/tag/… the action run ran on",
        "type" => "string",
        "x-go-name" => "PrettyRef",
      },
      "repository" => {"$ref" => "#/components/schemas/Repository"},
      "started" => {
        "description" => "when the action run was started",
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "Started",
      },
      "status" => {
        "description" => "the current status of this run",
        "type" => "string",
        "x-go-name" => "Status",
      },
      "stopped" => {
        "description" => "when the action run was stopped",
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "Stopped",
      },
      "title" => {
        "description" => "the action run's title",
        "type" => "string",
        "x-go-name" => "Title",
      },
      "trigger_event" => {
        "description" => "the trigger event defined in the `on` configuration of the triggered workflow",
        "type" => "string",
        "x-go-name" => "TriggerEvent",
      },
      "trigger_user" => {"$ref" => "#/components/schemas/User"},
      "updated" => {
        "description" => "when the action run was last updated",
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "Updated",
      },
      "workflow_id" => {
        "description" => "the name of workflow file",
        "type" => "string",
        "x-go-name" => "WorkflowID",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
