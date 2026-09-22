# frozen_string_literal: true

class Schemas::IssueTemplate
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "IssueTemplate represents an issue template for a repository",
    "type" => "object",
    "properties" => {
      "about" => {"type" => "string", "x-go-name" => "About"},
      "body" => {
        "type" => "array",
        "items" => {"$ref" => "#/components/schemas/IssueFormField"},
        "x-go-name" => "Fields",
      },
      "content" => {"type" => "string", "x-go-name" => "Content"},
      "file_name" => {"type" => "string", "x-go-name" => "FileName"},
      "labels" => {"$ref" => "#/components/schemas/IssueTemplateLabels"},
      "name" => {"type" => "string", "x-go-name" => "Name"},
      "ref" => {"type" => "string", "x-go-name" => "Ref"},
      "title" => {"type" => "string", "x-go-name" => "Title"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
