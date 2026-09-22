# frozen_string_literal: true

class Schemas::APRemoteFollowOption
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "type" => "object",
    "properties" => {"target" => {"type" => "string", "x-go-name" => "Target"}},
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
