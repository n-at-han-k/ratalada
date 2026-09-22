# frozen_string_literal: true

class Schemas::ActionRunJobStep
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "ActionRunJobStep is a step in a workflow job's execution. The slice on\nActionRunJob.Steps always includes a \"Set up job\" entry at number=0 and a\n\"Complete job\" entry as the last element; the entries in between are the\nworkflow's real steps in declaration order. The Number field is the value\naccepted by the job-logs endpoint's `?step=` filter.",
    "type" => "object",
    "properties" => {
      "name" => {
        "description" => "step name (workflow YAML `name:` for real steps; \"Set up job\" and\n\"Complete job\" for the head and tail respectively)",
        "type" => "string",
        "x-go-name" => "Name",
      },
      "number" => {
        "description" => "position in the job's step list. 0 is the \"Set up job\" entry; the last\nindex is the \"Complete job\" entry; real steps are numbered 1..N in\ndeclaration order.",
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "Number",
      },
      "started" => {
        "description" => "when the step started",
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "Started",
      },
      "status" => {
        "description" => "step status (success, failure, running, waiting, skipped, cancelled, ...)",
        "type" => "string",
        "x-go-name" => "Status",
      },
      "stopped" => {
        "description" => "when the step stopped",
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "Stopped",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
