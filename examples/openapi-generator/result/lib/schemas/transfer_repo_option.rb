# frozen_string_literal: true

class Schemas::TransferRepoOption
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "TransferRepoOption options when transfer a repository's ownership",
    "type" => "object",
    "required" => ["new_owner"],
    "properties" => {
      "new_owner" => {"type" => "string", "x-go-name" => "NewOwner"},
      "team_ids" => {
        "description" => "ID of the team or teams to add to the repository. Teams can only be added to organization-owned repositories.",
        "type" => "array",
        "items" => {"type" => "integer", "format" => "int64"},
        "x-go-name" => "TeamIDs",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
