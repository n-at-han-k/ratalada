# frozen_string_literal: true

class Schemas::RepoTopicOptions
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "RepoTopicOptions a collection of repo topic names",
    "type" => "object",
    "properties" => {
      "topics" => {
        "description" => "list of topic names",
        "type" => "array",
        "items" => {"type" => "string"},
        "x-go-name" => "Topics",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
