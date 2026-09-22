import { OAS3ComponentWrapFactory } from "@/lib/swagger/plugins/oas3/helpers"
import OnlineValidatorBadge from "@/components/swagger/online-validator-badge"

// OAS3 spec is now supported by the online validator.
export default OAS3ComponentWrapFactory(OnlineValidatorBadge)
