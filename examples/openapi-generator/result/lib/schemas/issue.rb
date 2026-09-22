# frozen_string_literal: true

class Schemas::Issue
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "Issue represents an issue in a repository",
    "type" => "object",
    "properties" => {
      "assets" => {
        "type" => "array",
        "items" => {"$ref" => "#/components/schemas/Attachment"},
        "x-go-name" => "Attachments",
      },
      "assignee" => {"$ref" => "#/components/schemas/User"},
      "assignees" => {
        "type" => "array",
        "items" => {"$ref" => "#/components/schemas/User"},
        "x-go-name" => "Assignees",
      },
      "body" => {"type" => "string", "x-go-name" => "Body"},
      "closed_at" => {
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "Closed",
      },
      "comments" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "Comments",
      },
      "created_at" => {
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "Created",
      },
      "due_date" => {
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "Deadline",
      },
      "html_url" => {"type" => "string", "x-go-name" => "HTMLURL"},
      "id" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "ID",
      },
      "is_locked" => {"type" => "boolean", "x-go-name" => "IsLocked"},
      "labels" => {
        "type" => "array",
        "items" => {"$ref" => "#/components/schemas/Label"},
        "x-go-name" => "Labels",
      },
      "milestone" => {"$ref" => "#/components/schemas/Milestone"},
      "number" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "Index",
      },
      "original_author" => {"type" => "string", "x-go-name" => "OriginalAuthor"},
      "original_author_id" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "OriginalAuthorID",
      },
      "pin_order" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "PinOrder",
      },
      "pull_request" => {"$ref" => "#/components/schemas/PullRequestMeta"},
      "ref" => {"type" => "string", "x-go-name" => "Ref"},
      "repository" => {"$ref" => "#/components/schemas/RepositoryMeta"},
      "state" => {"$ref" => "#/components/schemas/StateType"},
      "title" => {"type" => "string", "x-go-name" => "Title"},
      "updated_at" => {
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "Updated",
      },
      "url" => {"type" => "string", "x-go-name" => "URL"},
      "user" => {"$ref" => "#/components/schemas/User"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
