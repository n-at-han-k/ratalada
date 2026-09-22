# frozen_string_literal: true

class Schemas::CreateOAuth2ApplicationOptions
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "CreateOAuth2ApplicationOptions holds options to create an oauth2 application",
    "type" => "object",
    "properties" => {
      "confidential_client" => {"type" => "boolean", "x-go-name" => "ConfidentialClient"},
      "name" => {"type" => "string", "x-go-name" => "Name"},
      "redirect_uris" => {
        "type" => "array",
        "items" => {"type" => "string"},
        "x-go-name" => "RedirectURIs",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
