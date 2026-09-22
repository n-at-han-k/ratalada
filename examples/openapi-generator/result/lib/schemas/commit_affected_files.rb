# frozen_string_literal: true

class Schemas::CommitAffectedFiles
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "CommitAffectedFiles store information about files affected by the commit",
    "type" => "object",
    "properties" => {
      "filename" => {"type" => "string", "x-go-name" => "Filename"},
      "status" => {"type" => "string", "x-go-name" => "Status"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
