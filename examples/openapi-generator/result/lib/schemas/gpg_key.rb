# frozen_string_literal: true

class Schemas::GPGKey
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "GPGKey a user GPG key to sign commit and tag in repository",
    "type" => "object",
    "properties" => {
      "can_certify" => {"type" => "boolean", "x-go-name" => "CanCertify"},
      "can_encrypt_comms" => {"type" => "boolean", "x-go-name" => "CanEncryptComms"},
      "can_encrypt_storage" => {"type" => "boolean", "x-go-name" => "CanEncryptStorage"},
      "can_sign" => {"type" => "boolean", "x-go-name" => "CanSign"},
      "created_at" => {
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "Created",
      },
      "emails" => {
        "type" => "array",
        "items" => {"$ref" => "#/components/schemas/GPGKeyEmail"},
        "x-go-name" => "Emails",
      },
      "expires_at" => {
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "Expires",
      },
      "id" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "ID",
      },
      "key_id" => {"type" => "string", "x-go-name" => "KeyID"},
      "primary_key_id" => {"type" => "string", "x-go-name" => "PrimaryKeyID"},
      "public_key" => {"type" => "string", "x-go-name" => "PublicKey"},
      "subkeys" => {
        "type" => "array",
        "items" => {"$ref" => "#/components/schemas/GPGKey"},
        "x-go-name" => "SubsKey",
      },
      "verified" => {"type" => "boolean", "x-go-name" => "Verified"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
