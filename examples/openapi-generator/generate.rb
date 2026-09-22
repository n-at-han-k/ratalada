# frozen_string_literal: true

# An OpenAPI document in, a whole ratalada API out -- three tools, one pass:
#
#   ruby generate.rb forgejo.json .
#
#   1. here          the document is annotated with what each route answers
#   2. openapi-generator-expo   writes the route half of every page: one file
#                    per path, named as the path (generator/src/ratalada)
#   3. openapi_ruby  the spec half, its own DSL, appended under __END__
#
#   app/**/*.rb      the routes, with their specs below __END__
#   lib/schemas/*.rb openapi_ruby component classes
#   config/openapi_ruby.rb, lib/openapi_ruby_patches.rb, spec/, bin/schema
#
# The two halves check each other. Mustermann::Expo spells file paths as
# routes, and every file the generator writes is spelled back through
# Mustermann::Expo.route. openapi_ruby goes the other way -- its specs DECLARE
# the document and `bin/schema` writes it back out -- so a spec generated from
# this document regenerates it.
#
# Swagger 2 and OpenAPI 3 are both read: `definitions` or `components/schemas`,
# a body parameter or a `requestBody`, `responses.<code>.schema` or a media
# type under `content`.

require "dry/inflector"
require "fileutils"
require "set"
require "json"
require "yaml"

require_relative "../../lib/ratalada/contrib/router/file_based/expo"

VERBS = %w[get put post delete patch options head].freeze

# ── paths ──────────────────────────────────────────────────────────────

# `/orgs/{slug}` -> `["orgs", "[slug]"]`
#
# A segment can hold more than one parameter -- Forgejo's
# `/pulls/{index}.{diffType}` is `[index].[diffType]`, which Mustermann::Expo
# reads as capture, literal dot, capture -- so this substitutes each in place
# rather than matching the segment whole.
def segments(path)
  path.split(?/).reject(&:empty?).map do |segment|
    segment.gsub(/\{([^{}\/]+)\}/) { "[#{Regexp.last_match(1)}]" }
  end
end

# Swagger 2 keeps the shared prefix out of the paths; every route hangs off it,
# and it is what openapi_ruby is configured with as the server and the
# middleware's prefix.
def base = DOCUMENT.fetch("basePath", "").delete_suffix(?/)

def route(path) = segments(path).join(?/).then { |spelled| "/#{spelled}" }

# A path that is the prefix of another is a directory, and its own page is the
# `index.rb` inside it: `/orgs` and `/orgs/{slug}` cannot both be `orgs.rb`.
def file_for(path, paths)
  parts = segments(path)
  branch = paths.any? { |other| other.start_with?("#{path.delete_suffix(?/)}/") }

  if parts.empty?
    "index.rb"
  elsif branch
    File.join(*parts, "index.rb")
  else
    "#{File.join(*parts)}.rb"
  end
end

def check(relative, path)
  spelled = Mustermann::Expo.route(relative)

  unless spelled == route(path)
    abort("#{relative} spells #{spelled}, not #{route(path)} -- generator bug")
  end
end

def write(path, contents)
  FileUtils.mkdir_p(File.dirname(path))
  File.write(path, contents)
end

# ── the document ───────────────────────────────────────────────────────

def definitions
  DOCUMENT["definitions"] || DOCUMENT.dig("components", "schemas") || {}
end

def resolve(schema)
  if schema["$ref"]
    DOCUMENT.dig(*schema["$ref"].delete_prefix("#/").split(?/)) || {}
  else
    schema
  end
end

# The first 2xx the operation declares; the status the handler answers with.
def success(operation)
  operation.fetch("responses", {}).keys.grep(/\A2\d\d\z/).min || "200"
end

# OpenAPI 3 hangs the schema off a media type; Swagger 2 puts it straight on
# the response, and the response itself may be a $ref into a reusable
# `responses` section -- which is how Swagger 2 documents most of a large API.
def response_schema(response)
  resolved = resolve(response)

  resolved.dig("content", "application/json", "schema") || resolved["schema"]
end

