# frozen_string_literal: true

class Schemas::QuotaUsedSizeAssetsAttachments
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "QuotaUsedSizeAssetsAttachments represents the size-based attachment quota usage of a user",
    "type" => "object",
    "properties" => {
      "issues" => {
        "description" => "Storage size used for the user's issue & comment attachments",
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "Issues",
      },
      "releases" => {
        "description" => "Storage size used for the user's release attachments",
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "Releases",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
