# frozen_string_literal: true

# The specs build this app without going through server.rb, so the layout
# requires what the layout uses.
require "ratalada/contrib/vite"

# The index page is a vite entrypoint (app/index.rb); every other page under
# here is the API, which never renders HTML.
helpers Ratalada::Contrib::Vite::TagHelpers

helpers do
  def relations = ROM_CONTAINER.relations

  # Only what the relation declares, and JSON columns as the text they are
  # stored as: a request body may carry anything, in any shape.
  def accepted(records, attributes)
    keys = records.schema.map { |attribute| attribute.name }

    attributes.transform_keys(&:to_sym).slice(*keys).transform_values do |value|
      if value.is_a?(Array) || value.is_a?(Hash)
        JSON.generate(value)
      else
        value
      end
    end
  end

  def parsed_body
    JSON.parse(request.body.read)
  rescue JSON::ParserError
    {}
  end

  def not_found!
    halt(404, {"message" => "Not found"}.to_json)
  end
end
