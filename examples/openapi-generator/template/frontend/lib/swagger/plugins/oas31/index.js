/**
 * @prettier
 */
import Webhooks from "@/components/swagger/oas31/webhooks"
import License from "@/components/swagger/oas31/license"
import Contact from "@/components/swagger/oas31/contact"
import Info from "@/components/swagger/oas31/info"
import JsonSchemaDialect from "@/components/swagger/oas31/json-schema-dialect"
import VersionPragmaFilter from "@/components/swagger/oas31/version-pragma-filter"
import Model from "@/components/swagger/oas31/model/model"
import Models from "@/components/swagger/oas31/models/models"
import MutualTLSAuth from "@/components/swagger/oas31/auth/mutual-tls-auth"
import Auths from "@/components/swagger/oas31/auth/auths"
import LicenseWrapper from "@/lib/swagger/plugins/oas31/wrap-components/license"
import ContactWrapper from "@/lib/swagger/plugins/oas31/wrap-components/contact"
import InfoWrapper from "@/lib/swagger/plugins/oas31/wrap-components/info"
import ModelWrapper from "@/lib/swagger/plugins/oas31/wrap-components/model"
import ModelsWrapper from "@/lib/swagger/plugins/oas31/wrap-components/models"
import VersionPragmaFilterWrapper from "@/lib/swagger/plugins/oas31/wrap-components/version-pragma-filter"
import AuthItemWrapper from "@/lib/swagger/plugins/oas31/wrap-components/auth/auth-item"
import AuthsWrapper from "@/lib/swagger/plugins/oas31/wrap-components/auths"
import {
  isOAS31 as isOAS31Fn,
  createOnlyOAS31Selector as createOnlyOAS31SelectorFn,
  createSystemSelector as createSystemSelectorFn,
} from "@/lib/swagger/plugins/oas31/fn"
import {
  license as selectLicense,
  contact as selectContact,
  webhooks as selectWebhooks,
  selectLicenseNameField,
  selectLicenseUrlField,
  selectLicenseIdentifierField,
  selectContactNameField,
  selectContactEmailField,
  selectContactUrlField,
  selectContactUrl,
  isOAS31 as selectIsOAS31,
  selectLicenseUrl,
  selectInfoTitleField,
  selectInfoSummaryField,
  selectInfoDescriptionField,
  selectInfoTermsOfServiceField,
  selectInfoTermsOfServiceUrl,
  selectExternalDocsDescriptionField,
  selectExternalDocsUrlField,
  selectExternalDocsUrl,
  selectWebhooksOperations,
  selectJsonSchemaDialectField,
  selectJsonSchemaDialectDefault,
  selectSchemas,
} from "@/lib/swagger/plugins/oas31/spec-extensions/selectors"
import {
  isOAS3 as isOAS3SelectorWrapper,
  selectLicenseUrl as selectLicenseUrlWrapper,
} from "@/lib/swagger/plugins/oas31/spec-extensions/wrap-selectors"
import { definitionsToAuthorize as definitionsToAuthorizeWrapper } from "@/lib/swagger/plugins/oas31/auth-extensions/wrap-selectors"
import { selectLicenseUrl as selectOAS31LicenseUrl } from "@/lib/swagger/plugins/oas31/selectors"
import JSONSchema202012KeywordExample from "@/lib/swagger/plugins/oas31/json-schema-2020-12-extensions/components/keywords/Example"
import JSONSchema202012KeywordXml from "@/lib/swagger/plugins/oas31/json-schema-2020-12-extensions/components/keywords/Xml"
import JSONSchema202012KeywordDiscriminator from "@/lib/swagger/plugins/oas31/json-schema-2020-12-extensions/components/keywords/Discriminator/Discriminator"
import OpenAPIExtensions from "@/lib/swagger/plugins/oas31/json-schema-2020-12-extensions/components/keywords/OpenAPIExtensions"
import JSONSchema202012KeywordExternalDocs from "@/lib/swagger/plugins/oas31/json-schema-2020-12-extensions/components/keywords/ExternalDocs"
import JSONSchema202012KeywordDescriptionWrapper from "@/lib/swagger/plugins/oas31/json-schema-2020-12-extensions/wrap-components/keywords/Description"
import JSONSchema202012KeywordExamplesWrapper from "@/lib/swagger/plugins/oas31/json-schema-2020-12-extensions/wrap-components/keywords/Examples"
import JSONSchema202012KeywordPropertiesWrapper from "@/lib/swagger/plugins/oas31/json-schema-2020-12-extensions/wrap-components/keywords/Properties"
import afterLoad from "@/lib/swagger/plugins/oas31/after-load"

