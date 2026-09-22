# frozen_string_literal: true

class Schemas::AddCollaboratorOption
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "AddCollaboratorOption options when adding a user as a collaborator of a repository",
    "type" => "object",
    "properties" => {
      "permission" => {
        "type" => "string",
        "enum" => ["read", "write", "admin"],
        "x-go-name" => "Permission",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
