# frozen_string_literal: true

class Schemas::CreateStatusOption
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "CreateStatusOption holds the information needed to create a new CommitStatus for a Commit",
    "type" => "object",
    "properties" => {
      "context" => {"type" => "string", "x-go-name" => "Context"},
      "description" => {"type" => "string", "x-go-name" => "Description"},
      "state" => {"$ref" => "#/components/schemas/CommitStatusState"},
      "target_url" => {"type" => "string", "x-go-name" => "TargetURL"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
