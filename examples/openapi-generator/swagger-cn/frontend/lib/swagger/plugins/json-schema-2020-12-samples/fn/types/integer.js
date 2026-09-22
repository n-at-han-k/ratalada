/**
 * @prettier
 */
import { integer as randomInteger } from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/core/random"
import formatAPI from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/api/formatAPI"
import int32Generator from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/generators/int32"
import int64Generator from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/generators/int64"
import { applyNumberConstraints } from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/types/number"

const generateFormat = (schema) => {
  const { format } = schema

  const formatGenerator = formatAPI(format)
  if (typeof formatGenerator === "function") {
    return formatGenerator(schema)
  }

  switch (format) {
    case "int32": {
      return int32Generator()
    }
    case "int64": {
      return int64Generator()
    }
  }

  return randomInteger()
}

const integerType = (schema) => {
  const { format } = schema
  let generatedInteger

  if (typeof format === "string") {
    generatedInteger = generateFormat(schema)
  } else {
    generatedInteger = randomInteger()
  }

  return applyNumberConstraints(generatedInteger, schema)
}

export default integerType
