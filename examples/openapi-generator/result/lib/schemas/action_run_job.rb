# frozen_string_literal: true

class Schemas::ActionRunJob
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "ActionRunJob represents a job of a run",
    "type" => "object",
    "properties" => {
      "attempt" => {
        "description" => "How many times the job has been attempted including the current attempt.",
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "Attempt",
      },
      "handle" => {
        "description" => "Opaque identifier that uniquely identifies a single attempt of a job.",
        "type" => "string",
        "x-go-name" => "Handle",
      },
      "html_url" => {
        "description" => "HTMLURL is the URL where a user can view the job using their browser.",
        "type" => "string",
        "x-go-name" => "HTMLURL",
      },
      "id" => {
        "description" => "Identifier of this job.",
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "ID",
      },
      "name" => {
        "description" => "the action run job name",
        "type" => "string",
        "x-go-name" => "Name",
      },
      "needs" => {
        "description" => "the action run job needed ids",
        "type" => "array",
        "items" => {"type" => "string"},
        "x-go-name" => "Needs",
      },
      "owner_id" => {
        "description" => "the owner id",
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "OwnerID",
      },
      "repo_id" => {
        "description" => "the repository id",
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "RepoID",
      },
      "run_id" => {
        "description" => "Identifier of the workflow run this job belongs to.",
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "RunID",
      },
      "runs_on" => {
        "description" => "the action run job labels to run on",
        "type" => "array",
        "items" => {"type" => "string"},
        "x-go-name" => "RunsOn",
      },
      "status" => {
        "description" => "the action run job status",
        "type" => "string",
        "x-go-name" => "Status",
      },
      "steps" => {
        "description" => "the steps that make up this workflow job's execution, including the\n\"Set up job\" entry (number=0) and \"Complete job\" tail. Only populated by\nendpoints that return a single job (e.g. GET /repos/{owner}/{repo}/actions/jobs/{job_id}).",
        "type" => "array",
        "items" => {"$ref" => "#/components/schemas/ActionRunJobStep"},
        "x-go-name" => "Steps",
      },
      "task_id" => {
        "description" => "the action run job latest task id",
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "TaskID",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
