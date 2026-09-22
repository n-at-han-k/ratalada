# frozen_string_literal: true

class Schemas::Duration
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "A Duration represents the elapsed time between two instants\nas an int64 nanosecond count. The representation limits the\nlargest representable duration to approximately 290 years.",
    "type" => "integer",
    "format" => "int64",
    "x-go-package" => "time",
  })
end
