# frozen_string_literal: true

class Schemas::DismissPullReviewOptions
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "DismissPullReviewOptions are options to dismiss a pull review",
    "type" => "object",
    "properties" => {
      "message" => {"type" => "string", "x-go-name" => "Message"},
      "priors" => {"type" => "boolean", "x-go-name" => "Priors"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
