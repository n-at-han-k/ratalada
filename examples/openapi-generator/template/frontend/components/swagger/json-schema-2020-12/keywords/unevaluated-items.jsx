/**
 * @prettier
 */
import React from "react"

import { schema } from "@/lib/swagger/plugins/json-schema-2020-12/prop-types"
import { useFn, useComponent } from "@/lib/swagger/plugins/json-schema-2020-12/hooks"

const UnevaluatedItems = ({ schema }) => {
  const fn = useFn()
  const JSONSchema = useComponent("JSONSchema")

  /**
   * Rendering.
   */
  if (!fn.hasKeyword(schema, "unevaluatedItems")) return null

  const name = (
    <span className="json-schema-2020-12-keyword__name json-schema-2020-12-keyword__name--primary">
      Unevaluated items
    </span>
  )

  return (
    <div className="mx-0 mt-[5px] mb-[5px] json-schema-2020-12-keyword--unevaluatedItems">
      <JSONSchema
        name={name}
        schema={schema.unevaluatedItems}
        identifier="unevaluatedItems"
      />
    </div>
  )
}

UnevaluatedItems.propTypes = {
  schema: schema.isRequired,
}

export default UnevaluatedItems
