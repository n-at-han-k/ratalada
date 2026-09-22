# frozen_string_literal: true

# ── the openapi_ruby specs ─────────────────────────────────────────────

def parameter_lines(declared)
  declared.map do |parameter|
    schema = parameter["schema"] || parameter.slice("type", "format", "enum", "items")

    # `.to_sym.inspect`, not `:#{name}`: Forgejo has `pre-release`, and a bare
    # `:pre-release` parses as a subtraction.
    "parameter name: #{parameter["name"].to_sym.inspect}, in: :#{parameter["in"]}, " \
      "schema: #{literal(schema)}, required: #{parameter.fetch("required", false)}"
  end
end

def response_lines(operation)
  operation.fetch("responses", {}).sort.map do |code, response|
    description = resolve(response)["description"].to_s.lines.first.to_s.strip
    schema = response_schema(response)

    if schema
      ["response #{code}, #{description.inspect} do", "  schema(#{literal(schema)})", "end"]
    else
      ["response #{code}, #{description.inspect}"]
    end
  end
end

def operation_lines(path, verb, operation)
  declared = parameters(operation, path).reject { |parameter| %w[path body formData].include?(parameter["in"]) }
  body = request_body(operation, path)

  [
    "#{verb} #{operation["summary"].to_s.inspect} do",
    *("  tags #{operation["tags"].map(&:inspect).join(", ")}" if operation["tags"]),
    *("  operationId #{operation["operationId"].inspect}" if operation["operationId"]),
    *parameter_lines(declared).map { |line| "  #{line}" },
    *(body && body["schema"] ? ["  request_body(", "    required: #{body["required"]},", "    content: {#{body["media"].inspect} => {schema: #{literal(body["schema"])}}},", "  )"] : []),
    *response_lines(operation).flatten.map { |line| "  #{line}" },
    "end",
  ]
end

# Required query parameters are sent, not guessed at: the operation is declared
# with them, so the request is validated against that declaration before it is
# sent and a missing one fails the example rather than the endpoint.
def query_values(operation, path)
  parameters(operation, path)
    .select { |parameter| parameter["in"] == "query" && parameter["required"] }
    .to_h { |parameter| [parameter["name"].to_sym, example(parameter["schema"] || parameter)] }
end

def example_lines(path, verb, operation)
  body = request_body(operation, path)
  values = path_values(operation, path)
  query = query_values(operation, path)

  arguments = [
    ":#{verb}",
    success(operation),
    *("path_params: #{pretty(values.transform_keys(&:to_sym), 4)}" unless values.empty?),
    *("params: #{pretty(query, 4)}" unless query.empty?),
    *("body: #{pretty(example(body["schema"]), 4)}" if body && body["schema"]),
  ]

  [
    "it #{"#{verb.upcase} #{base}#{path} answers #{success(operation)}".inspect} do",
    *given(path, verb, operation).map { |line| "  #{line}" },
    "  assert_api_response #{arguments.join(", ")}",
    "end",
  ]
end

# The spec half of a page: everything below its `__END__`. Ruby stops reading
# the file there, so the router evaluates the routes and never sees this; the
# spec loader reads it back out.
# What has to exist before the request is worth making: the record the route
# reads, updates or deletes, keyed by exactly what the request will ask for.
def given(path, verb, operation)
  name = resource(path, operation)
  key = lookup(path, operation)

  if name.nil? || !resources.include?(name) || verb == "post"
    []
  elsif key
    ["Factory[#{INFLECT.singularize(table(name)).to_sym.inspect}, #{key_param(key).to_sym.inspect} => #{key.fetch("value").inspect}]"]
  else
    ["Factory[#{INFLECT.singularize(table(name)).to_sym.inspect}]"]
  end
end

def spec(path, operations)
  declared = operations.slice(*VERBS)
  shared = declared.values.flat_map { |operation| parameters(operation, path) }
    .select { |parameter| parameter["in"] == "path" }
    .uniq { |parameter| parameter["name"] }

  [
    "# Scaffolded from #{File.basename(ARGV[0])}. One api_path per page, which is",
    "# what keeps `assert_api_response` unambiguous on sibling paths.",
    "RSpec.describe #{path.inspect}, type: :openapi do",
    "  openapi_schema :#{schema_name}",
    "",
    "  api_path #{path.inspect} do",
    *parameter_lines(shared).map { |line| "    #{line}" },
    *declared.flat_map { |verb, operation| ["", *operation_lines(path, verb, operation).map { |line| "    #{line}" }] },
    "  end",
    *declared.flat_map { |verb, operation| ["", *example_lines(path, verb, operation).map { |line| "  #{line}" }] },
    "end",
    "",
  ].join("\n")
end
