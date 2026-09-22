# frozen_string_literal: true

class Schemas::IssueFormFieldVisible
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "IssueFormFieldVisible defines issue form field visible",
    "type" => "string",
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
