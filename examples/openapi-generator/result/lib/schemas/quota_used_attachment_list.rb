# frozen_string_literal: true

class Schemas::QuotaUsedAttachmentList
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "QuotaUsedAttachmentList represents a list of attachment counting towards a user's quota",
    "type" => "array",
    "items" => {"$ref" => "#/components/schemas/QuotaUsedAttachment"},
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
