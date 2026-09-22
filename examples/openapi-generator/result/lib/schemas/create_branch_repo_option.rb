# frozen_string_literal: true

class Schemas::CreateBranchRepoOption
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "CreateBranchRepoOption options when creating a branch in a repository",
    "type" => "object",
    "required" => ["new_branch_name"],
    "properties" => {
      "new_branch_name" => {
        "description" => "Name of the branch to create",
        "type" => "string",
        "uniqueItems" => true,
        "x-go-name" => "BranchName",
      },
      "old_branch_name" => {
        "description" => "Name of the old branch to create from",
        "type" => "string",
        "uniqueItems" => true,
        "x-deprecated" => true,
        "x-go-name" => "OldBranchName",
      },
      "old_ref_name" => {
        "description" => "Name of the old branch/tag/commit to create from",
        "type" => "string",
        "uniqueItems" => true,
        "x-go-name" => "OldRefName",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
