# frozen_string_literal: true

class Schemas::PullRequestMeta
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "PullRequestMeta PR info if an issue is a PR",
    "type" => "object",
    "properties" => {
      "draft" => {"type" => "boolean", "x-go-name" => "IsWorkInProgress"},
      "html_url" => {"type" => "string", "x-go-name" => "HTMLURL"},
      "merged" => {"type" => "boolean", "x-go-name" => "HasMerged"},
      "merged_at" => {
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "Merged",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
