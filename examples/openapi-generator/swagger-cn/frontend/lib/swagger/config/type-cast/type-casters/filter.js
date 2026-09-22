/**
 * @prettier
 */
import booleanTypeCaster from "@/lib/swagger/config/type-cast/type-casters/boolean"

const filterTypeCaster = (value) => {
  const defaultValue = String(value)
  return booleanTypeCaster(value, defaultValue)
}

export default filterTypeCaster
