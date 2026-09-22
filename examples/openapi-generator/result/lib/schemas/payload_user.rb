# frozen_string_literal: true

class Schemas::PayloadUser
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "PayloadUser represents the author or committer of a commit",
    "type" => "object",
    "properties" => {
      "email" => {
        "type" => "string",
        "format" => "email",
        "x-go-name" => "Email",
      },
      "name" => {
        "description" => "Full name of the commit author",
        "type" => "string",
        "x-go-name" => "Name",
      },
      "username" => {"type" => "string", "x-go-name" => "UserName"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
