# frozen_string_literal: true

class Schemas::MarkupOption
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "MarkupOption markup options",
    "type" => "object",
    "properties" => {
      "BranchPath" => {
        "description" => "The current branch path where the form gets posted",
        "type" => "string",
      },
      "Context" => {"description" => "Context to render", "type" => "string"},
      "FilePath" => {
        "description" => "File path for detecting extension in file mode",
        "type" => "string",
      },
      "Mode" => {
        "description" => "Mode to render (comment, gfm, markdown, file)",
        "type" => "string",
      },
      "Text" => {
        "description" => "Text markup to render",
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
