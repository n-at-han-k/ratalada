# frozen_string_literal: true

class Schemas::NewIssuePinsAllowed
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "NewIssuePinsAllowed represents an API response that says if new Issue Pins are allowed",
    "type" => "object",
    "properties" => {
      "issues" => {"type" => "boolean", "x-go-name" => "Issues"},
      "pull_requests" => {"type" => "boolean", "x-go-name" => "PullRequests"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
