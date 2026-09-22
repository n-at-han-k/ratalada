# frozen_string_literal: true

class Schemas::CommitMeta
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "type" => "object",
    "title" => "CommitMeta contains meta information of a commit in terms of API.",
    "properties" => {
      "created" => {
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "Created",
      },
      "sha" => {"type" => "string", "x-go-name" => "SHA"},
      "url" => {"type" => "string", "x-go-name" => "URL"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
