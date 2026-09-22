import makeReducers from "@/lib/swagger/plugins/err/reducers"
import * as actions from "@/lib/swagger/plugins/err/actions"
import * as selectors from "@/lib/swagger/plugins/err/selectors"

export default function(system) {
  return {
    statePlugins: {
      err: {
        reducers: makeReducers(system),
        actions,
        selectors
      }
    }
  }
}
