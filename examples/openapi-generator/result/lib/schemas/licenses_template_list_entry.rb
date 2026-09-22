# frozen_string_literal: true

class Schemas::LicensesTemplateListEntry
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "LicensesListEntry is used for the API",
    "type" => "object",
    "properties" => {
      "key" => {"type" => "string", "x-go-name" => "Key"},
      "name" => {"type" => "string", "x-go-name" => "Name"},
      "url" => {"type" => "string", "x-go-name" => "URL"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
