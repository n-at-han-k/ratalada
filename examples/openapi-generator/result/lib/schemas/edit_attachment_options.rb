# frozen_string_literal: true

class Schemas::EditAttachmentOptions
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "EditAttachmentOptions options for editing attachments",
    "type" => "object",
    "properties" => {
      "browser_download_url" => {
        "description" => "(Can only be set if existing attachment is of external type)",
        "type" => "string",
        "x-go-name" => "DownloadURL",
      },
      "name" => {"type" => "string", "x-go-name" => "Name"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
