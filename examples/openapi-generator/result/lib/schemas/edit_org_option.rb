# frozen_string_literal: true

class Schemas::EditOrgOption
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "EditOrgOption options for editing an organization",
    "type" => "object",
    "properties" => {
      "description" => {"type" => "string", "x-go-name" => "Description"},
      "email" => {"type" => "string", "x-go-name" => "Email"},
      "full_name" => {"type" => "string", "x-go-name" => "FullName"},
      "location" => {"type" => "string", "x-go-name" => "Location"},
      "repo_admin_change_team_access" => {
        "type" => "boolean",
        "x-go-name" => "RepoAdminChangeTeamAccess",
      },
      "visibility" => {
        "description" => "possible values are `public`, `limited` or `private`",
        "type" => "string",
        "enum" => ["public", "limited", "private"],
        "x-go-name" => "Visibility",
      },
      "website" => {"type" => "string", "x-go-name" => "Website"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
