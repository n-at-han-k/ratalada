# frozen_string_literal: true

class Schemas::SyncForkInfo
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "SyncForkInfo information about syncing a fork",
    "type" => "object",
    "properties" => {
      "allowed" => {"type" => "boolean", "x-go-name" => "Allowed"},
      "base_commit" => {"type" => "string", "x-go-name" => "BaseCommit"},
      "commits_behind" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "CommitsBehind",
      },
      "fork_commit" => {"type" => "string", "x-go-name" => "ForkCommit"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
