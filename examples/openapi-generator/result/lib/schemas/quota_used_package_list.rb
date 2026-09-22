# frozen_string_literal: true

class Schemas::QuotaUsedPackageList
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "QuotaUsedPackageList represents a list of packages counting towards a user's quota",
    "type" => "array",
    "items" => {"$ref" => "#/components/schemas/QuotaUsedPackage"},
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
