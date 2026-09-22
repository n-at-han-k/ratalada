# frozen_string_literal: true

class Schemas::RegistrationToken
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "RegistrationToken is a string used to register a runner with a server",
    "type" => "object",
    "properties" => {"token" => {"type" => "string", "x-go-name" => "Token"}},
    "x-go-package" => "forgejo.org/routers/api/v1/shared",
  })
end
