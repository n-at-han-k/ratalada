# frozen_string_literal: true

class Schemas::CommitStatus
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "CommitStatus holds a single status of a single Commit",
    "type" => "object",
    "properties" => {
      "context" => {"type" => "string", "x-go-name" => "Context"},
      "created_at" => {
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "Created",
      },
      "creator" => {"$ref" => "#/components/schemas/User"},
      "description" => {"type" => "string", "x-go-name" => "Description"},
      "id" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "ID",
      },
      "status" => {"$ref" => "#/components/schemas/CommitStatusState"},
      "target_url" => {"type" => "string", "x-go-name" => "TargetURL"},
      "updated_at" => {
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "Updated",
      },
      "url" => {"type" => "string", "x-go-name" => "URL"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
