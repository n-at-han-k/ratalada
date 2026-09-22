/**
 * @prettier
 */
import App from "@/components/swagger/app"
import AuthorizationPopup from "@/components/swagger/auth/authorization-popup"
import AuthorizeBtn from "@/components/swagger/auth/authorize-btn"
import AuthorizeBtnContainer from "@/components/swagger/containers/authorize-btn"
import AuthorizeOperationBtn from "@/components/swagger/auth/authorize-operation-btn"
import Auths from "@/components/swagger/auth/auths"
import AuthItem from "@/components/swagger/auth/auth-item"
import AuthError from "@/components/swagger/auth/error"
import ApiKeyAuth from "@/components/swagger/auth/api-key-auth"
import BasicAuth from "@/components/swagger/auth/basic-auth"
import Example from "@/components/swagger/example"
import ExamplesSelect from "@/components/swagger/examples-select"
import ExamplesSelectValueRetainer from "@/components/swagger/examples-select-value-retainer"
import Oauth2 from "@/components/swagger/auth/oauth2"
import Clear from "@/components/swagger/clear"
import LiveResponse from "@/components/swagger/live-response"
import OnlineValidatorBadge from "@/components/swagger/online-validator-badge"
import Operations from "@/components/swagger/operations"
import OperationTag from "@/components/swagger/operation-tag"
import Operation from "@/components/swagger/operation"
import OperationContainer from "@/components/swagger/containers/operation-container"
import OperationSummary from "@/components/swagger/operation-summary"
import OperationSummaryMethod from "@/components/swagger/operation-summary-method"
import OperationSummaryPath from "@/components/swagger/operation-summary-path"
import OperationExt from "@/components/swagger/operation-extensions"
import OperationExtRow from "@/components/swagger/operation-extension-row"
import Responses from "@/components/swagger/responses"
import Response from "@/components/swagger/response"
import ResponseExtension from "@/components/swagger/response-extension"
import ResponseBody from "@/components/swagger/response-body"
import { Parameters } from "@/components/swagger/parameters/index"
import ParameterExt from "@/components/swagger/parameter-extension"
import ParameterIncludeEmpty from "@/components/swagger/parameter-include-empty"
import ParameterRow from "@/components/swagger/parameter-row"
import Execute from "@/components/swagger/execute"
import Headers from "@/components/swagger/headers"
import Errors from "@/components/swagger/errors"
import ContentType from "@/components/swagger/content-type"
import Overview from "@/components/swagger/overview"
import InitializedInput from "@/components/swagger/initialized-input"
import Info, { InfoUrl, InfoBasePath } from "@/components/swagger/info"
import InfoContainer from "@/components/swagger/containers/info"
import Contact from "@/components/swagger/contact"
import License from "@/components/swagger/license"
import JumpToPath from "@/components/swagger/jump-to-path"
import CopyToClipboardBtn from "@/components/swagger/copy-to-clipboard-btn"
import Footer from "@/components/swagger/footer"
import FilterContainer from "@/components/swagger/containers/filter"
import ParamBody from "@/components/swagger/param-body"
import Curl from "@/components/swagger/curl"
import Property from "@/components/swagger/property"
import TryItOutButton from "@/components/swagger/try-it-out-button"
import VersionPragmaFilter from "@/components/swagger/version-pragma-filter"
import VersionStamp from "@/components/swagger/version-stamp"
import OpenAPIVersion from "@/components/swagger/openapi-version"
import DeepLink from "@/components/swagger/deep-link"
import SvgAssets from "@/components/swagger/svg-assets"
import Markdown from "@/components/swagger/providers/markdown"
import BaseLayout from "@/components/swagger/layouts/base"

const CoreComponentsPlugin = () => ({
  components: {
    App,
    authorizationPopup: AuthorizationPopup,
    authorizeBtn: AuthorizeBtn,
    AuthorizeBtnContainer,
    authorizeOperationBtn: AuthorizeOperationBtn,
    auths: Auths,
    AuthItem: AuthItem,
    authError: AuthError,
    oauth2: Oauth2,
    apiKeyAuth: ApiKeyAuth,
    basicAuth: BasicAuth,
    clear: Clear,
    liveResponse: LiveResponse,
    InitializedInput,
    info: Info,
    InfoContainer,
    InfoUrl,
    InfoBasePath,
    Contact,
    License,
    JumpToPath,
    CopyToClipboardBtn,
    onlineValidatorBadge: OnlineValidatorBadge,
    operations: Operations,
    operation: Operation,
    OperationSummary,
    OperationSummaryMethod,
    OperationSummaryPath,
    responses: Responses,
    response: Response,
    ResponseExtension: ResponseExtension,
    responseBody: ResponseBody,
    parameters: Parameters,
    parameterRow: ParameterRow,
    execute: Execute,
    headers: Headers,
    errors: Errors,
    contentType: ContentType,
    overview: Overview,
    footer: Footer,
    FilterContainer,
    ParamBody: ParamBody,
    curl: Curl,
    Property,
    TryItOutButton,
    Markdown,
    BaseLayout,
    VersionPragmaFilter,
    VersionStamp,
    OperationExt,
    OperationExtRow,
    ParameterExt,
    ParameterIncludeEmpty,
    OperationTag,
    OperationContainer,
    OpenAPIVersion,
    DeepLink,
    SvgAssets,
    Example,
    ExamplesSelect,
    ExamplesSelectValueRetainer,
  },
})

export default CoreComponentsPlugin
