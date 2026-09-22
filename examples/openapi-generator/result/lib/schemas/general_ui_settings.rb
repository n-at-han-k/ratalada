# frozen_string_literal: true

class Schemas::GeneralUISettings
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "GeneralUISettings contains global ui settings exposed by API",
    "type" => "object",
    "properties" => {
      "allowed_reactions" => {
        "type" => "array",
        "items" => {"type" => "string"},
        "x-go-name" => "AllowedReactions",
      },
      "custom_emojis" => {
        "type" => "array",
        "items" => {"type" => "string"},
        "x-go-name" => "CustomEmojis",
      },
      "default_theme" => {"type" => "string", "x-go-name" => "DefaultTheme"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
