# frozen_string_literal: true

class Schemas::EditReleaseOption
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "EditReleaseOption options when editing a release",
    "type" => "object",
    "properties" => {
      "body" => {"type" => "string", "x-go-name" => "Note"},
      "draft" => {"type" => "boolean", "x-go-name" => "IsDraft"},
      "hide_archive_links" => {"type" => "boolean", "x-go-name" => "HideArchiveLinks"},
      "name" => {"type" => "string", "x-go-name" => "Title"},
      "prerelease" => {"type" => "boolean", "x-go-name" => "IsPrerelease"},
      "tag_name" => {"type" => "string", "x-go-name" => "TagName"},
      "target_commitish" => {"type" => "string", "x-go-name" => "Target"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
