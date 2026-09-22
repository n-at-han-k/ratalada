/**
 * @prettier
 */
import arrayTypeCaster from "@/lib/swagger/config/type-cast/type-casters/array"
import booleanTypeCaster from "@/lib/swagger/config/type-cast/type-casters/boolean"
import domNodeTypeCaster from "@/lib/swagger/config/type-cast/type-casters/dom-node"
import filterTypeCaster from "@/lib/swagger/config/type-cast/type-casters/filter"
import functionTypeCaster from "@/lib/swagger/config/type-cast/type-casters/function"
import nullableArrayTypeCaster from "@/lib/swagger/config/type-cast/type-casters/nullable-array"
import nullableFunctionTypeCaster from "@/lib/swagger/config/type-cast/type-casters/nullable-function"
import nullableStringTypeCaster from "@/lib/swagger/config/type-cast/type-casters/nullable-string"
import numberTypeCaster from "@/lib/swagger/config/type-cast/type-casters/number"
import objectTypeCaster from "@/lib/swagger/config/type-cast/type-casters/object"
import sorterTypeCaster from "@/lib/swagger/config/type-cast/type-casters/sorter"
import stringTypeCaster from "@/lib/swagger/config/type-cast/type-casters/string"
import syntaxHighlightTypeCaster from "@/lib/swagger/config/type-cast/type-casters/syntax-highlight"
import undefinedStringTypeCaster from "@/lib/swagger/config/type-cast/type-casters/undefined-string"
import defaultOptions from "@/lib/swagger/config/defaults"

const mappings = {
  components: { typeCaster: objectTypeCaster },
  configs: { typeCaster: objectTypeCaster },
  configUrl: { typeCaster: nullableStringTypeCaster },
  deepLinking: {
    typeCaster: booleanTypeCaster,
    defaultValue: defaultOptions.deepLinking,
  },
  defaultModelExpandDepth: {
    typeCaster: numberTypeCaster,
    defaultValue: defaultOptions.defaultModelExpandDepth,
  },
  defaultModelRendering: { typeCaster: stringTypeCaster },
  defaultModelsExpandDepth: {
    typeCaster: numberTypeCaster,
    defaultValue: defaultOptions.defaultModelsExpandDepth,
  },
  displayOperationId: {
    typeCaster: booleanTypeCaster,
    defaultValue: defaultOptions.displayOperationId,
  },
  displayRequestDuration: {
    typeCaster: booleanTypeCaster,
    defaultValue: defaultOptions.displayRequestDuration,
  },
  docExpansion: { typeCaster: stringTypeCaster },
  dom_id: { typeCaster: nullableStringTypeCaster },
  domNode: { typeCaster: domNodeTypeCaster },
  fileUploadMediaTypes: {
    typeCaster: arrayTypeCaster,
    defaultValue: defaultOptions.fileUploadMediaTypes,
  },
  filter: { typeCaster: filterTypeCaster },
  fn: { typeCaster: objectTypeCaster },
  initialState: { typeCaster: objectTypeCaster },
  layout: { typeCaster: stringTypeCaster },
  maxDisplayedTags: {
    typeCaster: numberTypeCaster,
    defaultValue: defaultOptions.maxDisplayedTags,
  },
  modelPropertyMacro: { typeCaster: nullableFunctionTypeCaster },
  oauth2RedirectUrl: { typeCaster: undefinedStringTypeCaster },
  onComplete: { typeCaster: nullableFunctionTypeCaster },
  operationsSorter: {
    typeCaster: sorterTypeCaster,
  },
  paramaterMacro: { typeCaster: nullableFunctionTypeCaster },
  persistAuthorization: {
    typeCaster: booleanTypeCaster,
    defaultValue: defaultOptions.persistAuthorization,
  },
  plugins: {
    typeCaster: arrayTypeCaster,
    defaultValue: defaultOptions.plugins,
  },
  presets: {
    typeCaster: arrayTypeCaster,
    defaultValue: defaultOptions.presets,
  },
  requestInterceptor: {
    typeCaster: functionTypeCaster,
    defaultValue: defaultOptions.requestInterceptor,
  },
  requestSnippets: {
    typeCaster: objectTypeCaster,
    defaultValue: defaultOptions.requestSnippets,
  },
  requestSnippetsEnabled: {
    typeCaster: booleanTypeCaster,
    defaultValue: defaultOptions.requestSnippetsEnabled,
  },
  responseInterceptor: {
    typeCaster: functionTypeCaster,
    defaultValue: defaultOptions.responseInterceptor,
  },
  showCommonExtensions: {
    typeCaster: booleanTypeCaster,
    defaultValue: defaultOptions.showCommonExtensions,
  },
  showExtensions: {
    typeCaster: booleanTypeCaster,
    defaultValue: defaultOptions.showExtensions,
  },
  showMutatedRequest: {
    typeCaster: booleanTypeCaster,
    defaultValue: defaultOptions.showMutatedRequest,
  },
  spec: { typeCaster: objectTypeCaster, defaultValue: defaultOptions.spec },
  supportedSubmitMethods: {
    typeCaster: arrayTypeCaster,
    defaultValue: defaultOptions.supportedSubmitMethods,
  },
  syntaxHighlight: {
    typeCaster: syntaxHighlightTypeCaster,
    defaultValue: defaultOptions.syntaxHighlight,
  },
  "syntaxHighlight.activated": {
    typeCaster: booleanTypeCaster,
    defaultValue: defaultOptions.syntaxHighlight.activated,
  },
  "syntaxHighlight.theme": { typeCaster: stringTypeCaster },
  tagsSorter: {
    typeCaster: sorterTypeCaster,
  },
  tryItOutEnabled: {
    typeCaster: booleanTypeCaster,
    defaultValue: defaultOptions.tryItOutEnabled,
  },
  url: { typeCaster: stringTypeCaster },
  urls: { typeCaster: nullableArrayTypeCaster },
  "urls.primaryName": { typeCaster: stringTypeCaster },
  validatorUrl: { typeCaster: nullableStringTypeCaster },
  withCredentials: {
    typeCaster: booleanTypeCaster,
    defaultValue: defaultOptions.withCredentials,
  },
  uncaughtExceptionHandler: { typeCaster: nullableFunctionTypeCaster },
}

export default mappings
