# frozen_string_literal: true

class Schemas::UpdateBranchRepoOption
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "UpdateBranchRepoOption options when updating a branch in a repository",
    "type" => "object",
    "required" => ["name"],
    "properties" => {
      "name" => {
        "description" => "New branch name",
        "type" => "string",
        "uniqueItems" => true,
        "x-go-name" => "Name",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
