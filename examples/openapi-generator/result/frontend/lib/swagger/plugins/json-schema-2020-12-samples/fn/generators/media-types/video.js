/**
 * @prettier
 */
import { bytes } from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/core/random"

const videoMediaTypesGenerators = {
  "video/*": () => bytes(25).toString("binary"),
}

export default videoMediaTypesGenerators
