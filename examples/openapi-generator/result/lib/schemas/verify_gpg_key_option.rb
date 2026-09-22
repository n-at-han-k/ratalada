# frozen_string_literal: true

class Schemas::VerifyGPGKeyOption
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "VerifyGPGKeyOption options verifies user GPG key",
    "type" => "object",
    "required" => ["key_id"],
    "properties" => {
      "armored_signature" => {"type" => "string", "x-go-name" => "Signature"},
      "key_id" => {
        "description" => "An Signature for a GPG key token",
        "type" => "string",
        "x-go-name" => "KeyID",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
