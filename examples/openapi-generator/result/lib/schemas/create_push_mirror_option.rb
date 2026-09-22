# frozen_string_literal: true

class Schemas::CreatePushMirrorOption
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "type" => "object",
    "title" => "CreatePushMirrorOption represents need information to create a push mirror of a repository.",
    "properties" => {
      "branch_filter" => {"type" => "string", "x-go-name" => "BranchFilter"},
      "interval" => {"type" => "string", "x-go-name" => "Interval"},
      "remote_address" => {"type" => "string", "x-go-name" => "RemoteAddress"},
      "remote_password" => {"type" => "string", "x-go-name" => "RemotePassword"},
      "remote_username" => {"type" => "string", "x-go-name" => "RemoteUsername"},
      "sync_on_commit" => {"type" => "boolean", "x-go-name" => "SyncOnCommit"},
      "use_ssh" => {"type" => "boolean", "x-go-name" => "UseSSH"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
