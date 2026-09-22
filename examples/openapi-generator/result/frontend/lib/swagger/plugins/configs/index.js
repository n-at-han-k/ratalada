import * as actions from "@/lib/swagger/plugins/configs/actions"
import * as selectors from "@/lib/swagger/plugins/configs/selectors"
import reducers from "@/lib/swagger/plugins/configs/reducers"

export default function configsPlugin() {

  return {
    statePlugins: {
      configs: {
        reducers,
        actions,
        selectors,
      }
    }
  }
}
