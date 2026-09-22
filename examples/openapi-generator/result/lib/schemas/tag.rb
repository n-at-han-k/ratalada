# frozen_string_literal: true

class Schemas::Tag
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "Tag represents a repository tag",
    "type" => "object",
    "properties" => {
      "archive_download_count" => {"$ref" => "#/components/schemas/TagArchiveDownloadCount"},
      "commit" => {"$ref" => "#/components/schemas/CommitMeta"},
      "id" => {"type" => "string", "x-go-name" => "ID"},
      "message" => {"type" => "string", "x-go-name" => "Message"},
      "name" => {"type" => "string", "x-go-name" => "Name"},
      "tarball_url" => {"type" => "string", "x-go-name" => "TarballURL"},
      "zipball_url" => {"type" => "string", "x-go-name" => "ZipballURL"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
