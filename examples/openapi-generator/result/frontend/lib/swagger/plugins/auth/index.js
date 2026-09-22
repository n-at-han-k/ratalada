import reducers from "@/lib/swagger/plugins/auth/reducers"
import * as actions from "@/lib/swagger/plugins/auth/actions"
import * as selectors from "@/lib/swagger/plugins/auth/selectors"
import { execute as wrappedExecuteAction } from "@/lib/swagger/plugins/auth/spec-extensions/wrap-actions"
import { loaded as wrappedLoadedAction } from "@/lib/swagger/plugins/auth/configs-extensions/wrap-actions"
import { authorize as wrappedAuthorizeAction, logout as wrappedLogoutAction } from "@/lib/swagger/plugins/auth/wrap-actions"

import LockAuthIcon from "@/components/swagger/auth/lock-auth-icon"
import UnlockAuthIcon from "@/components/swagger/auth/unlock-auth-icon"

export default function() {
  return {
    afterLoad(system) {
      this.rootInjects = this.rootInjects || {}
      this.rootInjects.initOAuth = system.authActions.configureAuth
      this.rootInjects.preauthorizeApiKey = preauthorizeApiKey.bind(null, system)
      this.rootInjects.preauthorizeBasic = preauthorizeBasic.bind(null, system)
    },
    components: {
      LockAuthIcon: LockAuthIcon,
      UnlockAuthIcon: UnlockAuthIcon,
      LockAuthOperationIcon: LockAuthIcon,
      UnlockAuthOperationIcon: UnlockAuthIcon,
    },
    statePlugins: {
      auth: {
        reducers,
        actions,
        selectors,
        wrapActions: {
          authorize: wrappedAuthorizeAction,
          logout: wrappedLogoutAction,
        }
      },
      configs: {
        wrapActions: {
          loaded: wrappedLoadedAction,
        },
      },
      spec: {
        wrapActions: {
          execute: wrappedExecuteAction,
        },
      },
    }
  }
}

export function preauthorizeBasic(system, key, username, password) {
  const {
    authActions: { authorize },
    specSelectors: { specJson, isOAS3 }
  } = system

  const definitionBase = isOAS3() ? ["components", "securitySchemes"] : ["securityDefinitions"]

  const schema = specJson().getIn([...definitionBase, key])

  if(!schema) {
    return null
  }

  return authorize({
    [key]: {
      value: {
        username,
        password,
      },
      schema: schema.toJS()
    }
  })
}

export function preauthorizeApiKey(system, key, value) {
  const {
    authActions: { authorize },
    specSelectors: { specJson, isOAS3 }
  } = system

  const definitionBase = isOAS3() ? ["components", "securitySchemes"] : ["securityDefinitions"]

  const schema = specJson().getIn([...definitionBase, key])

  if(!schema) {
    return null
  }

  return authorize({
    [key]: {
      value,
      schema: schema.toJS()
    }
  })
}
