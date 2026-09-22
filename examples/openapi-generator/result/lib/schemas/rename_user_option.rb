# frozen_string_literal: true

class Schemas::RenameUserOption
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "RenameUserOption options when renaming a user",
    "type" => "object",
    "required" => ["new_username"],
    "properties" => {
      "new_username" => {
        "description" => "New username for this user. This name cannot be in use yet by any other user.",
        "type" => "string",
        "uniqueItems" => true,
        "x-go-name" => "NewName",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
