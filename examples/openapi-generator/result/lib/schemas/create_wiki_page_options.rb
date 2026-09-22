# frozen_string_literal: true

class Schemas::CreateWikiPageOptions
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "CreateWikiPageOptions form for creating wiki",
    "type" => "object",
    "properties" => {
      "content_base64" => {
        "description" => "content must be base64 encoded",
        "type" => "string",
        "x-go-name" => "ContentBase64",
      },
      "message" => {
        "description" => "optional commit message summarizing the change",
        "type" => "string",
        "x-go-name" => "Message",
      },
      "title" => {
        "description" => "page title. leave empty to keep unchanged",
        "type" => "string",
        "x-go-name" => "Title",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
