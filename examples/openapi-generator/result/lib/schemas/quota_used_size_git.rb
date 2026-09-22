# frozen_string_literal: true

class Schemas::QuotaUsedSizeGit
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "QuotaUsedSizeGit represents the size-based git (lfs) quota usage of a user",
    "type" => "object",
    "properties" => {
      "LFS" => {
        "description" => "Storage size of the user's Git LFS objects",
        "type" => "integer",
        "format" => "int64",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
