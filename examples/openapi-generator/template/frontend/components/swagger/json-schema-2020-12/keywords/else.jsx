/**
 * @prettier
 */
import React from "react"

import { schema } from "@/lib/swagger/plugins/json-schema-2020-12/prop-types"
import { useFn, useComponent } from "@/lib/swagger/plugins/json-schema-2020-12/hooks"

const Else = ({ schema }) => {
  const fn = useFn()
  const JSONSchema = useComponent("JSONSchema")

  /**
   * Rendering.
   */
  if (!fn.hasKeyword(schema, "else")) return null

  const name = (
    <span className="json-schema-2020-12-keyword__name json-schema-2020-12-keyword__name--primary">
      Else
    </span>
  )

  return (
    <div className="json-schema-2020-12-keyword json-schema-2020-12-keyword--if">
      <JSONSchema name={name} schema={schema.else} identifier="else" />
    </div>
  )
}

Else.propTypes = {
  schema: schema.isRequired,
}

export default Else
