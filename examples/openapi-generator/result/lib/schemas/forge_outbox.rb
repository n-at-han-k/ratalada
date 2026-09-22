# frozen_string_literal: true

class Schemas::ForgeOutbox
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "ActivityStream OrderedCollection of activities",
    "type" => "object",
    "x-go-package" => "forgejo.org/modules/forgefed",
  })
end
