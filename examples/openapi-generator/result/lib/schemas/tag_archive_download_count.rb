# frozen_string_literal: true

class Schemas::TagArchiveDownloadCount
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "TagArchiveDownloadCount counts how many times a archive was downloaded",
    "type" => "object",
    "properties" => {
      "tar_gz" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "TarGz",
      },
      "zip" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "Zip",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
