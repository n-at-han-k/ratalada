# frozen_string_literal: true

class Schemas::NodeInfo
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "NodeInfo contains standardized way of exposing metadata about a server running one of the distributed social networks",
    "type" => "object",
    "properties" => {
      "metadata" => {"type" => "object", "x-go-name" => "Metadata"},
      "openRegistrations" => {"type" => "boolean", "x-go-name" => "OpenRegistrations"},
      "protocols" => {
        "type" => "array",
        "items" => {"type" => "string"},
        "x-go-name" => "Protocols",
      },
      "services" => {"$ref" => "#/components/schemas/NodeInfoServices"},
      "software" => {"$ref" => "#/components/schemas/NodeInfoSoftware"},
      "usage" => {"$ref" => "#/components/schemas/NodeInfoUsage"},
      "version" => {"type" => "string", "x-go-name" => "Version"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
