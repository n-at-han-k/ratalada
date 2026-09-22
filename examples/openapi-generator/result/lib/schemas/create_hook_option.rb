# frozen_string_literal: true

class Schemas::CreateHookOption
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "CreateHookOption options when create a hook",
    "type" => "object",
    "required" => ["type", "config"],
    "properties" => {
      "active" => {
        "type" => "boolean",
        "default" => false,
        "x-go-name" => "Active",
      },
      "authorization_header" => {"type" => "string", "x-go-name" => "AuthorizationHeader"},
      "branch_filter" => {"type" => "string", "x-go-name" => "BranchFilter"},
      "config" => {"$ref" => "#/components/schemas/CreateHookOptionConfig"},
      "events" => {
        "type" => "array",
        "items" => {"type" => "string"},
        "x-go-name" => "Events",
      },
      "type" => {
        "type" => "string",
        "enum" => [
          "forgejo",
          "dingtalk",
          "discord",
          "gitea",
          "gogs",
          "msteams",
          "slack",
          "telegram",
          "feishu",
          "wechatwork",
          "packagist",
        ],
        "x-go-name" => "Type",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
