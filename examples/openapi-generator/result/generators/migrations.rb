# frozen_string_literal: true

# ── the migrations ────────────────────────────────────────────────────

# The schema as Sequel migrations: every table db/schema.sql declares,
# translated column by column. The SQL is the source; this is it in the DSL
# Sequel migrates with.
def schema_migration
  [
    "# frozen_string_literal: true",
    "",
    "# Translated from db/schema.sql, which `openapi-generator-cli -g",
    "# postgresql-schema` wrote from the document. Edit the document, not this.",
    "#",
    "# `up`, and `create_table?` rather than `create_table`: sqlite answers",
    "# false to `supports_transactional_ddl?`, so Sequel runs this OUTSIDE a",
    "# transaction. A boot interrupted partway through 200-odd tables leaves",
    "# every table it managed and no version recorded, and the next boot used",
    "# to die on the first one it had already made. Creating only what is",
    "# missing lets a half-applied migration finish instead of wedging.",
    "Sequel.migration do",
    "  up do",
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
    "#{pad}create_table?(#{snake(name).to_sym.inspect}) do",
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
      # Guarded for the same reason 001 is: this migration is not in a
      # transaction either, so it has to be safe to run again over its own
      # half-finished work.
      [
        "    columns = schema(#{table(name).to_sym.inspect}).map(&:first)",
        "    alter_table(#{table(name).to_sym.inspect}) do",
        *(keyless ? ["      add_primary_key :id unless columns.include?(:id)"] : []),
        *keys.map { |column| "      add_column #{column.to_sym.inspect}, String, text: true unless columns.include?(#{column.to_sym.inspect})" },
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
    "  up do",
    *additions,
    "  end",
    "end",
    "",
  ].join("\n")
end
