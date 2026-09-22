# frozen_string_literal: true

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

