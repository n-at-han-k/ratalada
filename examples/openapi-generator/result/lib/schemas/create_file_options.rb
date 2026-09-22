# frozen_string_literal: true

class Schemas::CreateFileOptions
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "CreateFileOptions options for creating files\nNote: `author` and `committer` are optional (if only one is given, it will be used for the other, otherwise the authenticated user will be used)",
    "type" => "object",
    "required" => ["content"],
    "properties" => {
      "author" => {"$ref" => "#/components/schemas/Identity"},
      "branch" => {
        "description" => "branch (optional) to base this file from. if not given, the default branch is used",
        "type" => "string",
        "x-go-name" => "BranchName",
      },
      "committer" => {"$ref" => "#/components/schemas/Identity"},
      "content" => {
        "description" => "content must be base64 encoded",
        "type" => "string",
        "x-go-name" => "ContentBase64",
      },
      "dates" => {"$ref" => "#/components/schemas/CommitDateOptions"},
      "force_overwrite_new_branch" => {
        "description" => "(optional) will do a force-push if the new branch already exists",
        "type" => "boolean",
        "x-go-name" => "ForceOverwriteNewBranch",
      },
      "message" => {
        "description" => "message (optional) for the commit of this file. if not supplied, a default message will be used",
        "type" => "string",
        "x-go-name" => "Message",
      },
      "new_branch" => {
        "description" => "new_branch (optional) will make a new branch from `branch` before creating the file",
        "type" => "string",
        "x-go-name" => "NewBranchName",
      },
      "signoff" => {
        "description" => "Add a Signed-off-by trailer by the committer at the end of the commit log message.",
        "type" => "boolean",
        "x-go-name" => "Signoff",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
