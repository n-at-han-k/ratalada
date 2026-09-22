/**
 * @prettier
 */
import Registry from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/class/Registry"
import textMediaTypesGenerators from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/generators/media-types/text"
import imageMediaTypesGenerators from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/generators/media-types/image"
import audioMediaTypesGenerators from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/generators/media-types/audio"
import videoMediaTypesGenerators from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/generators/media-types/video"
import applicationMediaTypesGenerators from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/generators/media-types/application"

class MediaTypeRegistry extends Registry {
  #defaults = {
    ...textMediaTypesGenerators,
    ...imageMediaTypesGenerators,
    ...audioMediaTypesGenerators,
    ...videoMediaTypesGenerators,
    ...applicationMediaTypesGenerators,
  }

  data = { ...this.#defaults }

  get defaults() {
    return { ...this.#defaults }
  }
}

export default MediaTypeRegistry
