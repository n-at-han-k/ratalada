# frozen_string_literal: true

class Schemas::NodeInfoUsage
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "NodeInfoUsage contains usage statistics for this server",
    "type" => "object",
    "properties" => {
      "localComments" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "LocalComments",
      },
      "localPosts" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "LocalPosts",
      },
      "users" => {"$ref" => "#/components/schemas/NodeInfoUsageUsers"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
