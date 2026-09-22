# frozen_string_literal: true

class Schemas::APIRepoArchivedError
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "type" => "object",
    "properties" => {
      "message" => {"type" => "string", "x-go-name" => "Message"},
      "url" => {"type" => "string", "x-go-name" => "URL"},
    },
    "x-go-package" => "forgejo.org/services/context",
  })
end
