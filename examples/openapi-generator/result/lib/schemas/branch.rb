# frozen_string_literal: true

class Schemas::Branch
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "Branch represents a repository branch",
    "type" => "object",
    "properties" => {
      "commit" => {"$ref" => "#/components/schemas/PayloadCommit"},
      "effective_branch_protection_name" => {
        "type" => "string",
        "x-go-name" => "EffectiveBranchProtectionName",
      },
      "enable_status_check" => {"type" => "boolean", "x-go-name" => "EnableStatusCheck"},
      "name" => {"type" => "string", "x-go-name" => "Name"},
      "protected" => {"type" => "boolean", "x-go-name" => "Protected"},
      "required_approvals" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "RequiredApprovals",
      },
      "status_check_contexts" => {
        "type" => "array",
        "items" => {"type" => "string"},
        "x-go-name" => "StatusCheckContexts",
      },
      "user_can_merge" => {"type" => "boolean", "x-go-name" => "UserCanMerge"},
      "user_can_push" => {"type" => "boolean", "x-go-name" => "UserCanPush"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
