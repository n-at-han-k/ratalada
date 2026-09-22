# frozen_string_literal: true

class Schemas::StopWatch
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "StopWatch represent a running stopwatch",
    "type" => "object",
    "properties" => {
      "created" => {
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "Created",
      },
      "duration" => {"type" => "string", "x-go-name" => "Duration"},
      "issue_index" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "IssueIndex",
      },
      "issue_title" => {"type" => "string", "x-go-name" => "IssueTitle"},
      "repo_name" => {"type" => "string", "x-go-name" => "RepoName"},
      "repo_owner_name" => {"type" => "string", "x-go-name" => "RepoOwnerName"},
      "seconds" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "Seconds",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
