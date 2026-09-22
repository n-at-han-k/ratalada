# frozen_string_literal: true

class Schemas::ActionVariable
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "ActionVariable return value of the query API",
    "type" => "object",
    "properties" => {
      "data" => {
        "description" => "the value of the variable",
        "type" => "string",
        "x-go-name" => "Data",
      },
      "name" => {
        "description" => "the name of the variable",
        "type" => "string",
        "x-go-name" => "Name",
      },
      "owner_id" => {
        "description" => "the owner to which the variable belongs",
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "OwnerID",
      },
      "repo_id" => {
        "description" => "the repository to which the variable belongs",
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "RepoID",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
