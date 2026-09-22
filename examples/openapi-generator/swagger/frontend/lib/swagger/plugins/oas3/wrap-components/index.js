import Markdown from "@/lib/swagger/plugins/oas3/wrap-components/markdown"
import AuthItem from "@/lib/swagger/plugins/oas3/wrap-components/auth/auth-item"
import OnlineValidatorBadge from "@/lib/swagger/plugins/oas3/wrap-components/online-validator-badge"
import Model from "@/lib/swagger/plugins/oas3/wrap-components/model"
import JsonSchema_string from "@/lib/swagger/plugins/oas3/wrap-components/json-schema-string"
import OpenAPIVersion from "@/lib/swagger/plugins/oas3/wrap-components/openapi-version"

export default {
  Markdown,
  AuthItem,
  OpenAPIVersion,
  JsonSchema_string,
  model: Model,
  onlineValidatorBadge: OnlineValidatorBadge,
}
