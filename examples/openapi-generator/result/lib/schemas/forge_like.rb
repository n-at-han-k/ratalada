# frozen_string_literal: true

class Schemas::ForgeLike
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "ForgeLike activity data type",
    "type" => "object",
    "x-go-package" => "forgejo.org/modules/forgefed",
  })
end
