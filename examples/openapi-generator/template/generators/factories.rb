# frozen_string_literal: true

# ── the factories the specs build with ────────────────────────────────

# A factory per relation, values from the document's own schema: a spec builds
# the record it is about to fetch, rather than relying on a row someone left
# behind.
#
# The key column is a sequence -- two examples in one run must not collide on
# it -- and a JSON column carries the text the column holds, because a factory
# writes through the relation like anything else.
def factory_file(name)
  key = route_keys(name).first || (route_lookups.find { |(model, _, _, _)| model == name }&.at(1))
  values = storable(name, example({"$ref" => "#/definitions/#{name}"}))
    .reject { |column, _| column == "id" || column == key }
    .select { |column, _| columns(name).any? { |var| var["name"] == column } }

  [
    "# frozen_string_literal: true",
    "",
    "# #{name} -- generated from models.json.",
    "Factory.define(#{INFLECT.singularize(table(name)).to_sym.inspect}, relation: #{table(name).to_sym.inspect}) do |f|",
    *(key ? ["  f.sequence(#{key.to_sym.inspect}) { |n| #{key_sequence(name, key)} }"] : []),
    *values.map { |column, value| "  #{attribute_call(column)} { #{value.inspect} }" },
    "end",
    "",
  ].join("\n")
end

# `f.name { }` for a column Ruby can spell as a method, and a send for one it
# cannot -- a document may call a property `@context`.
def attribute_call(column)
  if column.match?(/\A[a-z_][a-zA-Z0-9_]*\z/)
    "f.#{column}"
  else
    "f.__send__(#{column.to_sym.inspect})"
  end
end

# The sequence a key column runs through, in the type that column holds.
def key_sequence(name, key)
  # The column's type, not the value's: a numeric key may still be declared as
  # a string in the document, and the sequence fills the column.
  numeric = route_lookups.any? { |(model, column, _, numeric)| model == name && column == key && numeric }

  if numeric
    "n"
  else
    %("#{key}-\#{n}")
  end
end

