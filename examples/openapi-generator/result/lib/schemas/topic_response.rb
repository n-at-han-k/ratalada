# frozen_string_literal: true

class Schemas::TopicResponse
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "TopicResponse for returning topics",
    "type" => "object",
    "properties" => {
      "created" => {
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "Created",
      },
      "id" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "ID",
      },
      "repo_count" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "RepoCount",
      },
      "topic_name" => {"type" => "string", "x-go-name" => "Name"},
      "updated" => {
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "Updated",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
