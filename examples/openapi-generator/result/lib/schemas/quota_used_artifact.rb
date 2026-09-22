# frozen_string_literal: true

class Schemas::QuotaUsedArtifact
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "QuotaUsedArtifact represents an artifact counting towards a user's quota",
    "type" => "object",
    "properties" => {
      "html_url" => {
        "description" => "HTML URL to the action run containing the artifact",
        "type" => "string",
        "x-go-name" => "HTMLURL",
      },
      "name" => {
        "description" => "Name of the artifact",
        "type" => "string",
        "x-go-name" => "Name",
      },
      "size" => {
        "description" => "Size of the artifact (compressed)",
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "Size",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