const OAS31Plugin = ({ fn }) => {
  const createSystemSelector = fn.createSystemSelector || createSystemSelectorFn
  const createOnlyOAS31Selector = fn.createOnlyOAS31Selector || createOnlyOAS31SelectorFn // prettier-ignore

  return {
    afterLoad,
    fn: {
      isOAS31: isOAS31Fn,
      createSystemSelector: createSystemSelectorFn,
      createOnlyOAS31Selector: createOnlyOAS31SelectorFn,
    },
    components: {
      Webhooks,
      JsonSchemaDialect,
      MutualTLSAuth,
      OAS31Info: Info,
      OAS31License: License,
      OAS31Contact: Contact,
      OAS31VersionPragmaFilter: VersionPragmaFilter,
      OAS31Model: Model,
      OAS31Models: Models,
      OAS31Auths: Auths,
      JSONSchema202012KeywordExample,
      JSONSchema202012KeywordXml,
      JSONSchema202012KeywordDiscriminator,
      JSONSchema202012KeywordExternalDocs,
      OpenAPI31Extensions: OpenAPIExtensions,
    },
    wrapComponents: {
      InfoContainer: InfoWrapper,
      License: LicenseWrapper,
      Contact: ContactWrapper,
      VersionPragmaFilter: VersionPragmaFilterWrapper,
      Model: ModelWrapper,
      Models: ModelsWrapper,
      AuthItem: AuthItemWrapper,
      auths: AuthsWrapper,
      JSONSchema202012KeywordDescription:
        JSONSchema202012KeywordDescriptionWrapper,
      JSONSchema202012KeywordExamples: JSONSchema202012KeywordExamplesWrapper,
      JSONSchema202012KeywordProperties:
        JSONSchema202012KeywordPropertiesWrapper,
    },
    statePlugins: {
      auth: {
        wrapSelectors: {
          definitionsToAuthorize: definitionsToAuthorizeWrapper,
        },
      },
      spec: {
        selectors: {
          isOAS31: createSystemSelector(selectIsOAS31),

          license: selectLicense,
          selectLicenseNameField,
          selectLicenseUrlField,
          selectLicenseIdentifierField: createOnlyOAS31Selector(selectLicenseIdentifierField), // prettier-ignore
          selectLicenseUrl: createSystemSelector(selectLicenseUrl),

          contact: selectContact,
          selectContactNameField,
          selectContactEmailField,
          selectContactUrlField,
          selectContactUrl: createSystemSelector(selectContactUrl),

          selectInfoTitleField,
          selectInfoSummaryField: createOnlyOAS31Selector(selectInfoSummaryField), // prettier-ignore
          selectInfoDescriptionField,
          selectInfoTermsOfServiceField,
          selectInfoTermsOfServiceUrl: createSystemSelector(selectInfoTermsOfServiceUrl), // prettier-ignore

          selectExternalDocsDescriptionField,
          selectExternalDocsUrlField,
          selectExternalDocsUrl: createSystemSelector(selectExternalDocsUrl),

          webhooks: createOnlyOAS31Selector(selectWebhooks),
          selectWebhooksOperations: createOnlyOAS31Selector(createSystemSelector(selectWebhooksOperations)), // prettier-ignore

          selectJsonSchemaDialectField,
          selectJsonSchemaDialectDefault,

          selectSchemas: createSystemSelector(selectSchemas),
        },
        wrapSelectors: {
          isOAS3: isOAS3SelectorWrapper,
          selectLicenseUrl: selectLicenseUrlWrapper,
        },
      },
      oas31: {
        selectors: {
          selectLicenseUrl: createOnlyOAS31Selector(createSystemSelector(selectOAS31LicenseUrl)), // prettier-ignore
        },
      },
    },
  }
}

export default OAS31Plugin
