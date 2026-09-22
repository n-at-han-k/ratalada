# frozen_string_literal: true

class Schemas::UpdateRepoAvatarOption
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "UpdateRepoAvatarUserOption options when updating the repo avatar",
    "type" => "object",
    "properties" => {
      "image" => {
        "description" => "image must be base64 encoded",
        "type" => "string",
        "x-go-name" => "Image",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
