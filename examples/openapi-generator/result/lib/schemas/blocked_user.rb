# frozen_string_literal: true

class Schemas::BlockedUser
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "type" => "object",
    "title" => "BlockedUser represents a blocked user.",
    "properties" => {
      "block_id" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "BlockID",
      },
      "created_at" => {
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "Created",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