def parameters(operation, path)
  declared = DOCUMENT.dig("paths", path, "parameters").to_a + operation["parameters"].to_a

  declared.map { |parameter| resolve(parameter) }
end

# Swagger 2's body parameter, its formData parameters, and OpenAPI 3's
# requestBody, as one thing: {media, required, schema}.
#
# formData has no place in OpenAPI 3 -- it is a multipart body whose properties
# are the parameters -- so it is folded into one here, which is also what keeps
# the regenerated document valid.
def request_body(operation, path)
  declared = parameters(operation, path)
  body = declared.find { |parameter| parameter["in"] == "body" }
  form = declared.select { |parameter| parameter["in"] == "formData" }

  if body
    {"media" => "application/json", "required" => body.fetch("required", false), "schema" => body["schema"]}
  elsif form.any?
    {
      "media" => "multipart/form-data",
      "required" => form.any? { |parameter| parameter["required"] },
      "schema" => {
        "type" => "object",
        "required" => form.select { |parameter| parameter["required"] }.map { |parameter| parameter["name"] },
        "properties" => form.to_h { |parameter| [parameter["name"], parameter.slice("type", "format", "description")] },
      },
    }
  else
    operation["requestBody"]&.then do |declared_body|
      resolved = resolve(declared_body)
      media, content = resolved.fetch("content", {}).first

      {"media" => media, "required" => resolved.fetch("required", false), "schema" => content&.dig("schema")}
    end
  end
end

# ── values ─────────────────────────────────────────────────────────────

# An instance of a schema, as a Ruby literal: the response body a scaffolded
# page answers with, and the request body its spec sends.
#
# `seen` is the $refs already being expanded. A real document is cyclic -- a
# Forgejo Repository has a parent Repository -- so a ref that comes back stops
# at an empty object rather than recurring until the stack gives out.
def example(schema, seen = [])
  ref = schema["$ref"]

  if ref && seen.include?(ref)
    {}
  else
    shape(resolve(schema), seen + [*ref])
  end
end

def shape(resolved, seen)
  # An enum's first value, not a blank: a blank is not a member of the enum,
  # and the spec validates what the page answers against this same schema.
  if resolved["enum"]
    resolved["enum"].first
  else
    case Array(resolved["type"]).first
    when "array" then [example(resolved.fetch("items", {}), seen)]
    when "integer", "number" then 0
    when "boolean" then false
    # "file" is Swagger 2's upload/download type, which `rewrite` spells as a
    # binary string on the way into the document -- so answer one.
    when "string", "file" then string_for(resolved)
    else resolved.fetch("properties", {}).to_h { |name, property| [name, example(property, seen)] }
    end
  end
end

# `format` is what a validator with format assertion on would check, so answer
# something that passes rather than an empty string.
def string_for(resolved)
  case resolved["format"]
  when "date-time" then "2026-01-01T00:00:00Z"
  when "date" then "2026-01-01"
  when "email" then "someone@example.com"
  when "uri", "url" then "https://example.com"
  when "uuid" then "00000000-0000-4000-8000-000000000000"
  else ""
  end
end

# A path segment cannot be blank -- `/repos//` routes nowhere -- so a string
# with nothing better to say is named after the parameter it fills.
def path_values(operation, path)
  key = lookup(path, operation)

  parameters(operation, path)
    .select { |parameter| parameter["in"] == "path" }
    .to_h do |parameter|
      value = example(parameter["schema"] || parameter)

      if key && parameter["name"] == path[/\{([^{}\/]+)\}[^\/{}]*\z/, 1]
        # What the seed stored, so the route this spec fetches has a record.
        [parameter["name"], key.fetch("value")]
      else
        [parameter["name"], value == "" ? parameter["name"] : value]
      end
    end
end

# Refs travel from the document into generated Ruby, and Swagger 2 keeps its
# schemas somewhere openapi_ruby does not look. `type: file` is Swagger 2's
# upload type and not a JSON Schema type at all, so it becomes the binary
# string OpenAPI 3 spells it as -- otherwise the regenerated document fails
# its own validation.
def rewrite(value)
  case value
  when Hash
    if value["type"] == "file"
      value.merge("type" => "string", "format" => "binary").then { |fixed| rewrite(fixed) }
    else
      value.to_h { |key, nested| [key, key == "$ref" ? component_ref(nested) : rewrite(nested)] }
    end
  when Array then value.map { |nested| rewrite(nested) }
  else value
  end
