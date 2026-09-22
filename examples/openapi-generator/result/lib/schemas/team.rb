# frozen_string_literal: true

class Schemas::Team
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "Team represents a team in an organization",
    "type" => "object",
    "properties" => {
      "can_create_org_repo" => {"type" => "boolean", "x-go-name" => "CanCreateOrgRepo"},
      "description" => {"type" => "string", "x-go-name" => "Description"},
      "id" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "ID",
      },
      "includes_all_repositories" => {
        "type" => "boolean",
        "x-go-name" => "IncludesAllRepositories",
      },
      "name" => {"type" => "string", "x-go-name" => "Name"},
      "organization" => {"$ref" => "#/components/schemas/Organization"},
      "permission" => {
        "type" => "string",
        "enum" => ["none", "read", "write", "admin", "owner"],
        "x-go-name" => "Permission",
      },
      "units" => {
        "description" => "\nDeprecated: This variable should be replaced by UnitsMap and will be dropped in later versions.",
        "type" => "array",
        "items" => {"type" => "string"},
        "x-deprecated" => true,
        "x-go-name" => "Units",
        "example" => [
          "repo.code",
          "repo.issues",
          "repo.ext_issues",
          "repo.wiki",
          "repo.pulls",
          "repo.releases",
          "repo.projects",
          "repo.ext_wiki",
        ],
      },
      "units_map" => {
        "type" => "object",
        "additionalProperties" => {"type" => "string"},
        "x-go-name" => "UnitsMap",
        "example" => {
          "repo.actions" => "none",
          "repo.code" => "read",
          "repo.ext_issues" => "none",
          "repo.ext_wiki" => "none",
          "repo.issues" => "write",
          "repo.packages" => "none",
          "repo.projects" => "none",
          "repo.pulls" => "owner",
          "repo.releases" => "none",
          "repo.wiki" => "admin",
        },
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
