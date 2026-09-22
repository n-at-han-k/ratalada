# frozen_string_literal: true

class Schemas::CreateQuotaRuleOptions
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "CreateQuotaRuleOptions represents the options for creating a quota rule",
    "type" => "object",
    "properties" => {
      "limit" => {
        "description" => "The limit set by the rule",
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "Limit",
      },
      "name" => {
        "description" => "Name of the rule to create",
        "type" => "string",
        "x-go-name" => "Name",
      },
      "subjects" => {
        "description" => "The subjects affected by the rule",
        "type" => "array",
        "items" => {"type" => "string"},
        "x-go-name" => "Subjects",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
