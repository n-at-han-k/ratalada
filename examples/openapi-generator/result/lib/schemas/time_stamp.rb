# frozen_string_literal: true

class Schemas::TimeStamp
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "TimeStamp defines a timestamp",
    "type" => "integer",
    "format" => "int64",
    "x-go-package" => "forgejo.org/modules/timeutil",
  })
end
