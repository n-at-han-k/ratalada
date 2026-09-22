/**
 * @prettier
 */
import DescriptionKeyword from "@/lib/swagger/plugins/oas32/json-schema-2020-12-extensions/components/keywords/Description"
import { createOnlyOAS32ComponentWrapper } from "@/lib/swagger/plugins/oas32/fn"

const DescriptionWrapper = createOnlyOAS32ComponentWrapper(DescriptionKeyword)

export default DescriptionWrapper
