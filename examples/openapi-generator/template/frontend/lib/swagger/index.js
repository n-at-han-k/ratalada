/**
 * @prettier
 */
import System from "@/lib/swagger/system"
// presets
import BasePreset from "@/lib/swagger/presets/base/index"
import ApisPreset from "@/lib/swagger/presets/apis/index"
// plugins
import AccessibilityPlugin from "@/lib/swagger/plugins/accessibility/index"
import AuthPlugin from "@/lib/swagger/plugins/auth/index"
import ConfigsPlugin from "@/lib/swagger/plugins/configs/index"
import DeepLinkingPlugin from "@/lib/swagger/plugins/deep-linking/index"
import ErrPlugin from "@/lib/swagger/plugins/err/index"
import FilterPlugin from "@/lib/swagger/plugins/filter/index"
import IconsPlugin from "@/lib/swagger/plugins/icons/index"
import JSONSchema5Plugin from "@/lib/swagger/plugins/json-schema-5/index"
import JSONSchema202012Plugin from "@/lib/swagger/plugins/json-schema-2020-12/index"
import JSONSchema202012SamplesPlugin from "@/lib/swagger/plugins/json-schema-2020-12-samples/index"
import LayoutPlugin from "@/lib/swagger/plugins/layout/index"
import LogsPlugin from "@/lib/swagger/plugins/logs/index"
import OpenAPI30Plugin from "@/lib/swagger/plugins/oas3/index"
import OpenAPI31Plugin from "@/lib/swagger/plugins/oas3/index"
import OnCompletePlugin from "@/lib/swagger/plugins/on-complete/index"
import RequestSnippetsPlugin from "@/lib/swagger/plugins/request-snippets/index"
import JSONSchema5SamplesPlugin from "@/lib/swagger/plugins/json-schema-5-samples/index"
import SpecPlugin from "@/lib/swagger/plugins/spec/index"
import SwaggerClientPlugin from "@/lib/swagger/plugins/swagger-client/index"
import UtilPlugin from "@/lib/swagger/plugins/util/index"
import ViewPlugin from "@/lib/swagger/plugins/view/index"
import ViewLegacyPlugin from "@/lib/swagger/plugins/view-legacy/index"
import DownloadUrlPlugin from "@/lib/swagger/plugins/download-url/index"
import SyntaxHighlightingPlugin from "@/lib/swagger/plugins/syntax-highlighting/index"
import VersionsPlugin from "@/lib/swagger/plugins/versions/index"
import SafeRenderPlugin from "@/lib/swagger/plugins/safe-render/index"

import {
  defaultOptions,
  optionsFromQuery,
  optionsFromURL,
  optionsFromRuntime,
  mergeOptions,
  inlinePluginOptionsFactorization,
  systemOptionsFactorization,
  typeCastOptions,
  typeCastMappings,
} from "@/lib/swagger/config/index"

function SwaggerUI(userOptions) {
  const queryOptions = optionsFromQuery()(userOptions)
  const runtimeOptions = optionsFromRuntime()()
  const mergedOptions = SwaggerUI.config.merge(
    {},
    SwaggerUI.config.defaults,
    runtimeOptions,
    userOptions,
    queryOptions
  )
  const systemOptions = systemOptionsFactorization(mergedOptions)
  const InlinePlugin = inlinePluginOptionsFactorization(mergedOptions)

  const unboundSystem = new System(systemOptions)
  unboundSystem.register([mergedOptions.plugins, InlinePlugin])
  const system = unboundSystem.getSystem()

  const persistConfigs = (options) => {
    unboundSystem.setConfigs(options)
    system.configsActions.loaded()
  }
  const updateSpec = (options) => {
    if (
      !queryOptions.url &&
      typeof options.spec === "object" &&
      Object.keys(options.spec).length > 0
    ) {
      system.specActions.updateUrl("")
      system.specActions.updateLoadingStatus("success")
      system.specActions.updateSpec(JSON.stringify(options.spec))
    } else if (
      typeof system.specActions.download === "function" &&
      options.url &&
      !options.urls
    ) {
      system.specActions.updateUrl(options.url)
      system.specActions.download(options.url)
    }
  }
  const render = (options) => {
    if (options.domNode) {
      system.render(options.domNode, "App")
    } else if (options.dom_id) {
      const domNode = document.querySelector(options.dom_id)
      system.render(domNode, "App")
    } else if (options.dom_id === null || options.domNode === null) {
      /**
       * noop
       *
       * SwaggerUI instance can be created without any rendering involved.
       * This is also useful for lazy rendering or testing.
       */
    } else {
      console.error("Skipped rendering: no `dom_id` or `domNode` was specified")
    }
  }

  // if no configUrl is provided, we can safely persist the configs and render
  if (!mergedOptions.configUrl) {
    persistConfigs(mergedOptions)
    updateSpec(mergedOptions)
    render(mergedOptions)

    return system
  }

  // eslint-disable-next-line no-extra-semi
  ;(async () => {
    const { configUrl: url } = mergedOptions
    const urlOptions = await optionsFromURL({ url, system })(mergedOptions)
    const urlMergedOptions = SwaggerUI.config.merge(
      {},
      mergedOptions,
      urlOptions,
      queryOptions
    )

    persistConfigs(urlMergedOptions)
    if (urlOptions !== null) updateSpec(urlMergedOptions)
    render(urlMergedOptions)
  })()

  return system
}

SwaggerUI.System = System

SwaggerUI.config = {
  defaults: defaultOptions,
  merge: mergeOptions,
  typeCast: typeCastOptions,
  typeCastMappings,
}

SwaggerUI.presets = {
  base: BasePreset,
  apis: ApisPreset,
}

SwaggerUI.plugins = {
  Accessibility: AccessibilityPlugin,
  Auth: AuthPlugin,
  Configs: ConfigsPlugin,
  DeepLining: DeepLinkingPlugin,
  Err: ErrPlugin,
  Filter: FilterPlugin,
  Icons: IconsPlugin,
  JSONSchema5: JSONSchema5Plugin,
  JSONSchema5Samples: JSONSchema5SamplesPlugin,
  JSONSchema202012: JSONSchema202012Plugin,
  JSONSchema202012Samples: JSONSchema202012SamplesPlugin,
  Layout: LayoutPlugin,
  Logs: LogsPlugin,
  OpenAPI30: OpenAPI30Plugin,
  OpenAPI31: OpenAPI31Plugin,
  OnComplete: OnCompletePlugin,
  RequestSnippets: RequestSnippetsPlugin,
  Spec: SpecPlugin,
  SwaggerClient: SwaggerClientPlugin,
  Util: UtilPlugin,
  View: ViewPlugin,
  ViewLegacy: ViewLegacyPlugin,
  DownloadUrl: DownloadUrlPlugin,
  SyntaxHighlighting: SyntaxHighlightingPlugin,
  Versions: VersionsPlugin,
  SafeRender: SafeRenderPlugin,
}

export default SwaggerUI
