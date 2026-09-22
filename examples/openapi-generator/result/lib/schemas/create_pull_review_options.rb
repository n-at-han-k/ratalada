# frozen_string_literal: true

class Schemas::CreatePullReviewOptions
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "CreatePullReviewOptions are options to create a pull review",
    "type" => "object",
    "properties" => {
      "body" => {"type" => "string", "x-go-name" => "Body"},
      "comments" => {
        "type" => "array",
        "items" => {"$ref" => "#/components/schemas/CreatePullReviewComment"},
        "x-go-name" => "Comments",
      },
      "commit_id" => {"type" => "string", "x-go-name" => "CommitID"},
      "event" => {"$ref" => "#/components/schemas/ReviewStateType"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
