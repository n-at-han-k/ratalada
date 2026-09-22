/**
 * @prettier
 */
import reducers from "@/lib/swagger/plugins/spec/reducers"
import * as actions from "@/lib/swagger/plugins/spec/actions"
import * as selectors from "@/lib/swagger/plugins/spec/selectors"
import * as wrapActions from "@/lib/swagger/plugins/spec/wrap-actions"

const SpecPlugin = () => ({
  statePlugins: {
    spec: {
      wrapActions: { ...wrapActions },
      reducers: { ...reducers },
      actions: { ...actions },
      selectors: { ...selectors },
    },
  },
})

export default SpecPlugin
