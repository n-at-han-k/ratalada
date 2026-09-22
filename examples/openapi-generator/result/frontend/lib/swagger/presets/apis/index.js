/**
 * @prettier
 */
import BasePreset from "@/lib/swagger/presets/base/index"
import OpenAPI30Plugin from "@/lib/swagger/plugins/oas3/index"
import OpenAPI31Plugin from "@/lib/swagger/plugins/oas31/index"
import OpenAPI32Plugin from "@/lib/swagger/plugins/oas32/index"
import JSONSchema202012Plugin from "@/lib/swagger/plugins/json-schema-2020-12/index"
import JSONSchema202012SamplesPlugin from "@/lib/swagger/plugins/json-schema-2020-12-samples/index"

export default function PresetApis() {
  return [
    BasePreset,
    OpenAPI30Plugin,
    JSONSchema202012Plugin,
    JSONSchema202012SamplesPlugin,
    OpenAPI31Plugin,
    OpenAPI32Plugin, // Load LAST to override previous versions
  ]
}
