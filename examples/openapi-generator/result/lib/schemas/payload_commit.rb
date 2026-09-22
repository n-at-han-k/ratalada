# frozen_string_literal: true

class Schemas::PayloadCommit
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "PayloadCommit represents a commit",
    "type" => "object",
    "properties" => {
      "added" => {
        "type" => "array",
        "items" => {"type" => "string"},
        "x-go-name" => "Added",
      },
      "author" => {"$ref" => "#/components/schemas/PayloadUser"},
      "committer" => {"$ref" => "#/components/schemas/PayloadUser"},
      "id" => {
        "description" => "sha1 hash of the commit",
        "type" => "string",
        "x-go-name" => "ID",
      },
      "message" => {"type" => "string", "x-go-name" => "Message"},
      "modified" => {
        "type" => "array",
        "items" => {"type" => "string"},
        "x-go-name" => "Modified",
      },
      "removed" => {
        "type" => "array",
        "items" => {"type" => "string"},
        "x-go-name" => "Removed",
      },
      "timestamp" => {
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "Timestamp",
      },
      "url" => {"type" => "string", "x-go-name" => "URL"},
      "verification" => {"$ref" => "#/components/schemas/PayloadCommitVerification"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
