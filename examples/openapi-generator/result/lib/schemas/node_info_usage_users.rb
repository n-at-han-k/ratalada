# frozen_string_literal: true

class Schemas::NodeInfoUsageUsers
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "NodeInfoUsageUsers contains statistics about the users of this server",
    "type" => "object",
    "properties" => {
      "activeHalfyear" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "ActiveHalfyear",
      },
      "activeMonth" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "ActiveMonth",
      },
      "total" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "Total",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
