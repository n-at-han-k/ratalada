/**
 * @prettier
 */
import { isBooleanJSONSchema, isJSONSchemaObject } from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/core/predicates"

export const fromJSONBooleanSchema = (schema) => {
  if (schema === false) {
    return { not: {} }
  }

  return {}
}

export const typeCast = (schema) => {
  if (isBooleanJSONSchema(schema)) {
    return fromJSONBooleanSchema(schema)
  }
  if (!isJSONSchemaObject(schema)) {
    return {}
  }

  return schema
}
