/**
 * @prettier
 */
import {
  sampleFromSchema,
  sampleFromSchemaGeneric,
  createXMLExample,
  memoizedSampleFromSchema,
  memoizedCreateXMLExample,
} from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/main"
import optionAPI from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/api/optionAPI"
import encoderAPI from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/api/encoderAPI"
import mediaTypeAPI from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/api/mediaTypeAPI"
import formatAPI from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/api/formatAPI"
import mergeJsonSchema from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/core/merge"
import { foldType } from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/core/type"
import makeGetJsonSampleSchema from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/get-json-sample-schema"
import makeGetYamlSampleSchema from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/get-yaml-sample-schema"
import makeGetXmlSampleSchema from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/get-xml-sample-schema"
import makeGetSampleSchema from "@/lib/swagger/plugins/json-schema-2020-12-samples/fn/get-sample-schema"

const JSONSchema202012SamplesPlugin = ({ getSystem }) => {
  const getJsonSampleSchema = makeGetJsonSampleSchema(getSystem)
  const getYamlSampleSchema = makeGetYamlSampleSchema(getSystem)
  const getXmlSampleSchema = makeGetXmlSampleSchema(getSystem)
  const getSampleSchema = makeGetSampleSchema(getSystem)

  return {
    fn: {
      jsonSchema202012: {
        sampleFromSchema,
        sampleFromSchemaGeneric,
        sampleOptionAPI: optionAPI,
        sampleEncoderAPI: encoderAPI,
        sampleFormatAPI: formatAPI,
        sampleMediaTypeAPI: mediaTypeAPI,
        createXMLExample,
        memoizedSampleFromSchema,
        memoizedCreateXMLExample,
        getJsonSampleSchema,
        getYamlSampleSchema,
        getXmlSampleSchema,
        getSampleSchema,
        mergeJsonSchema,
        foldType,
      },
    },
  }
}

export default JSONSchema202012SamplesPlugin
