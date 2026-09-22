# frozen_string_literal: true

class Schemas::IssueFormFieldType
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "type" => "string",
    "title" => "IssueFormFieldType defines issue form field type, can be \"markdown\", \"textarea\", \"input\", \"dropdown\" or \"checkboxes\"",
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
