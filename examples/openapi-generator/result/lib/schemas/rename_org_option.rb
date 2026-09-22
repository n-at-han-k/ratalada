# frozen_string_literal: true

class Schemas::RenameOrgOption
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "RenameOrgOption options when renaming an organization",
    "type" => "object",
    "required" => ["new_name"],
    "properties" => {
      "new_name" => {
        "description" => "New username for this org. This name cannot be in use yet by any other user.",
        "type" => "string",
        "uniqueItems" => true,
        "x-go-name" => "NewName",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
