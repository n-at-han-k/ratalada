# frozen_string_literal: true

# ── the annotations the page template reads ───────────────────────────
#
# The generator owns the file and the verbs. What a route DOES is a decision
# about schemas and relations that no template can make, so it travels in the
# document: `x-handler` is the body, and page.mustache prints it.

def annotate!
  DOCUMENT.fetch("paths").each do |path, operations|
    operations.slice(*VERBS).each do |verb, operation|
      operation["x-handler"] = handler(path, verb, operation).map { |line| "  #{line}" }.join("\n")
    end
  end
end

# The column a member route looks up, the value it is looked up by, and
# whether that column holds a number. The seed stores that value and the spec
# sends it, so the two cannot drift.
def lookup(path, operation)
  name = resource(path, operation)
  parameter = path[/\{([^{}\/]+)\}[^\/{}]*\z/, 1]

  if name.nil? || collection?(operation) || parameter.nil?
    nil
  else
    declared = models.fetch(name, []).find { |var| var["name"] == parameter && !json_column?(var, name) }

    # The table's own key is an integer, and a route whose key is called `id`
    # lands on it whatever the document says the parameter is.
    numeric = parameter == "id" || (declared && (declared["isInteger"] || declared["isLong"]))

    if numeric
      # The column holds a number, but the document may still declare the
      # parameter a string -- and a request is validated against what the
      # document says, not against what the column is.
      {"column" => parameter, "value" => textual?(path, parameter) ? "1" : 1, "numeric" => true}
    else
      {"column" => parameter, "value" => key_value(path, parameter), "numeric" => false}
    end
  end
end

# Whether the document declares this path parameter as a string.
def textual?(path, parameter)
  declared = DOCUMENT.dig("paths", path).to_h.slice(*VERBS).values
    .flat_map { |operation| parameters(operation, path) }
    .find { |candidate| candidate["name"] == parameter && candidate["in"] == "path" }

  (declared&.dig("schema", "type") || declared&.dig("type")) == "string"
end

def key_param(key) = key.fetch("column")

# What the handler reads out of the request. A numeric column will not match a
# string in SQL, and every path parameter arrives as a string.
def key_argument(key)
  if key.fetch("numeric")
    %(params[#{key_param(key).inspect}].to_i)
  else
    %(params[#{key_param(key).inspect}])
  end
end

# What the key is, in the type the route declares it: the spec sends this and
# the seed stores it.
def key_value(path, parameter)
  declared = DOCUMENT.dig("paths", path).to_h.slice(*VERBS).values
    .flat_map { |operation| parameters(operation, path) }
    .find { |candidate| candidate["name"] == parameter && candidate["in"] == "path" }

  value = example(declared&.dig("schema") || declared || {"type" => "string"})

  if value == ""
    parameter
  else
    value
  end
end

# The key columns the routes need, which the document's model may not declare:
# `/repos/{owner}/{repo}` keeps its `repo` somewhere.
def route_keys(name)
  @route_keys ||= route_lookups.group_by(&:first).transform_values { |found| found.map { |(_, column, _, _)| column }.uniq }

  # `id` is already the table's key, and a column the model declares needs no
  # second one.
  @route_keys.fetch(name, [])
    .reject { |column| column == "id" || models.fetch(name, []).any? { |var| var["name"] == column } }
end

# A DELETE answers 204 and a PUT sometimes answers nothing at all, so the
# resource a route acts on is whatever the rest of the path says it is.
def resource(path, operation)
  answered(operation) || DOCUMENT.dig("paths", path).to_h.slice(*VERBS).values.filter_map { |sibling|
    answered(sibling) unless collection?(sibling)
  }.first
end

def relation_for(path, operation) = table(resource(path, operation)).to_sym.inspect

# The list, the record, the create, the update, the delete -- where the path
# says so. A route whose success response is not a model keeps the literal the
# schema describes, with the TODO still on it.
def handler(path, verb, operation)
  name = resource(path, operation)

  if name.nil? || !resources.include?(name)
    literal_handler(path, operation)
  else
    case verb
    when "get", "head" then read_handler(path, operation)
    when "post" then create_handler(path, operation)
    when "put", "patch" then update_handler(path, operation)
    when "delete" then delete_handler(path, operation)
    else literal_handler(path, operation)
    end
  end
end

def literal_handler(path, operation)
  schema = response_schema(operation.dig("responses", success(operation)) || {})
  captures = path_values(operation, path).keys

  [
    *("# params: #{captures.join(", ")}" unless captures.empty?),
    "# TODO: the guts -- no relation answers this one.",
    "content_type(:json)",
    "status(#{success(operation)})",
    "#{pretty(example(schema || {}), 2)}.to_json",
  ]
end

def read_handler(path, operation)
  if collection?(operation)
    [
      "content_type(:json)",
      "status(#{success(operation)})",
      "relations[#{relation_for(path, operation)}].to_a.map(&:to_h).to_json",
    ]
  else
    [
      "content_type(:json)",
      *found_lines(path, operation),
      "status(#{success(operation)})",
      "record.to_h.to_json",
    ]
  end
end

def found_lines(path, operation)
  key = lookup(path, operation)

  if key.nil?
    ["record = relations[#{relation_for(path, operation)}].first"]
  else
    ["record = relations[#{relation_for(path, operation)}].where(#{key_param(key).to_sym.inspect} => #{key_argument(key)}).first"]
  end.push("not_found! if record.nil?")
end

def create_handler(path, operation)
  [
    "content_type(:json)",
    "records = relations[#{relation_for(path, operation)}]",
    "record = records.command(:create).call(accepted(records, parsed_body))",
    "status(#{success(operation)})",
    "record.to_h.to_json",
  ]
end

def update_handler(path, operation)
  key = lookup(path, operation)
  if key.nil?
    scope = "relations[#{relation_for(path, operation)}]"
  else
    scope = "relations[#{relation_for(path, operation)}].where(#{key_param(key).to_sym.inspect} => #{key_argument(key)})"
  end

  [
    "content_type(:json)",
    "records = #{scope}",
    "not_found! if records.count.zero?",
    "attributes = accepted(records, parsed_body)",
    "# Nothing the relation knows about: an UPDATE with no SET is not SQL.",
    "record = attributes.empty? ? records.first : records.command(:update).call(attributes)",
    "# One row updated comes back as the struct itself, several as a list.",
    "record = record.first if record.is_a?(Array)",
    "status(#{success(operation)})",
    "record.to_h.to_json",
  ]
end

def delete_handler(path, operation)
  key = lookup(path, operation)
  if key.nil?
    scope = "relations[#{relation_for(path, operation)}]"
  else
    scope = "relations[#{relation_for(path, operation)}].where(#{key_param(key).to_sym.inspect} => #{key_argument(key)})"
  end

  [
    "records = #{scope}",
    "not_found! if records.count.zero?",
    "records.command(:delete).call",
    "status(#{success(operation)})",
    "\"\"",
  ]
end

# Every member route's key: the model, the column and the value. Kept apart
# from the record behind it, because the columns a table has depend on these.
def route_lookups
  @route_lookups ||= DOCUMENT.fetch("paths").flat_map { |path, operations|
    operations.slice(*VERBS).filter_map do |_verb, operation|
      name = resource(path, operation)
      key = lookup(path, operation)

      if name && resources.include?(name) && key
        [name, key.fetch("column"), key.fetch("value"), key.fetch("numeric")]
      end
    end
  }.uniq
end

# The same, with the record to store behind each.
def member_lookups
  route_lookups.map do |(name, column, value)|
    [name, column, value, storable(name, example({"$ref" => "#/definitions/#{name}"}))]
  end
end
