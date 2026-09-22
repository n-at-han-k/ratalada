# frozen_string_literal: true

class Schemas::FileDeleteResponse
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "FileDeleteResponse contains information about a repo's file that was deleted",
    "type" => "object",
    "properties" => {
      "commit" => {"$ref" => "#/components/schemas/FileCommitResponse"},
      "content" => {"x-go-name" => "Content"},
      "verification" => {"$ref" => "#/components/schemas/PayloadCommitVerification"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
