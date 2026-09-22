# frozen_string_literal: true

class Schemas::FilesResponse
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "FilesResponse contains information about multiple files from a repo",
    "type" => "object",
    "properties" => {
      "commit" => {"$ref" => "#/components/schemas/FileCommitResponse"},
      "files" => {
        "type" => "array",
        "items" => {"$ref" => "#/components/schemas/ContentsResponse"},
        "x-go-name" => "Files",
      },
      "verification" => {"$ref" => "#/components/schemas/PayloadCommitVerification"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
