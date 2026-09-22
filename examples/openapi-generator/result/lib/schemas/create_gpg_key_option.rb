# frozen_string_literal: true

class Schemas::CreateGPGKeyOption
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "CreateGPGKeyOption options create user GPG key",
    "type" => "object",
    "required" => ["armored_public_key"],
    "properties" => {
      "armored_public_key" => {
        "description" => "An armored GPG key to add",
        "type" => "string",
        "uniqueItems" => true,
        "x-go-name" => "ArmoredKey",
      },
      "armored_signature" => {"type" => "string", "x-go-name" => "Signature"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