end

def component_ref(ref) = "#/components/schemas/#{ref.split(?/).last}"

# The component class, which openapi_ruby accepts anywhere a $ref is expected:
# a typo is a NameError instead of a dangling reference in the document.
def schema_class(ref) = "Schemas::#{constant(ref.split(?/).last)}"

# `#inspect` puts a 40-key schema on one line. This is the same literal, laid
# out: one entry per line, indented, and short things left inline.
def literal(value, indent = 0) = pretty(rewrite(value), indent)

INLINE = 60

def pretty(value, indent)
  if value.is_a?(Hash) && value.keys == ["$ref"]
    return schema_class(value["$ref"])
  end

  flat = value.inspect

  if flat.length <= INLINE || !value.is_a?(Hash) && !value.is_a?(Array)
    flat
  elsif value.is_a?(Array)
    wrap("[", value.map { |item| pretty(item, indent + 2) }, "]", indent)
  else
    wrap("{", value.map { |key, nested| "#{key.inspect} => #{pretty(nested, indent + 2)}" }, "}", indent)
  end
end

def wrap(open, entries, close, indent)
  pad = " " * (indent + 2)

  [open, *entries.map { |entry| "#{pad}#{entry}," }, "#{" " * indent}#{close}"].join("\n")
end

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

# What goes in the columns: a JSON column takes text, every other column takes
# the value as it stands.
def storable(name, attributes)
  json = columns(name).select { |var| json_column?(var, name) }.map { |var| var["name"] }

  attributes.to_h do |column, value|
    if json.include?(column) || nested?(value)
      [column, JSON.generate(value)]
    else
      [column, value]
    end
  end
end

# The helpers every page shares. A root layout is evaluated into each route
# file below it, which is where the relations come into scope.
def layout
  <<~'RUBY'
    # frozen_string_literal: true

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
  RUBY
end

# ── the patched generator ─────────────────────────────────────────────

GENERATOR = "openapi-generator-expo"

def pages(root)
  annotated = File.join(root, "tmp/annotated.json")
  out = File.join(root, "tmp/pages")

  write(annotated, JSON.generate(DOCUMENT))
  FileUtils.rm_rf(out)

  ok = system(
    GENERATOR,
    "generate",
    # models too: they are not written as files (the generator has no model
    # template) but `allModels` is only populated when they are generated, and
    # models.json is a supporting file built from it.
    "--global-property", "apis,models,supportingFiles",
    "-g", "ratalada-expo",
    "-i", annotated,
    "-t", File.expand_path("generator/templates", __dir__),
    "-o", out,
    out: File::NULL,
  )

  unless ok
    abort("#{GENERATOR} failed")
  end

  File.join(out, "app")
end

# ── persistence ───────────────────────────────────────────────────────
#
# The generator writes models.json -- every schema with its columns, their
# types, and which of them are other models. That file is the contract this
# section reads: it builds the tables, the ROM relations over them, the structs
# they map to, and the seeds, all from the same description the DDL generators
# (postgresql-schema, mysql-schema) build DDL from.
#
# A column holding another model, an array or a map is stored as JSON text and
# read back parsed, so what comes out of the database is what the response
# schema promised.

INFLECT = Dry::Inflector.new

def models = @models ||= {}

def load_models!(directory)
  JSON.parse(File.read(File.join(directory, "models.json")))
    .fetch("models")
    .each { |model| models[model.fetch("name")] = model.fetch("vars") }
end

# ── the schema, from the SQL generator ────────────────────────────────
#
# `-g postgresql-schema` is openapi-generator's own DDL for this document: one
# table per schema, typed columns, and `id` as a real key where the document
# declares one. That file is the schema -- the migrations are it, translated,
# and the relations are declared over what it says.

SQL_GENERATOR = "openapi-generator-cli"

