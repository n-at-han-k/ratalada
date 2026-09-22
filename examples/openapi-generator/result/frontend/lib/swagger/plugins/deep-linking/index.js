import layout from "@/lib/swagger/plugins/deep-linking/layout"
import OperationWrapper from "@/lib/swagger/plugins/deep-linking/operation-wrapper"
import OperationTagWrapper from "@/lib/swagger/plugins/deep-linking/operation-tag-wrapper"

export default function() {
  return [layout, {
    statePlugins: {
      configs: {
        wrapActions: {
          loaded: (ori, system) => (...args) => {
            ori(...args)
            // location.hash was an UTF-16 String, here is required UTF-8
            const hash = decodeURIComponent(window.location.hash)
            system.layoutActions.parseDeepLinkHash(hash)
          }
        }
      }
    },
    wrapComponents: {
      operation: OperationWrapper,
      OperationTag: OperationTagWrapper,
    },
  }]
}
