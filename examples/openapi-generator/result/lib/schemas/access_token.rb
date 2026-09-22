# frozen_string_literal: true

class Schemas::AccessToken
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "type" => "object",
    "title" => "AccessToken represents an API access token.",
    "properties" => {
      "created_at" => {
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "Created",
      },
      "id" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "ID",
      },
      "name" => {"type" => "string", "x-go-name" => "Name"},
      "repositories" => {
        "description" => "Indicates that an access token only has access to the specified repositories.  Will be null if the access token\nis not limited to a set of specified repositories.",
        "type" => "array",
        "items" => {"$ref" => "#/components/schemas/RepositoryMeta"},
        "x-go-name" => "Repositories",
      },
      "scopes" => {
        "type" => "array",
        "items" => {"type" => "string"},
        "x-go-name" => "Scopes",
      },
      "sha1" => {"type" => "string", "x-go-name" => "Token"},
      "token_last_eight" => {"type" => "string", "x-go-name" => "TokenLastEight"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
