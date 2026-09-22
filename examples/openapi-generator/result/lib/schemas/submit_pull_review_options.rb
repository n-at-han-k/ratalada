# frozen_string_literal: true

class Schemas::SubmitPullReviewOptions
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "SubmitPullReviewOptions are options to submit a pending pull review",
    "type" => "object",
    "properties" => {
      "body" => {"type" => "string", "x-go-name" => "Body"},
      "event" => {"$ref" => "#/components/schemas/ReviewStateType"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
