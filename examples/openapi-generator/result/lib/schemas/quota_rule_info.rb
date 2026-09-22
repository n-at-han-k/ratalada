# frozen_string_literal: true

class Schemas::QuotaRuleInfo
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "QuotaRuleInfo contains information about a quota rule",
    "type" => "object",
    "properties" => {
      "limit" => {
        "description" => "The limit set by the rule",
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "Limit",
      },
      "name" => {
        "description" => "Name of the rule (only shown to admins)",
        "type" => "string",
        "x-go-name" => "Name",
      },
      "subjects" => {
        "description" => "Subjects the rule affects",
        "type" => "array",
        "items" => {"type" => "string"},
        "x-go-name" => "Subjects",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
