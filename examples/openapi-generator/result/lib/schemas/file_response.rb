# frozen_string_literal: true

class Schemas::FileResponse
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "FileResponse contains information about a repo's file",
    "type" => "object",
    "properties" => {
      "commit" => {"$ref" => "#/components/schemas/FileCommitResponse"},
      "content" => {"$ref" => "#/components/schemas/ContentsResponse"},
      "verification" => {"$ref" => "#/components/schemas/PayloadCommitVerification"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
