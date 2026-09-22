# frozen_string_literal: true

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
