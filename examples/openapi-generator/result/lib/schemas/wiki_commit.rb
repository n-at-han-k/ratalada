# frozen_string_literal: true

class Schemas::WikiCommit
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "WikiCommit page commit/revision",
    "type" => "object",
    "properties" => {
      "author" => {"$ref" => "#/components/schemas/CommitUser"},
      "commiter" => {"$ref" => "#/components/schemas/CommitUser"},
      "message" => {"type" => "string", "x-go-name" => "Message"},
      "sha" => {"type" => "string", "x-go-name" => "ID"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
