/**
 * @prettier
 */
import PropertiesKeyword from "@/lib/swagger/plugins/oas31/json-schema-2020-12-extensions/components/keywords/Properties"
import { createOnlyOAS31ComponentWrapper } from "@/lib/swagger/plugins/oas31/fn"

const PropertiesWrapper = createOnlyOAS31ComponentWrapper(PropertiesKeyword)

export default PropertiesWrapper
