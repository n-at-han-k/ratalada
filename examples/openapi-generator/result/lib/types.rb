# frozen_string_literal: true

require "json"
require "rom-sql"

# A column that holds another model, a list or a map. SQLite has no JSON
# type, so it is text in the column and parsed on the way out.
# Idempotent on purpose: rom-sql runs the read type over a freshly
# inserted row as well as over one it read back, so this sees both the
# text and the value it already parsed.
Parsed = ROM::SQL::Types::Any.constructor do |value|
  if value.is_a?(::String) && !value.empty?
    begin
      ::JSON.parse(value)
    rescue ::JSON::ParserError
      # A route key can land on a column the document declares as an
      # object -- `/pulls/{base}/{head}` keeps its `head` there -- and a
      # key is text, not JSON.
      value
    end
  else
    value
  end
end
