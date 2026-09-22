# frozen_string_literal: true

class Schemas::UserHeatmapData
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "UserHeatmapData represents the data needed to create a heatmap",
    "type" => "object",
    "properties" => {
      "contributions" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "Contributions",
      },
      "timestamp" => {"$ref" => "#/components/schemas/TimeStamp"},
    },
    "x-go-package" => "forgejo.org/models/activities",
  })
end
