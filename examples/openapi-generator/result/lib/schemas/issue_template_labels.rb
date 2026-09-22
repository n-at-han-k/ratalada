# frozen_string_literal: true

class Schemas::IssueTemplateLabels
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "type" => "array",
    "items" => {"type" => "string"},
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
