# frozen_string_literal: true

class Schemas::AnnotatedTag
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "AnnotatedTag represents an annotated tag",
    "type" => "object",
    "properties" => {
      "archive_download_count" => {"$ref" => "#/components/schemas/TagArchiveDownloadCount"},
      "message" => {"type" => "string", "x-go-name" => "Message"},
      "object" => {"$ref" => "#/components/schemas/AnnotatedTagObject"},
      "sha" => {"type" => "string", "x-go-name" => "SHA"},
      "tag" => {"type" => "string", "x-go-name" => "Tag"},
      "tagger" => {"$ref" => "#/components/schemas/CommitUser"},
      "url" => {"type" => "string", "x-go-name" => "URL"},
      "verification" => {"$ref" => "#/components/schemas/PayloadCommitVerification"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
