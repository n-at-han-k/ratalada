# frozen_string_literal: true

class Schemas::GeneralAttachmentSettings
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "GeneralAttachmentSettings contains global Attachment settings exposed by API",
    "type" => "object",
    "properties" => {
      "allowed_types" => {"type" => "string", "x-go-name" => "AllowedTypes"},
      "enabled" => {"type" => "boolean", "x-go-name" => "Enabled"},
      "max_files" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "MaxFiles",
      },
      "max_size" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "MaxSize",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
