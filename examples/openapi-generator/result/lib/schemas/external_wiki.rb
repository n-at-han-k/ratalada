# frozen_string_literal: true

class Schemas::ExternalWiki
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "ExternalWiki represents setting for external wiki",
    "type" => "object",
    "properties" => {
      "external_wiki_url" => {
        "description" => "URL of external wiki.",
        "type" => "string",
        "x-go-name" => "ExternalWikiURL",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
