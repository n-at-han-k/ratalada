# frozen_string_literal: true

class Schemas::ReviewStateType
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "ReviewStateType review state type",
    "type" => "string",
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
