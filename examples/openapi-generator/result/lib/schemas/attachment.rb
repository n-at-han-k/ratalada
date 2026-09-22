# frozen_string_literal: true

class Schemas::Attachment
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "Attachment a generic attachment",
    "type" => "object",
    "properties" => {
      "browser_download_url" => {"type" => "string", "x-go-name" => "DownloadURL"},
      "created_at" => {
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "Created",
      },
      "download_count" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "DownloadCount",
      },
      "id" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "ID",
      },
      "name" => {"type" => "string", "x-go-name" => "Name"},
      "size" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "Size",
      },
      "type" => {
        "type" => "string",
        "enum" => ["attachment", "external"],
        "x-go-name" => "Type",
      },
      "uuid" => {"type" => "string", "x-go-name" => "UUID"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
