# frozen_string_literal: true

class Schemas::QuotaGroup
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "QuotaGroup represents a quota group",
    "type" => "object",
    "properties" => {
      "name" => {
        "description" => "Name of the group",
        "type" => "string",
        "x-go-name" => "Name",
      },
      "rules" => {
        "description" => "Rules associated with the group",
        "type" => "array",
        "items" => {"$ref" => "#/components/schemas/QuotaRuleInfo"},
        "x-go-name" => "Rules",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
