# frozen_string_literal: true

class Schemas::EditIssueCommentOption
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "EditIssueCommentOption options for editing a comment",
    "type" => "object",
    "required" => ["body"],
    "properties" => {
      "body" => {
        "description" => "The body of the comment",
        "type" => "string",
        "x-go-name" => "Body",
      },
      "updated_at" => {
        "description" => "The time of the comment's update, needs admin or repository owner permission",
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "Updated",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
