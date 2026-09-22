# frozen_string_literal: true

class Schemas::CreateQuotaGroupOptions
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "CreateQutaGroupOptions represents the options for creating a quota group",
    "type" => "object",
    "properties" => {
      "name" => {
        "description" => "Name of the quota group to create",
        "type" => "string",
        "x-go-name" => "Name",
      },
      "rules" => {
        "description" => "Rules to add to the newly created group.\nIf a rule does not exist, it will be created.",
        "type" => "array",
        "items" => {"$ref" => "#/components/schemas/CreateQuotaRuleOptions"},
        "x-go-name" => "Rules",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
