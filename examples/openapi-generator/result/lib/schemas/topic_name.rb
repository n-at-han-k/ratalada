# frozen_string_literal: true

class Schemas::TopicName
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "TopicName a list of repo topic names",
    "type" => "object",
    "properties" => {
      "topics" => {
        "type" => "array",
        "items" => {"type" => "string"},
        "x-go-name" => "TopicNames",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
