# frozen_string_literal: true

class Schemas::CreatePullReviewComment
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "CreatePullReviewComment represent a review comment for creation api",
    "type" => "object",
    "properties" => {
      "body" => {"type" => "string", "x-go-name" => "Body"},
      "extra_lines_count" => {
        "description" => "number of additional lines after the commented line (0 = single line comment)",
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "ExtraLinesCount",
      },
      "new_position" => {
        "description" => "if comment to new file line or 0",
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "NewLineNum",
      },
      "old_position" => {
        "description" => "if comment to old file line or 0",
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "OldLineNum",
      },
      "path" => {
        "description" => "the tree path",
        "type" => "string",
        "x-go-name" => "Path",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