def sql_schema(root)
  out = File.join(root, "tmp/sql")

  FileUtils.rm_rf(out)

  ok = system(
    SQL_GENERATOR,
    "generate",
    "-g", "postgresql-schema",
    "-i", File.join(root, "tmp/annotated.json"),
    "-o", out,
    # An integer `id` becomes BIGSERIAL rather than a plain column: a table
    # wants the key the document already spells.
    # Identifiers keep the document's spelling. A column is a property the API
    # answers with, so renaming one renames a JSON key the document promised.
    # Table names are nobody's promise -- those this snake_cases itself, when
    # it translates the DDL into a migration.
    "--additional-properties=idAutoIncEnabled=true,identifierNamingConvention=original",
    out: File::NULL,
  )

  unless ok
    abort("#{SQL_GENERATOR} failed")
  end

  File.join(out, "postgresql_schema.sql")
end

# `CREATE TABLE IF NOT EXISTS x ( "col" TYPE DEFAULT NULL, ... );`
def parse_sql(path)
  File.read(path).scan(/CREATE TABLE IF NOT EXISTS (\w+) \(\n(.*?)\n\);/m).to_h do |name, body|
    columns = body.split(",\n").filter_map do |line|
      # A column name may be quoted, and a document may spell one `@context`.
      # The type is whatever word follows -- including a lowercase enum type
      # the SQL generator declared for an enumerated property.
      matched = line.strip.match(/\A"?([^"\s,]+)"?\s+(\S+)/)

      matched && {"name" => matched[1], "sql" => matched[2].upcase}
    end

    [name, columns]
  end
end

def tables = @tables ||= parse_sql(@schema_path)

# The DDL names its table after the model (`ActionRun`); this is the one name
# nothing in the document depends on, so it is the one thing renamed.
def table(name) = snake(name)

# ── relations over those tables ───────────────────────────────────────

# The models a path answers with: those are the resources, and only they get a
# relation. Everything else is a column inside one.
def resources
  @resources ||= DOCUMENT.fetch("paths").flat_map { |path, operations|
    operations.slice(*VERBS).filter_map { |_verb, operation| answered(operation) }
  }.uniq.select { |name| models.key?(name) && tables.key?(name) }
end

# The model a success response is, or is a list of.
def answered(operation)
  schema = response_schema(operation.dig("responses", success(operation)) || {}) || {}
  ref = schema["$ref"] || schema.dig("items", "$ref")

  ref&.split(?/)&.last
end

def collection?(operation)
  schema = response_schema(operation.dig("responses", success(operation)) || {}) || {}

  !schema.dig("items", "$ref").nil?
end

SCALAR = %w[isString isInteger isLong isNumber isFloat isDouble isBoolean isDate isDateTime].freeze

# The flags a model carries, and what the document actually puts in the
# property. The two disagree -- a `type: array, items: string` property comes
# back flagged as a string as well as an array -- and the value wins, because
# the value is what the column has to hold.
def json_names(name)
  @json_names ||= {}
  @json_names[name] ||= resolve({"$ref" => "#/definitions/#{name}"})
    .fetch("properties", {})
    .filter_map { |property, schema| property if nested?(example(schema)) }
    .to_set
end

def nested?(value) = value.is_a?(Array) || value.is_a?(Hash)

def json_column?(var, name = nil)
  SCALAR.none? { |flag| var[flag] } || (name && json_names(name).include?(var["name"]))
end

# The columns a RELATION declares: the model's own, from models.json, plus the
# keys the routes look records up by and a key where the document declared
# none. The SQL is not consulted here -- it is the migrations' source, and a
# relation is declared over the model it maps.
def columns(name)
  declared = models.fetch(name).reject { |var| var["name"] == "id" }
  keys = route_keys(name).map { |column| {"name" => column, "isString" => true} }

  [{"name" => "id", "isInteger" => true}, *keys, *declared].uniq { |var| var["name"] }
end

# What the SQL says, in Sequel's spelling -- for the migrations, which are the
# only thing built from the DDL. TIMESTAMP stays text: the document's values
# are ISO strings, and a round trip through Time would answer in a format the
# response schema does not accept.
def sequel_type(var)
  case var["sql"]
  when "BOOLEAN" then "TrueClass"
  when "SMALLINT", "INTEGER", "BIGINT" then "Integer"
  when "REAL", "DOUBLE", "NUMERIC", "DECIMAL" then "Float"
  else "String, text: true"
  end
