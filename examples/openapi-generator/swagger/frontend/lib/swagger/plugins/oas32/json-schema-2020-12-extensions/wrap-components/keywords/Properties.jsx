/**
 * @prettier
 */
import PropertiesKeyword from "@/lib/swagger/plugins/oas32/json-schema-2020-12-extensions/components/keywords/Properties"
import { createOnlyOAS32ComponentWrapper } from "@/lib/swagger/plugins/oas32/fn"

const PropertiesWrapper = createOnlyOAS32ComponentWrapper(PropertiesKeyword)

export default PropertiesWrapper
