# frozen_string_literal: true

class Schemas::QuotaUsedSizeRepos
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "QuotaUsedSizeRepos represents the size-based repository quota usage of a user",
    "type" => "object",
    "properties" => {
      "private" => {
        "description" => "Storage size of the user's private repositories",
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "Private",
      },
      "public" => {
        "description" => "Storage size of the user's public repositories",
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "Public",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
