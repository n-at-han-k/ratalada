# frozen_string_literal: true

class Schemas::RepoTransfer
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "RepoTransfer represents a pending repo transfer",
    "type" => "object",
    "properties" => {
      "doer" => {"$ref" => "#/components/schemas/User"},
      "recipient" => {"$ref" => "#/components/schemas/User"},
      "teams" => {
        "type" => "array",
        "items" => {"$ref" => "#/components/schemas/Team"},
        "x-go-name" => "Teams",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
