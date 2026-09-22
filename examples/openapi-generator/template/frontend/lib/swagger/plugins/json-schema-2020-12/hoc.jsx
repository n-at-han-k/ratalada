/**
 * @prettier
 */
import React from "react"

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
import { JSONSchemaContext } from "@/lib/swagger/plugins/json-schema-2020-12/context"
import { useFn } from "@/lib/swagger/plugins/json-schema-2020-12/hooks"
import {
  makeGetTitle,
  isBooleanJSONSchema,
  upperFirst,
  makeGetType,
  hasKeyword,
  makeIsExpandable,
  stringify,
  stringifyConstraints,
  getDependentRequired,
  getSchemaKeywords,
  makeGetExtensionKeywords,
} from "@/lib/swagger/plugins/json-schema-2020-12/fn"

export const withJSONSchemaContext = (Component, overrides = {}) => {
  const value = {
    components: {
      JSONSchema,
      Keyword$schema,
      Keyword$vocabulary,
      Keyword$id,
      Keyword$anchor,
      Keyword$dynamicAnchor,
      Keyword$ref,
      Keyword$dynamicRef,
      Keyword$defs,
      Keyword$comment,
      KeywordAllOf,
      KeywordAnyOf,
      KeywordOneOf,
      KeywordNot,
      KeywordIf,
      KeywordThen,
      KeywordElse,
      KeywordDependentSchemas,
      KeywordPrefixItems,
      KeywordItems,
      KeywordContains,
      KeywordProperties,
      KeywordPatternProperties,
      KeywordAdditionalProperties,
      KeywordPropertyNames,
      KeywordUnevaluatedItems,
      KeywordUnevaluatedProperties,
      KeywordType,
      KeywordEnum,
      KeywordConst,
      KeywordConstraint,
      KeywordDependentRequired,
      KeywordContentSchema,
      KeywordTitle,
      KeywordDescription,
      KeywordDefault,
      KeywordDeprecated,
      KeywordReadOnly,
      KeywordWriteOnly,
      KeywordExamples,
      ExtensionKeywords,
      JSONViewer,
      Accordion,
      ExpandDeepButton,
      ChevronRightIcon,
      ...overrides.components,
    },
    config: {
      default$schema: "https://json-schema.org/draft/2020-12/schema",
      /**
       * Defines an upper exclusive boundary of the level range for automatic expansion.
       *
       * 0 -> do nothing
       * 1 -> [0]...(1)
       * 2 -> [0]...(2)
       * 3 -> [0]...(3)
       */
      defaultExpandedLevels: 0, // 2 = 0...2
      showExtensionKeywords: true,
      ...overrides.config,
    },
    fn: {
      upperFirst,
      getTitle: makeGetTitle(useFn),
      getType: makeGetType(useFn),
      isBooleanJSONSchema,
      hasKeyword,
      isExpandable: makeIsExpandable(useFn),
      stringify,
      stringifyConstraints,
      getDependentRequired,
      getSchemaKeywords,
      getExtensionKeywords: makeGetExtensionKeywords(useFn),
      ...overrides.fn,
    },
    state: { paths: {} },
  }

  const HOC = (props) => (
    <JSONSchemaContext.Provider value={value}>
      <Component {...props} />
    </JSONSchemaContext.Provider>
  )
  HOC.contexts = {
    JSONSchemaContext,
  }
  HOC.displayName = Component.displayName

  return HOC
}

