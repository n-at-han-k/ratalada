# frozen_string_literal: true

class Schemas::Release
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "Release represents a repository release",
    "type" => "object",
    "properties" => {
      "archive_download_count" => {"$ref" => "#/components/schemas/TagArchiveDownloadCount"},
      "assets" => {
        "type" => "array",
        "items" => {"$ref" => "#/components/schemas/Attachment"},
        "x-go-name" => "Attachments",
      },
      "author" => {"$ref" => "#/components/schemas/User"},
      "body" => {"type" => "string", "x-go-name" => "Note"},
      "created_at" => {
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "CreatedAt",
      },
      "draft" => {"type" => "boolean", "x-go-name" => "IsDraft"},
      "hide_archive_links" => {"type" => "boolean", "x-go-name" => "HideArchiveLinks"},
      "html_url" => {"type" => "string", "x-go-name" => "HTMLURL"},
      "id" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "ID",
      },
      "name" => {"type" => "string", "x-go-name" => "Title"},
      "prerelease" => {"type" => "boolean", "x-go-name" => "IsPrerelease"},
      "published_at" => {
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "PublishedAt",
      },
      "tag_name" => {"type" => "string", "x-go-name" => "TagName"},
      "tarball_url" => {"type" => "string", "x-go-name" => "TarURL"},
      "target_commitish" => {"type" => "string", "x-go-name" => "Target"},
      "upload_url" => {"type" => "string", "x-go-name" => "UploadURL"},
      "url" => {"type" => "string", "x-go-name" => "URL"},
      "zipball_url" => {"type" => "string", "x-go-name" => "ZipURL"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
