# frozen_string_literal: true

class Schemas::ServerVersion
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "ServerVersion wraps the version of the server",
    "type" => "object",
    "properties" => {
      "version" => {"type" => "string", "x-go-name" => "Version"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
