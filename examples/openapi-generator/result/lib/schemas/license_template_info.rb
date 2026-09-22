# frozen_string_literal: true

class Schemas::LicenseTemplateInfo
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "LicensesInfo contains information about a License",
    "type" => "object",
    "properties" => {
      "body" => {"type" => "string", "x-go-name" => "Body"},
      "implementation" => {"type" => "string", "x-go-name" => "Implementation"},
      "key" => {"type" => "string", "x-go-name" => "Key"},
      "name" => {"type" => "string", "x-go-name" => "Name"},
      "url" => {"type" => "string", "x-go-name" => "URL"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
