# frozen_string_literal: true

# ── names and literals, as the generated Ruby spells them ─────────────

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

