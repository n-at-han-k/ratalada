# frozen_string_literal: true

class Schemas::GeneralAPISettings
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "GeneralAPISettings contains global api settings exposed by it",
    "type" => "object",
    "properties" => {
      "default_git_trees_per_page" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "DefaultGitTreesPerPage",
      },
      "default_max_blob_size" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "DefaultMaxBlobSize",
      },
      "default_paging_num" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "DefaultPagingNum",
      },
      "max_response_items" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "MaxResponseItems",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
