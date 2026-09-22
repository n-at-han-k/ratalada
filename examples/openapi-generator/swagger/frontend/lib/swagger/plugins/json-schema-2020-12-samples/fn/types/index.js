/**
 * @prettier
 */
import arrayType from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/types/array"
import objectType from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/types/object"
import stringType from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/types/string"
import numberType from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/types/number"
import integerType from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/types/integer"
import booleanType from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/types/boolean"
import nullType from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/types/null"

const typeMap = {
  array: arrayType,
  object: objectType,
  string: stringType,
  number: numberType,
  integer: integerType,
  boolean: booleanType,
  null: nullType,
}

export default new Proxy(typeMap, {
  get(target, prop) {
    if (typeof prop === "string" && Object.hasOwn(target, prop)) {
      return target[prop]
    }

    return () => `Unknown Type: ${prop}`
  },
})
