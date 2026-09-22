# frozen_string_literal: true

class Schemas::NodeInfoSoftware
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "NodeInfoSoftware contains Metadata about server software in use",
    "type" => "object",
    "properties" => {
      "homepage" => {"type" => "string", "x-go-name" => "Homepage"},
      "name" => {"type" => "string", "x-go-name" => "Name"},
      "repository" => {"type" => "string", "x-go-name" => "Repository"},
      "version" => {"type" => "string", "x-go-name" => "Version"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
