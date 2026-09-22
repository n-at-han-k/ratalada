# frozen_string_literal: true

class Schemas::QuotaUsedArtifactList
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "QuotaUsedArtifactList represents a list of artifacts counting towards a user's quota",
    "type" => "array",
    "items" => {"$ref" => "#/components/schemas/QuotaUsedArtifact"},
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
