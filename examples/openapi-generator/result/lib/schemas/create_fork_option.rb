# frozen_string_literal: true

class Schemas::CreateForkOption
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "CreateForkOption options for creating a fork",
    "type" => "object",
    "properties" => {
      "name" => {
        "description" => "name of the forked repository",
        "type" => "string",
        "x-go-name" => "Name",
      },
      "organization" => {
        "description" => "organization name, if forking into an organization",
        "type" => "string",
        "x-go-name" => "Organization",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
