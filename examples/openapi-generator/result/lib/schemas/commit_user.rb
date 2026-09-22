# frozen_string_literal: true

class Schemas::CommitUser
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "type" => "object",
    "title" => "CommitUser contains information of a user in the context of a commit.",
    "properties" => {
      "date" => {"type" => "string", "x-go-name" => "Date"},
      "email" => {
        "type" => "string",
        "format" => "email",
        "x-go-name" => "Email",
      },
      "name" => {"type" => "string", "x-go-name" => "Name"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
