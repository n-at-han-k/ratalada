# frozen_string_literal: true

class Schemas::QuotaUsedSizeAssetsPackages
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "QuotaUsedSizeAssetsPackages represents the size-based package quota usage of a user",
    "type" => "object",
    "properties" => {
      "all" => {
        "description" => "Storage suze used for the user's packages",
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "All",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
