# frozen_string_literal: true

class Schemas::RepoCollaboratorPermission
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "RepoCollaboratorPermission to get repository permission for a collaborator",
    "type" => "object",
    "properties" => {
      "permission" => {"type" => "string", "x-go-name" => "Permission"},
      "role_name" => {"type" => "string", "x-go-name" => "RoleName"},
      "user" => {"$ref" => "#/components/schemas/User"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
