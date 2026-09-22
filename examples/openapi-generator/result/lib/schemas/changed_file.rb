# frozen_string_literal: true

class Schemas::ChangedFile
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "ChangedFile store information about files affected by the pull request",
    "type" => "object",
    "properties" => {
      "additions" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "Additions",
      },
      "changes" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "Changes",
      },
      "contents_url" => {"type" => "string", "x-go-name" => "ContentsURL"},
      "deletions" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "Deletions",
      },
      "filename" => {"type" => "string", "x-go-name" => "Filename"},
      "html_url" => {"type" => "string", "x-go-name" => "HTMLURL"},
      "previous_filename" => {"type" => "string", "x-go-name" => "PreviousFilename"},
      "raw_url" => {"type" => "string", "x-go-name" => "RawURL"},
      "status" => {"type" => "string", "x-go-name" => "Status"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
