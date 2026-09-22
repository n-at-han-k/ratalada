/**
 * @prettier
 */
import React from "react"

import { schema } from "@/lib/swagger/plugins/json-schema-2020-12/prop-types"
import { useFn, useComponent } from "@/lib/swagger/plugins/json-schema-2020-12/hooks"

const UnevaluatedProperties = ({ schema }) => {
  const fn = useFn()
  const JSONSchema = useComponent("JSONSchema")

  /**
   * Rendering.
   */
  if (!fn.hasKeyword(schema, "unevaluatedProperties")) return null

  const name = (
    <span className="json-schema-2020-12-keyword__name json-schema-2020-12-keyword__name--primary">
      Unevaluated properties
    </span>
  )

  return (
    <div className="mx-0 mt-[5px] mb-[5px] json-schema-2020-12-keyword--unevaluatedProperties">
      <JSONSchema
        name={name}
        schema={schema.unevaluatedProperties}
        identifier="unevaluatedProperties"
      />
    </div>
  )
}

UnevaluatedProperties.propTypes = {
  schema: schema.isRequired,
}

export default UnevaluatedProperties
