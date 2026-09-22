/**
 * @prettier
 */
import Registry from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/class/Registry"

class OptionRegistry extends Registry {
  #defaults = {}

  data = { ...this.#defaults }

  get defaults() {
    return { ...this.#defaults }
  }
}

export default OptionRegistry
