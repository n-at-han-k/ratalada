# frozen_string_literal: true

class Schemas::Comment
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "Comment represents a comment on a commit or issue",
    "type" => "object",
    "properties" => {
      "assets" => {
        "description" => "The attachments to the comment",
        "type" => "array",
        "items" => {"$ref" => "#/components/schemas/Attachment"},
        "x-go-name" => "Attachments",
      },
      "body" => {
        "description" => "The body of the comment",
        "type" => "string",
        "x-go-name" => "Body",
      },
      "created_at" => {
        "description" => "The time of the comment's creation",
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "Created",
      },
      "html_url" => {
        "description" => "The HTML URL of the comment",
        "type" => "string",
        "x-go-name" => "HTMLURL",
      },
      "id" => {
        "description" => "The identifier of the comment",
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "ID",
      },
      "issue_url" => {
        "description" => "The HTML URL of the issue if the comment is posted on an issue, else empty string",
        "type" => "string",
        "x-go-name" => "IssueURL",
      },
      "original_author" => {
        "description" => "The original author that posted the comment if it was not posted locally, else empty string",
        "type" => "string",
        "x-go-name" => "OriginalAuthor",
      },
      "original_author_id" => {
        "description" => "The ID of the original author that posted the comment if it was not posted locally, else 0",
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "OriginalAuthorID",
      },
      "pull_request_url" => {
        "description" => "The HTML URL of the pull request if the comment is posted on a pull request, else empty string",
        "type" => "string",
        "x-go-name" => "PRURL",
      },
      "updated_at" => {
        "description" => "The time of the comment's update",
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "Updated",
      },
      "user" => {"$ref" => "#/components/schemas/User"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
