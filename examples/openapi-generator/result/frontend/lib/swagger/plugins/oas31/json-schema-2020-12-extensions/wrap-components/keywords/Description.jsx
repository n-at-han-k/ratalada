/**
 * @prettier
 */
import DescriptionKeyword from "@/lib/swagger/plugins/oas31/json-schema-2020-12-extensions/components/keywords/Description"
import { createOnlyOAS31ComponentWrapper } from "@/lib/swagger/plugins/oas31/fn"

const DescriptionWrapper = createOnlyOAS31ComponentWrapper(DescriptionKeyword)

export default DescriptionWrapper
