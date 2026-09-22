/**
 * @prettier
 */

import OptionRegistry from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/class/OptionRegistry"

const registry = new OptionRegistry()

const optionAPI = (optionName, optionValue) => {
  if (typeof optionValue !== "undefined") {
    registry.register(optionName, optionValue)
  }

  return registry.get(optionName)
}

export default optionAPI
