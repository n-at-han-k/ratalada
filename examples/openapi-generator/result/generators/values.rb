# frozen_string_literal: true

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
