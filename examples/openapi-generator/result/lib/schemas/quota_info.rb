# frozen_string_literal: true

class Schemas::QuotaInfo
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "QuotaInfo represents information about a user's quota",
    "type" => "object",
    "properties" => {
      "groups" => {"$ref" => "#/components/schemas/QuotaGroupList"},
      "used" => {"$ref" => "#/components/schemas/QuotaUsed"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
