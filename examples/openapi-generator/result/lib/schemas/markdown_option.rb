# frozen_string_literal: true

class Schemas::MarkdownOption
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "MarkdownOption markdown options",
    "type" => "object",
    "properties" => {
      "Context" => {"description" => "Context to render", "type" => "string"},
      "Mode" => {
        "description" => "Mode to render (comment, gfm, markdown)",
        "type" => "string",
      },
      "Text" => {
        "description" => "Text markdown to render",
        "type" => "string",
      },
      "Wiki" => {
        "description" => "Is it a wiki page ?",
        "type" => "boolean",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
