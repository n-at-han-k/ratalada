/**
 * @prettier
 */
import AccessibilityPlugin from "@/lib/swagger/plugins/accessibility/index"
import AuthPlugin from "@/lib/swagger/plugins/auth/index"
import ConfigsPlugin from "@/lib/swagger/plugins/configs/index"
import DeepLinkingPlugin from "@/lib/swagger/plugins/deep-linking/index"
import ErrPlugin from "@/lib/swagger/plugins/err/index"
import FilterPlugin from "@/lib/swagger/plugins/filter/index"
import IconsPlugin from "@/lib/swagger/plugins/icons/index"
import LayoutPlugin from "@/lib/swagger/plugins/layout/index"
import LogsPlugin from "@/lib/swagger/plugins/logs/index"
import OnCompletePlugin from "@/lib/swagger/plugins/on-complete/index"
import RequestSnippetsPlugin from "@/lib/swagger/plugins/request-snippets/index"
import JSONSchema5Plugin from "@/lib/swagger/plugins/json-schema-5/index"
import JSONSchema5SamplesPlugin from "@/lib/swagger/plugins/json-schema-5-samples/index"
import SpecPlugin from "@/lib/swagger/plugins/spec/index"
import SwaggerClientPlugin from "@/lib/swagger/plugins/swagger-client/index"
import UtilPlugin from "@/lib/swagger/plugins/util/index"
import ViewPlugin from "@/lib/swagger/plugins/view/index"
import DownloadUrlPlugin from "@/lib/swagger/plugins/download-url/index"
import SyntaxHighlightingPlugin from "@/lib/swagger/plugins/syntax-highlighting/index"
import VersionsPlugin from "@/lib/swagger/plugins/versions/index"
import SafeRenderPlugin from "@/lib/swagger/plugins/safe-render/index"
// ad-hoc plugins
import CoreComponentsPlugin from "@/lib/swagger/presets/base/plugins/core-components/index"
import FormComponentsPlugin from "@/lib/swagger/presets/base/plugins/form-components/index"

const BasePreset = () => [
  AccessibilityPlugin,
  ConfigsPlugin,
  UtilPlugin,
  LogsPlugin,
  ViewPlugin,
  SpecPlugin,
  ErrPlugin,
  IconsPlugin,
  LayoutPlugin,
  JSONSchema5Plugin,
  JSONSchema5SamplesPlugin,
  CoreComponentsPlugin,
  FormComponentsPlugin,
  SwaggerClientPlugin,
  AuthPlugin,
  DownloadUrlPlugin,
  DeepLinkingPlugin,
  FilterPlugin,
  OnCompletePlugin,
  RequestSnippetsPlugin,
  SyntaxHighlightingPlugin,
  VersionsPlugin,
  SafeRenderPlugin(),
]

export default BasePreset
