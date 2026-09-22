# frozen_string_literal: true

class Schemas::CreateAccessTokenOption
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "CreateAccessTokenOption options when create access token",
    "type" => "object",
    "required" => ["name"],
    "properties" => {
      "name" => {"type" => "string", "x-go-name" => "Name"},
      "repositories" => {
        "description" => "If provided and not-empty, creates an access token with access only to specified repositories.",
        "type" => "array",
        "items" => {"$ref" => "#/components/schemas/RepoTargetOption"},
        "x-go-name" => "Repositories",
      },
      "scopes" => {
        "type" => "array",
        "items" => {"type" => "string"},
        "x-go-name" => "Scopes",
        "example" => [
          "all",
          "read:activitypub",
          "read:issue",
          "write:misc",
          "read:notification",
          "read:organization",
          "read:package",
          "read:repository",
          "read:user",
        ],
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
