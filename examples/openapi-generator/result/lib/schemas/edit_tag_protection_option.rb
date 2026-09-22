# frozen_string_literal: true

class Schemas::EditTagProtectionOption
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "EditTagProtectionOption options for editing a tag protection",
    "type" => "object",
    "properties" => {
      "name_pattern" => {"type" => "string", "x-go-name" => "NamePattern"},
      "whitelist_teams" => {
        "type" => "array",
        "items" => {"type" => "string"},
        "x-go-name" => "WhitelistTeams",
      },
      "whitelist_usernames" => {
        "type" => "array",
        "items" => {"type" => "string"},
        "x-go-name" => "WhitelistUsernames",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
