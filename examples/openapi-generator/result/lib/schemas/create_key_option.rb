# frozen_string_literal: true

class Schemas::CreateKeyOption
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "CreateKeyOption options when creating a key",
    "type" => "object",
    "required" => ["title", "key"],
    "properties" => {
      "key" => {
        "description" => "An armored SSH key to add",
        "type" => "string",
        "uniqueItems" => true,
        "x-go-name" => "Key",
      },
      "read_only" => {
        "description" => "Describe if the key has only read access or read/write",
        "type" => "boolean",
        "x-go-name" => "ReadOnly",
      },
      "title" => {
        "description" => "Title of the key to add",
        "type" => "string",
        "uniqueItems" => true,
        "x-go-name" => "Title",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
