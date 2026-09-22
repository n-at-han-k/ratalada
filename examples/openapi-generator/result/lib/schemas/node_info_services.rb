# frozen_string_literal: true

class Schemas::NodeInfoServices
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "NodeInfoServices contains the third party sites this server can connect to via their application API",
    "type" => "object",
    "properties" => {
      "inbound" => {
        "type" => "array",
        "items" => {"type" => "string"},
        "x-go-name" => "Inbound",
      },
      "outbound" => {
        "type" => "array",
        "items" => {"type" => "string"},
        "x-go-name" => "Outbound",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
