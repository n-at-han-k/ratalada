/**
 * @prettier
 */
import JSONSchema from "@/components/swagger/json-schema-2020-12/JSONSchema/json-schema"
import Keyword$schema from "@/components/swagger/json-schema-2020-12/keywords/$schema"
import Keyword$vocabulary from "@/components/swagger/json-schema-2020-12/keywords/$vocabulary/$vocabulary"
import Keyword$id from "@/components/swagger/json-schema-2020-12/keywords/$id"
import Keyword$anchor from "@/components/swagger/json-schema-2020-12/keywords/$anchor"
import Keyword$dynamicAnchor from "@/components/swagger/json-schema-2020-12/keywords/$dynamic-anchor"
import Keyword$ref from "@/components/swagger/json-schema-2020-12/keywords/$ref"
import Keyword$dynamicRef from "@/components/swagger/json-schema-2020-12/keywords/$dynamic-ref"
import Keyword$defs from "@/components/swagger/json-schema-2020-12/keywords/$defs"
import Keyword$comment from "@/components/swagger/json-schema-2020-12/keywords/$comment"
import KeywordAllOf from "@/components/swagger/json-schema-2020-12/keywords/all-of"
import KeywordAnyOf from "@/components/swagger/json-schema-2020-12/keywords/any-of"
import KeywordOneOf from "@/components/swagger/json-schema-2020-12/keywords/one-of"
import KeywordNot from "@/components/swagger/json-schema-2020-12/keywords/not"
import KeywordIf from "@/components/swagger/json-schema-2020-12/keywords/if"
import KeywordThen from "@/components/swagger/json-schema-2020-12/keywords/then"
import KeywordElse from "@/components/swagger/json-schema-2020-12/keywords/else"
import KeywordDependentSchemas from "@/components/swagger/json-schema-2020-12/keywords/dependent-schemas"
import KeywordPrefixItems from "@/components/swagger/json-schema-2020-12/keywords/prefix-items"
import KeywordItems from "@/components/swagger/json-schema-2020-12/keywords/items"
import KeywordContains from "@/components/swagger/json-schema-2020-12/keywords/contains"
import KeywordProperties from "@/components/swagger/json-schema-2020-12/keywords/Properties/properties"
import KeywordPatternProperties from "@/components/swagger/json-schema-2020-12/keywords/PatternProperties/pattern-properties"
import KeywordAdditionalProperties from "@/components/swagger/json-schema-2020-12/keywords/additional-properties"
import KeywordPropertyNames from "@/components/swagger/json-schema-2020-12/keywords/property-names"
import KeywordUnevaluatedItems from "@/components/swagger/json-schema-2020-12/keywords/unevaluated-items"
import KeywordUnevaluatedProperties from "@/components/swagger/json-schema-2020-12/keywords/unevaluated-properties"
import KeywordType from "@/components/swagger/json-schema-2020-12/keywords/type"
import KeywordEnum from "@/components/swagger/json-schema-2020-12/keywords/Enum/enum"
import KeywordConst from "@/components/swagger/json-schema-2020-12/keywords/Const/const"
import KeywordConstraint from "@/components/swagger/json-schema-2020-12/keywords/Constraint/constraint"
import KeywordDependentRequired from "@/components/swagger/json-schema-2020-12/keywords/DependentRequired/dependent-required"
import KeywordContentSchema from "@/components/swagger/json-schema-2020-12/keywords/content-schema"
import KeywordTitle from "@/components/swagger/json-schema-2020-12/keywords/Title/title"
import KeywordDescription from "@/components/swagger/json-schema-2020-12/keywords/Description/description"
import KeywordDefault from "@/components/swagger/json-schema-2020-12/keywords/Default/default"
import KeywordDeprecated from "@/components/swagger/json-schema-2020-12/keywords/deprecated"
import KeywordReadOnly from "@/components/swagger/json-schema-2020-12/keywords/read-only"
import KeywordWriteOnly from "@/components/swagger/json-schema-2020-12/keywords/write-only"
import KeywordExamples from "@/components/swagger/json-schema-2020-12/keywords/Examples/examples"
import ExtensionKeywords from "@/components/swagger/json-schema-2020-12/keywords/ExtensionKeywords/extension-keywords"
import JSONViewer from "@/components/swagger/json-schema-2020-12/JSONViewer/json-viewer"
import Accordion from "@/components/swagger/json-schema-2020-12/Accordion/accordion"
import ExpandDeepButton from "@/components/swagger/json-schema-2020-12/ExpandDeepButton/expand-deep-button"
import ChevronRightIcon from "@/components/swagger/json-schema-2020-12/icons/chevron-right"
import {
  upperFirst,
  hasKeyword,
  makeGetTitle,
  makeGetType,
  makeIsExpandable,
  isBooleanJSONSchema,
  getSchemaKeywords,
  makeGetExtensionKeywords,
  hasSchemaType,
} from "@/lib/swagger/plugins/json-schema-2020-12/fn"
import { JSONSchemaPathContext, JSONSchemaLevelContext } from "@/lib/swagger/plugins/json-schema-2020-12/context"
import {
  useFn,
  useConfig,
  useComponent,
  useIsExpanded,
  usePath,
  useLevel,
} from "@/lib/swagger/plugins/json-schema-2020-12/hooks"
import { withJSONSchemaContext, makeWithJSONSchemaSystemContext } from "@/lib/swagger/plugins/json-schema-2020-12/hoc"

