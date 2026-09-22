# frozen_string_literal: true

class Schemas::QuotaGroupList
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "QuotaGroupList represents a list of quota groups",
    "type" => "array",
    "items" => {"$ref" => "#/components/schemas/QuotaGroup"},
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
