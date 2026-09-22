# frozen_string_literal: true

class Schemas::CommitDateOptions
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "CommitDateOptions store dates for GIT_AUTHOR_DATE and GIT_COMMITTER_DATE",
    "type" => "object",
    "properties" => {
      "author" => {
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "Author",
      },
      "committer" => {
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "Committer",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