export const makeWithJSONSchemaSystemContext =
  ({ getSystem }) =>
  (Component, overrides = {}) => {
    const { getComponent, getConfigs } = getSystem()
    const configs = getConfigs()

    const JSONSchema = getComponent("JSONSchema202012")
    const Keyword$schema = getComponent("JSONSchema202012Keyword$schema")
    const Keyword$vocabulary = getComponent(
      "JSONSchema202012Keyword$vocabulary"
    )
    const Keyword$id = getComponent("JSONSchema202012Keyword$id")
    const Keyword$anchor = getComponent("JSONSchema202012Keyword$anchor")
    const Keyword$dynamicAnchor = getComponent(
      "JSONSchema202012Keyword$dynamicAnchor"
    )
    const Keyword$ref = getComponent("JSONSchema202012Keyword$ref")
    const Keyword$dynamicRef = getComponent(
      "JSONSchema202012Keyword$dynamicRef"
    )
    const Keyword$defs = getComponent("JSONSchema202012Keyword$defs")
    const Keyword$comment = getComponent("JSONSchema202012Keyword$comment")
    const KeywordAllOf = getComponent("JSONSchema202012KeywordAllOf")
    const KeywordAnyOf = getComponent("JSONSchema202012KeywordAnyOf")
    const KeywordOneOf = getComponent("JSONSchema202012KeywordOneOf")
    const KeywordNot = getComponent("JSONSchema202012KeywordNot")
    const KeywordIf = getComponent("JSONSchema202012KeywordIf")
    const KeywordThen = getComponent("JSONSchema202012KeywordThen")
    const KeywordElse = getComponent("JSONSchema202012KeywordElse")
    const KeywordDependentSchemas = getComponent(
      "JSONSchema202012KeywordDependentSchemas"
    )
    const KeywordPrefixItems = getComponent(
      "JSONSchema202012KeywordPrefixItems"
    )
    const KeywordItems = getComponent("JSONSchema202012KeywordItems")
    const KeywordContains = getComponent("JSONSchema202012KeywordContains")
    const KeywordProperties = getComponent("JSONSchema202012KeywordProperties")
    const KeywordPatternProperties = getComponent(
      "JSONSchema202012KeywordPatternProperties"
    )
    const KeywordAdditionalProperties = getComponent(
      "JSONSchema202012KeywordAdditionalProperties"
    )
    const KeywordPropertyNames = getComponent(
      "JSONSchema202012KeywordPropertyNames"
    )
    const KeywordUnevaluatedItems = getComponent(
      "JSONSchema202012KeywordUnevaluatedItems"
    )
    const KeywordUnevaluatedProperties = getComponent(
      "JSONSchema202012KeywordUnevaluatedProperties"
    )
    const KeywordType = getComponent("JSONSchema202012KeywordType")
    const KeywordEnum = getComponent("JSONSchema202012KeywordEnum")
    const KeywordConst = getComponent("JSONSchema202012KeywordConst")
    const KeywordConstraint = getComponent("JSONSchema202012KeywordConstraint")
    const KeywordDependentRequired = getComponent(
      "JSONSchema202012KeywordDependentRequired"
    )
    const KeywordContentSchema = getComponent(
      "JSONSchema202012KeywordContentSchema"
    )
    const KeywordTitle = getComponent("JSONSchema202012KeywordTitle")
    const KeywordDescription = getComponent(
      "JSONSchema202012KeywordDescription"
    )
    const KeywordDefault = getComponent("JSONSchema202012KeywordDefault")
    const KeywordDeprecated = getComponent("JSONSchema202012KeywordDeprecated")
    const KeywordReadOnly = getComponent("JSONSchema202012KeywordReadOnly")
    const KeywordWriteOnly = getComponent("JSONSchema202012KeywordWriteOnly")
    const KeywordExamples = getComponent("JSONSchema202012KeywordExamples")
    const ExtensionKeywords = getComponent("JSONSchema202012ExtensionKeywords")
    const JSONViewer = getComponent("JSONSchema202012JSONViewer")
    const Accordion = getComponent("JSONSchema202012Accordion")
    const ExpandDeepButton = getComponent("JSONSchema202012ExpandDeepButton")
    const ChevronRightIcon = getComponent("JSONSchema202012ChevronRightIcon")

    return withJSONSchemaContext(Component, {
      components: {
        JSONSchema,
        Keyword$schema,
        Keyword$vocabulary,
        Keyword$id,
        Keyword$anchor,
        Keyword$dynamicAnchor,
        Keyword$ref,
        Keyword$dynamicRef,
        Keyword$defs,
        Keyword$comment,
        KeywordAllOf,
        KeywordAnyOf,
        KeywordOneOf,
        KeywordNot,
        KeywordIf,
        KeywordThen,
        KeywordElse,
        KeywordDependentSchemas,
        KeywordPrefixItems,
        KeywordItems,
        KeywordContains,
        KeywordProperties,
        KeywordPatternProperties,
        KeywordAdditionalProperties,
        KeywordPropertyNames,
        KeywordUnevaluatedItems,
        KeywordUnevaluatedProperties,
        KeywordType,
        KeywordEnum,
        KeywordConst,
        KeywordConstraint,
        KeywordDependentRequired,
        KeywordContentSchema,
        KeywordTitle,
        KeywordDescription,
        KeywordDefault,
        KeywordDeprecated,
        KeywordReadOnly,
        KeywordWriteOnly,
        KeywordExamples,
        ExtensionKeywords,
        JSONViewer,
        Accordion,
        ExpandDeepButton,
        ChevronRightIcon,
        ...overrides.components,
      },
      config: {
        showExtensionKeywords: configs.showExtensions,
        ...overrides.config,
      },
      fn: {
        ...overrides.fn,
      },
    })
  }
