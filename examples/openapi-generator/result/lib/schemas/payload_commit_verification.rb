# frozen_string_literal: true

class Schemas::PayloadCommitVerification
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "PayloadCommitVerification represents the GPG verification of a commit",
    "type" => "object",
    "properties" => {
      "payload" => {"type" => "string", "x-go-name" => "Payload"},
      "reason" => {"type" => "string", "x-go-name" => "Reason"},
      "signature" => {"type" => "string", "x-go-name" => "Signature"},
      "signer" => {"$ref" => "#/components/schemas/PayloadUser"},
      "verified" => {"type" => "boolean", "x-go-name" => "Verified"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
