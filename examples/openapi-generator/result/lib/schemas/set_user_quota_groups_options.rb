# frozen_string_literal: true

class Schemas::SetUserQuotaGroupsOptions
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "SetUserQuotaGroupsOptions represents the quota groups of a user",
    "type" => "object",
    "required" => ["groups"],
    "properties" => {
      "groups" => {
        "description" => "Quota groups the user shall have",
        "type" => "array",
        "items" => {"type" => "string"},
        "x-go-name" => "Groups",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
