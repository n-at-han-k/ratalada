# frozen_string_literal: true

class Schemas::QuotaUsedSizeAssets
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "QuotaUsedSizeAssets represents the size-based asset usage of a user",
    "type" => "object",
    "properties" => {
      "artifacts" => {
        "description" => "Storage size used for the user's artifacts",
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "Artifacts",
      },
      "attachments" => {
        "$ref" => "#/components/schemas/QuotaUsedSizeAssetsAttachments",
      },
      "packages" => {
        "$ref" => "#/components/schemas/QuotaUsedSizeAssetsPackages",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