const JSONSchema202012Plugin = ({ getSystem, fn }) => {
  const fnAccessor = () => ({
    upperFirst: fn.upperFirst,
    ...fn.jsonSchema202012,
  })

  return {
    components: {
      JSONSchema202012: JSONSchema,
      JSONSchema202012Keyword$schema: Keyword$schema,
      JSONSchema202012Keyword$vocabulary: Keyword$vocabulary,
      JSONSchema202012Keyword$id: Keyword$id,
      JSONSchema202012Keyword$anchor: Keyword$anchor,
      JSONSchema202012Keyword$dynamicAnchor: Keyword$dynamicAnchor,
      JSONSchema202012Keyword$ref: Keyword$ref,
      JSONSchema202012Keyword$dynamicRef: Keyword$dynamicRef,
      JSONSchema202012Keyword$defs: Keyword$defs,
      JSONSchema202012Keyword$comment: Keyword$comment,
      JSONSchema202012KeywordAllOf: KeywordAllOf,
      JSONSchema202012KeywordAnyOf: KeywordAnyOf,
      JSONSchema202012KeywordOneOf: KeywordOneOf,
      JSONSchema202012KeywordNot: KeywordNot,
      JSONSchema202012KeywordIf: KeywordIf,
      JSONSchema202012KeywordThen: KeywordThen,
      JSONSchema202012KeywordElse: KeywordElse,
      JSONSchema202012KeywordDependentSchemas: KeywordDependentSchemas,
      JSONSchema202012KeywordPrefixItems: KeywordPrefixItems,
      JSONSchema202012KeywordItems: KeywordItems,
      JSONSchema202012KeywordContains: KeywordContains,
      JSONSchema202012KeywordProperties: KeywordProperties,
      JSONSchema202012KeywordPatternProperties: KeywordPatternProperties,
      JSONSchema202012KeywordAdditionalProperties: KeywordAdditionalProperties,
      JSONSchema202012KeywordPropertyNames: KeywordPropertyNames,
      JSONSchema202012KeywordUnevaluatedItems: KeywordUnevaluatedItems,
      JSONSchema202012KeywordUnevaluatedProperties:
        KeywordUnevaluatedProperties,
      JSONSchema202012KeywordType: KeywordType,
      JSONSchema202012KeywordEnum: KeywordEnum,
      JSONSchema202012KeywordConst: KeywordConst,
      JSONSchema202012KeywordConstraint: KeywordConstraint,
      JSONSchema202012KeywordDependentRequired: KeywordDependentRequired,
      JSONSchema202012KeywordContentSchema: KeywordContentSchema,
      JSONSchema202012KeywordTitle: KeywordTitle,
      JSONSchema202012KeywordDescription: KeywordDescription,
      JSONSchema202012KeywordDefault: KeywordDefault,
      JSONSchema202012KeywordDeprecated: KeywordDeprecated,
      JSONSchema202012KeywordReadOnly: KeywordReadOnly,
      JSONSchema202012KeywordWriteOnly: KeywordWriteOnly,
      JSONSchema202012KeywordExamples: KeywordExamples,
      JSONSchema202012ExtensionKeywords: ExtensionKeywords,
      JSONSchema202012JSONViewer: JSONViewer,
      JSONSchema202012Accordion: Accordion,
      JSONSchema202012ExpandDeepButton: ExpandDeepButton,
      JSONSchema202012ChevronRightIcon: ChevronRightIcon,
      withJSONSchema202012Context: withJSONSchemaContext,
      withJSONSchema202012SystemContext:
        makeWithJSONSchemaSystemContext(getSystem()),
      JSONSchema202012PathContext: () => JSONSchemaPathContext,
      JSONSchema202012LevelContext: () => JSONSchemaLevelContext,
    },
    fn: {
      upperFirst,
      jsonSchema202012: {
        getTitle: makeGetTitle(fnAccessor),
        getType: makeGetType(fnAccessor),
        isExpandable: makeIsExpandable(fnAccessor),
        isBooleanJSONSchema,
        hasKeyword,
        useFn,
        useConfig,
        useComponent,
        useIsExpanded,
        usePath,
        useLevel,
        getSchemaKeywords,
        getExtensionKeywords: makeGetExtensionKeywords(fnAccessor),
        hasSchemaType,
      },
    },
  }
}

export default JSONSchema202012Plugin
