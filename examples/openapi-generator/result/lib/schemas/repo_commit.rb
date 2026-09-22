# frozen_string_literal: true

class Schemas::RepoCommit
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "type" => "object",
    "title" => "RepoCommit contains information of a commit in the context of a repository.",
    "properties" => {
      "author" => {"$ref" => "#/components/schemas/CommitUser"},
      "committer" => {"$ref" => "#/components/schemas/CommitUser"},
      "message" => {"type" => "string", "x-go-name" => "Message"},
      "tree" => {"$ref" => "#/components/schemas/CommitMeta"},
      "url" => {"type" => "string", "x-go-name" => "URL"},
      "verification" => {"$ref" => "#/components/schemas/PayloadCommitVerification"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
