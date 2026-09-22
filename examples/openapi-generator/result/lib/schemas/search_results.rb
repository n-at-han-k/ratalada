# frozen_string_literal: true

class Schemas::SearchResults
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "SearchResults results of a successful search",
    "type" => "object",
    "properties" => {
      "data" => {
        "type" => "array",
        "items" => {"$ref" => "#/components/schemas/Repository"},
        "x-go-name" => "Data",
      },
      "ok" => {"type" => "boolean", "x-go-name" => "OK"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
