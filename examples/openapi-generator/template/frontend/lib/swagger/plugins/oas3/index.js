/**
 * @prettier
 */
import * as specWrapSelectors from "@/lib/swagger/plugins/oas3/spec-extensions/wrap-selectors"
import * as authWrapSelectors from "@/lib/swagger/plugins/oas3/auth-extensions/wrap-selectors"
import * as specSelectors from "@/lib/swagger/plugins/oas3/spec-extensions/selectors"
import components from "@/components/swagger/oas3/index"
import wrapComponents from "@/lib/swagger/plugins/oas3/wrap-components/index"
import * as actions from "@/lib/swagger/plugins/oas3/actions"
import * as selectors from "@/lib/swagger/plugins/oas3/selectors"
import reducers from "@/lib/swagger/plugins/oas3/reducers"
import { makeIsFileUploadIntended } from "@/lib/swagger/plugins/oas3/fn"

export default function ({ getSystem }) {
  const isFileUploadIntended = makeIsFileUploadIntended(getSystem)

  return {
    components,
    wrapComponents,
    statePlugins: {
      spec: {
        wrapSelectors: specWrapSelectors,
        selectors: specSelectors,
      },
      auth: {
        wrapSelectors: authWrapSelectors,
      },
      oas3: {
        actions: { ...actions },
        reducers,
        selectors: { ...selectors },
      },
    },
    fn: {
      isFileUploadIntended,
      isFileUploadIntendedOAS30: isFileUploadIntended,
    },
  }
}
