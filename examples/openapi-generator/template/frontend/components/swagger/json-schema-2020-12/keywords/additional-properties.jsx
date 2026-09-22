/**
 * @prettier
 */
import React from "react"

import { schema } from "@/lib/swagger/plugins/json-schema-2020-12/prop-types"
import { useFn, useComponent } from "@/lib/swagger/plugins/json-schema-2020-12/hooks"

const AdditionalProperties = ({ schema }) => {
  const fn = useFn()
  const JSONSchema = useComponent("JSONSchema")

  if (!fn.hasKeyword(schema, "additionalProperties")) return null

  /**
   * Rendering.
   */
  const name = (
    <span className="json-schema-2020-12-keyword__name json-schema-2020-12-keyword__name--primary">
      Additional properties
    </span>
  )

  return (
    <div className="mx-0 mt-[5px] mb-[5px] json-schema-2020-12-keyword--additionalProperties">
      {schema.additionalProperties === true ? (
        <>
          {name}
          <span className="lowercase font-[monospace] text-[#3b4151] text-[12px] pl-2.5 json-schema-2020-12__attribute--primary">
            allowed
          </span>
        </>
      ) : schema.additionalProperties === false ? (
        <>
          {name}
          <span className="lowercase font-[monospace] text-[#3b4151] text-[12px] pl-2.5 json-schema-2020-12__attribute--primary">
            forbidden
          </span>
        </>
      ) : (
        <JSONSchema
          name={name}
          schema={schema.additionalProperties}
          identifier="additionalProperties"
        />
      )}
    </div>
  )
}

AdditionalProperties.propTypes = {
  schema: schema.isRequired,
}

export default AdditionalProperties
