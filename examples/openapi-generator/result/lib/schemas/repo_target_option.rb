# frozen_string_literal: true

class Schemas::RepoTargetOption
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "type" => "object",
    "required" => ["owner", "name"],
    "properties" => {
      "name" => {
        "description" => "Name of repository",
        "type" => "string",
        "x-go-name" => "Name",
      },
      "owner" => {
        "description" => "Name of user or organisation that owns the repository",
        "type" => "string",
        "x-go-name" => "Owner",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
