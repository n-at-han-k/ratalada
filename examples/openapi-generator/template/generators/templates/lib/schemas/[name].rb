# frozen_string_literal: true

class Schemas::<%= constant(name) %>
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema(<%= strings(definitions.fetch(name), 2) %>)
end
