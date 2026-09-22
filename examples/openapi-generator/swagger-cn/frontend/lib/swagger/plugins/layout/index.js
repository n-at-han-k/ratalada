import reducers from "@/lib/swagger/plugins/layout/reducers"
import * as actions from "@/lib/swagger/plugins/layout/actions"
import * as selectors from "@/lib/swagger/plugins/layout/selectors"
import * as wrapSelectors from "@/lib/swagger/plugins/layout/spec-extensions/wrap-selector"

export default function() {
  return {
    statePlugins: {
      layout: {
        reducers,
        actions,
        selectors
      },
      spec: {
        wrapSelectors
      }
    }
  }
}
