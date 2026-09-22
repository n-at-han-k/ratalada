# frozen_string_literal: true

class Schemas::QuotaUsed
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "QuotaUsed represents the quota usage of a user",
    "type" => "object",
    "properties" => {"size" => {"$ref" => "#/components/schemas/QuotaUsedSize"}},
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
