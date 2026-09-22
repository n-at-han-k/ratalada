# frozen_string_literal: true

class Schemas::StateType
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "StateType issue state type",
    "type" => "string",
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
