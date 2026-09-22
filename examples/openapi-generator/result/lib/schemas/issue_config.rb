# frozen_string_literal: true

class Schemas::IssueConfig
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "type" => "object",
    "properties" => {
      "blank_issues_enabled" => {"type" => "boolean", "x-go-name" => "BlankIssuesEnabled"},
      "contact_links" => {
        "type" => "array",
        "items" => {"$ref" => "#/components/schemas/IssueConfigContactLink"},
        "x-go-name" => "ContactLinks",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