end

def rom_type(var)
  if var["isInteger"] || var["isLong"] then "Types::Integer"
  elsif var["isNumber"] || var["isFloat"] || var["isDouble"] then "Types::Float"
  elsif var["isBoolean"] then "Types::Bool"
  else "Types::String"
  end
end

def attribute_lines(name)
  columns(name).map do |var|
    if json_column?(var, name)
      # Text in the column, parsed on the way out: the response schema promised
      # an object, and an object is what comes out. Writes hand it the text
      # (see `accepted` in app/_layout.rb).
      #
      # `Any`, because the value the column holds and the value the API answers
      # with are different types, and the struct is built from the attribute's.
      "      attribute #{var["name"].to_sym.inspect}, Types::Any, read: Parsed"
    else
      "      attribute #{var["name"].to_sym.inspect}, #{rom_type(var)}.optional"
    end
  end
end

def relation_file(name)
  <<~RUBY
    # frozen_string_literal: true

    # #{name} -- columns from models.json, over the table the migrations made.
    module Models
      class #{constant(name)} < ROM::Relation[:sql]
        schema(#{table(name).to_sym.inspect}, infer: false) do
    #{attribute_lines(name).join("\n")}

          primary_key :id
        end

        auto_struct true
        struct_namespace Entities
      end
    end
  RUBY
end

def struct_file(name)
  <<~RUBY
    # frozen_string_literal: true

    # What the #{table(name)} model maps to. Add methods here: a struct is data, and these
    # are the only place behaviour over that data belongs.
    module Entities
      class #{constant(name)} < ROM::Struct
      end
    end
  RUBY
end

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

def factories_helper
  <<~'RUBY'
    # frozen_string_literal: true

    require "rom-factory"

    # Factories build through the relations, so they write what the columns
    # hold and read back what the API answers.
    unless defined?(Factory)
      Factory = ROM::Factory.configure do |config|
        config.rom = ROM_CONTAINER
      end
    end

    Dir[File.expand_path("factories/*.rb", __dir__)].sort.each { |file| require file }
  RUBY
end

# The container, the tables and the seeds: one file, because they are one
# decision -- where the data lives.
# The schema as Sequel migrations: every table db/schema.sql declares,
# translated column by column. The SQL is the source; this is it in the DSL
# Sequel migrates with.
def schema_migration
  [
    "# frozen_string_literal: true",
    "",
    "# Translated from db/schema.sql, which `openapi-generator-cli -g",
    "# postgresql-schema` wrote from the document. Edit the document, not this.",
    "Sequel.migration do",
    "  change do",
    *tables.sort.flat_map { |name, declared| create_table(name, declared, 4) },
    "  end",
    "end",
    "",
  ].join("\n")
end

def create_table(name, declared, indent)
  pad = " " * indent
  key = declared.find { |var| var["sql"].end_with?("SERIAL") }

  body = declared.reject { |var| var.equal?(key) }.map do |var|
    "#{pad}  column #{var["name"].to_sym.inspect}, #{sequel_type(var)}"
  end

  [
    # The table's name is snake_cased here and nowhere else: the DDL calls it
    # after the model, and this is the only name the document does not promise.
    "#{pad}create_table(#{snake(name).to_sym.inspect}) do",
    *(key ? ["#{pad}  primary_key #{key["name"].to_sym.inspect}"] : []),
    *body,
    "#{pad}end",
  ]
end

# What the document cannot say: a route takes a key (`/repos/{owner}/{repo}`
# looks up `repo`), and a table has to keep it. A table the document gave no
# key of its own also gets one here.
def keys_migration
  additions = resources.sort.flat_map do |name|
    declared = tables.fetch(name)
    keyless = declared.none? { |var| var["name"] == "id" }
    keys = route_keys(name)

    if keyless || keys.any?
      [
        "    alter_table(#{table(name).to_sym.inspect}) do",
        *(keyless ? ["      add_primary_key :id"] : []),
        *keys.map { |column| "      add_column #{column.to_sym.inspect}, String, text: true" },
        "    end",
      ]
    else
      []
    end
  end

  [
    "# frozen_string_literal: true",
    "",
    "# The keys the routes look records up by, which the document has no way to",
    "# declare -- and a primary key for a table the document gave none.",
    "Sequel.migration do",
    "  change do",
    *additions,
    "  end",
    "end",
    "",
  ].join("\n")
end

def rom_config
  [
    "# frozen_string_literal: true",
    "",
    "require \"fileutils\"",
    "require \"json\"",
    "require \"rom\"",
    "require \"rom-sql\"",
    "",
    "require_relative \"../lib/types\"",
    "",
    "# A file, not :memory:, so the data outlives the process that wrote it.",
    "DB_PATH = File.expand_path(\"../db/api.sqlite\", __dir__)",
    "",
    "FileUtils.mkdir_p(File.dirname(DB_PATH))",
    "",
    %(DATABASE = ENV.fetch("DATABASE_URL") { "sqlite://\#{DB_PATH}" }),
    "",
    "ROM_CONFIG = ROM::Configuration.new(:sql, DATABASE)",
    "",
    "# The tables the relations below are declared over. The migrator is",
    "# idempotent: it applies what db/migrate holds and nothing it already has.",
    "Sequel.extension(:migration)",
    "Sequel::Migrator.run(ROM_CONFIG.gateways[:default].connection, File.expand_path(\"../db/migrate\", __dir__))",
    "",

    "# Entities first: a relation names the struct it maps to.",
    "Dir[File.expand_path(\"../lib/entities/*.rb\", __dir__)].sort.each { |file| require file }",
    "Dir[File.expand_path(\"../lib/models/*.rb\", __dir__)].sort.each { |file| require file }",
    "",
    "ROM_CONFIG.register_relation(*Models.constants.map { |name| Models.const_get(name) })",
    "",
    "ROM_CONTAINER = ROM.container(ROM_CONFIG)",
    "",
    "# Last, after finalization has read every table's schema: a server that",
    "# forks its workers would hand each of them the same sqlite handle, and",
    "# the first to close it closes it for all of them. Sequel reconnects on",
    "# demand, once per process.",
    "ROM_CONFIG.gateways[:default].connection.disconnect",
    "",
  ].join("\n")
end

# The read and write types every JSON column shares.
def types_file
  <<~'RUBY'
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
  RUBY
end

# ── the openapi_ruby components ────────────────────────────────────────

# openapi-generator's own `underscore`, which is what names the tables in the
# SQL it writes: `APIError` is `api_error`, not `apierror`.
def snake(name)
  name.gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
    .gsub(/([a-z\d])([A-Z])/, '\1_\2')
    .gsub(/[^A-Za-z\d]+/, "_")
    .downcase
    .delete_prefix("_")
end

def constant(name) = name.gsub(/[^A-Za-z\d]/, "").then { |bare| bare.sub(/\A\d/) { "N#{_1}" } }

# Inside a component, refs stay strings. The 248 classes reference each other
# in both directions, and a class reference has to resolve while the file that
# names it is loading -- which no load order can promise.
def strings(value, indent) = pretty_strings(rewrite(value), indent)

def pretty_strings(value, indent)
  flat = value.inspect

  if flat.length <= INLINE || !value.is_a?(Hash) && !value.is_a?(Array)
    flat
  elsif value.is_a?(Array)
    wrap("[", value.map { |item| pretty_strings(item, indent + 2) }, "]", indent)
  else
    wrap("{", value.map { |key, nested| "#{key.inspect} => #{pretty_strings(nested, indent + 2)}" }, "}", indent)
  end
end

def component(name, schema)
  <<~RUBY
    # frozen_string_literal: true

    class Schemas::#{constant(name)}
      include OpenapiRuby::Components::Base

      # The document's own spelling: nothing here is camelized on the way out.
      skip_key_transformation true

      schema(#{strings(schema, 2)})
    end
  RUBY
end

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

# ── the wiring ─────────────────────────────────────────────────────────

def schema_name = "public_api"

def info = DOCUMENT.fetch("info", {})

def config_file
  <<~RUBY
    # frozen_string_literal: true

    require "openapi_ruby"

    # The document's own info and basePath. `prefix` scopes the validation
    # middleware to the API, leaving anything else mounted alongside it alone.
    OpenapiRuby.configure do |config|
      config.schemas = {
        #{schema_name}: {
          info: {title: #{info["title"].to_s.inspect}, version: #{info.fetch("version", "1.0").to_s.inspect}},
          servers: [{url: #{(base.empty? ? "/" : base).inspect}}],
          prefix: #{(base.empty? ? "/" : base).inspect},
        },
      }

      # The document is the source of truth for spelling; nothing is renamed.
      config.camelize_keys = false

      # The directory under this path names the namespace: lib/schemas/*.rb is
      # Schemas::*.
      config.component_paths = ["lib"]

      # Off for the specs, which validate against the declared operations
      # themselves. server.rb turns them on for the running app.
      config.request_validation = :disabled
      config.response_validation = :disabled
    end
  RUBY
end

# What the gem gets wrong, reopened rather than worked around. A document is
# not ours to rename, so where the gem cannot read one, it is the gem that
# moves.
def patches
  <<~'RUBY'
    # frozen_string_literal: true

    require "openapi_ruby"

    module OpenapiRuby
      module Adapters
        module RSpec
          # Path parameters are substituted with /\{(\w+)\}/ upstream, and `\w`
          # excludes the hyphen -- so Forgejo's `{user-id}` is never filled and
          # the request goes out with the template still in the URI, which
          # raises URI::InvalidURIError. A path parameter's name is whatever the
          # document says it is; anything but a brace or a slash counts.
          module HyphenatedPathParams
            TEMPLATE = /\{([^{}\/]+)\}/

            def expand_path(template, params)
              template.gsub(TEMPLATE) do
                name = ::Regexp.last_match(1)

                params[name.to_sym] || params[name.to_s] || "{#{name}}"
              end
            end

            def resolve_path(metadata)
              super.gsub(TEMPLATE) do
                name = ::Regexp.last_match(1)

                resolve_let(name.to_sym) || "{#{name}}"
              end
            end
          end

          ExampleHelpers.prepend(HyphenatedPathParams)
        end
      end
    end
  RUBY
end

# RSpec sees one file; the examples come from the pages. Each is evaluated
# with its own path and line number, so a failure points into the page that
# declared it.
def pages_spec
  <<~'RUBY'
    # frozen_string_literal: true

    require "spec_helper"

    Dir[File.expand_path("../app/**/*.rb", __dir__)].sort.each do |page|
      lines = File.readlines(page)
      index = lines.index { |line| line.chomp == "__END__" }

      unless index.nil?
        eval(lines[(index + 1)..].join, TOPLEVEL_BINDING, page, index + 2) # rubocop:disable Security/Eval
      end
    end
  RUBY
end

def schema_script
  <<~'RUBY' 
    #!/usr/bin/env ruby
    # frozen_string_literal: true

    # The document, out of the specs' own declarations -- SchemaWriter directly,
    # not `rake openapi_ruby:generate`, which shells out to a subprocess that
    # does this much with none of it in reach.
    #
    # Loading a spec file must not also run it: both frameworks register an
    # at_exit hook when required, so the suppressor goes in first.
    # rspec/core, not rspec: `openapi_ruby/rspec` configures ::RSpec on
    # require, and rspec/autorun is what would run the suite.
    require "rspec/core"

    require "openapi_ruby"
    require "openapi_ruby/generator/autorun_suppressor"

    OpenapiRuby::Generator::AutorunSuppressor.install!

    # The specs `require "spec_helper"`, which is .rspec's `-I spec` when rspec
    # runs them and nobody's when this does.
    $LOAD_PATH.unshift(File.expand_path("../spec", __dir__))

    require "spec_helper"

    # The declarations live under each page's __END__; this loads them all.
    require "pages_spec"

    OpenapiRuby::Generator::SchemaWriter.generate_all!

    puts "wrote #{Dir[File.expand_path("../openapi/*", __dir__)].join(", ")}"
  RUBY
end

def spec_helper
  <<~RUBY
    # frozen_string_literal: true

    # Sinatra only relaxes host authorization outside development, and rack-test
    # sends `Host: example.org`.
    ENV["APP_ENV"] ||= "test"

    require "ratalada/sinatra"
    require "ratalada/contrib/router/file_based/sinatra_adapter"

    # The relations the pages read and write.
    require_relative "../config/rom"

    require_relative "../config/openapi_ruby"
    require_relative "factories"
    require "openapi_ruby/rspec"
    require_relative "../lib/openapi_ruby_patches"

    # The components, up front: a spec names `Schemas::Repository` while it is
    # being loaded, so the class has to exist before RSpec reads the file.
    OpenapiRuby::Components::Loader.new.load!

    # The routes are the file tree, so the app under test is built from it --
    # no server, no backend, just the rack app rack-test drives.
    APP = Ratalada::Contrib::Router::FileBased.build(File.expand_path("../app", __dir__))

    module AppUnderTest
      def app = APP
    end

    RSpec.configure do |config|
      config.include AppUnderTest, type: :openapi

      # Every example runs inside a transaction that is rolled back, so what a
      # factory builds is gone before the next one asks the same question.
      config.around do |example|
        ROM_CONFIG.gateways[:default].connection.transaction(rollback: :always) { example.run }
      end
    end
  RUBY
end

# ── main ───────────────────────────────────────────────────────────────

def generate(root)
  paths = DOCUMENT.fetch("paths")

  written = pages(root)
  load_models!(File.dirname(written))

  # The schema, from the document the generator was handed.
  @schema_path = sql_schema(root)
  write(File.join(root, "db/schema.sql"), File.read(@schema_path))

  annotate!
  written = pages(root)

  paths.each do |path, operations|
    relative = File.join(*segments(base), file_for(path, paths.keys))
    check(relative, "#{base}#{path}")

    page = File.join(written, relative)

    # The generator named this file from the same path this did. If the two
    # disagree the spec would land on the wrong route, so say so instead.
    unless File.exist?(page)
      abort("#{GENERATOR} wrote no #{relative} for #{path}")
    end

    write(
      File.join(root, "app", relative),
      [File.read(page).rstrip, "", "__END__", "", spec(path, operations)].join("\n"),
    )
  end

  write(File.join(root, "app/_layout.rb"), layout)

  definitions.each do |name, schema|
    write(File.join(root, "lib/schemas", "#{snake(name)}.rb"), component(name, schema))
  end

  resources.each do |name|
    write(File.join(root, "lib/models", "#{snake(name)}.rb"), relation_file(name))
    write(File.join(root, "lib/entities", "#{snake(name)}.rb"), struct_file(name))
    write(File.join(root, "spec/factories", "#{snake(name)}.rb"), factory_file(name))
  end

  write(File.join(root, "lib/types.rb"), types_file)
  write(File.join(root, "db/migrate/001_schema.rb"), schema_migration)
  write(File.join(root, "db/migrate/002_route_keys.rb"), keys_migration)
  write(File.join(root, "config/rom.rb"), rom_config)

  write(File.join(root, "config/openapi_ruby.rb"), config_file)
  write(File.join(root, "lib/openapi_ruby_patches.rb"), patches)
  write(File.join(root, "spec/spec_helper.rb"), spec_helper)
  write(File.join(root, "spec/factories.rb"), factories_helper)
  write(File.join(root, "spec/pages_spec.rb"), pages_spec)
  write(File.join(root, "bin/schema"), schema_script)
  FileUtils.chmod(0o755, File.join(root, "bin/schema"))
  FileUtils.rm_rf(File.join(root, "tmp"))

  puts "#{paths.size} pages, #{definitions.size} components, #{resources.size} relations"
end

spec_path, root = ARGV

unless spec_path && root
  abort("usage: ruby generate.rb <document> <output directory>")
end

DOCUMENT = YAML.safe_load(File.read(spec_path), aliases: true)

generate(root)
