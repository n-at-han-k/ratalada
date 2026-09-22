# frozen_string_literal: true

class Schemas::QuotaUsedSize
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "QuotaUsedSize represents the size-based quota usage of a user",
    "type" => "object",
    "properties" => {
      "assets" => {"$ref" => "#/components/schemas/QuotaUsedSizeAssets"},
      "git" => {"$ref" => "#/components/schemas/QuotaUsedSizeGit"},
      "repos" => {"$ref" => "#/components/schemas/QuotaUsedSizeRepos"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
