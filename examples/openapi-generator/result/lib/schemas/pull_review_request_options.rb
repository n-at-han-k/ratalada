# frozen_string_literal: true

class Schemas::PullReviewRequestOptions
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "PullReviewRequestOptions are options to add or remove pull review requests",
    "type" => "object",
    "properties" => {
      "reviewers" => {
        "type" => "array",
        "items" => {"type" => "string"},
        "x-go-name" => "Reviewers",
      },
      "team_reviewers" => {
        "type" => "array",
        "items" => {"type" => "string"},
        "x-go-name" => "TeamReviewers",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
