/**
 * @prettier
 */
import ModelCollapse from "@/components/swagger/json-schema-5/model-collapse"
import ModelExample from "@/components/swagger/json-schema-5/model-example"
import ModelWrapper from "@/components/swagger/json-schema-5/model-wrapper"
import Model from "@/components/swagger/json-schema-5/model"
import Models from "@/components/swagger/json-schema-5/models"
import EnumModel from "@/components/swagger/json-schema-5/enum-model"
import ObjectModel from "@/components/swagger/json-schema-5/object-model"
import ArrayModel from "@/components/swagger/json-schema-5/array-model"
import PrimitiveModel from "@/components/swagger/json-schema-5/primitive-model"
import Schemes from "@/components/swagger/json-schema-5/schemes"
import SchemesContainer from "@/lib/swagger/plugins/json-schema-5/containers/schemes"
import * as JSONSchemaComponents from "@/components/swagger/json-schema-5/json-schema-components"
import { ModelExtensions } from "@/components/swagger/json-schema-5/model-extensions"
import { getSchemaObjectTypeLabel, hasSchemaType } from "@/lib/swagger/plugins/json-schema-5/fn"

const JSONSchema5Plugin = () => ({
  components: {
    modelExample: ModelExample,
    ModelWrapper,
    ModelCollapse,
    Model,
    Models,
    EnumModel,
    ObjectModel,
    ArrayModel,
    PrimitiveModel,
    ModelExtensions,
    schemes: Schemes,
    SchemesContainer,
    ...JSONSchemaComponents,
  },
  fn: {
    hasSchemaType,
    getSchemaObjectTypeLabel,
  },
})

export default JSONSchema5Plugin
