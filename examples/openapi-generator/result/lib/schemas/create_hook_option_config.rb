# frozen_string_literal: true

class Schemas::CreateHookOptionConfig
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "CreateHookOptionConfig has all config options in it\nrequired are \"content_type\" and \"url\" Required",
    "type" => "object",
    "additionalProperties" => {"type" => "string"},
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
