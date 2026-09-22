/**
 * @prettier
 */
import React from "react"

import { schema } from "@/lib/swagger/plugins/json-schema-2020-12/prop-types"
import { useComponent } from "@/lib/swagger/plugins/json-schema-2020-12/hooks"

const Examples = ({ schema }) => {
  const examples = schema?.examples || []
  const JSONViewer = useComponent("JSONViewer")

  if (!Array.isArray(examples) || examples.length === 0) {
    return null
  }

  return (
    <JSONViewer
      name="Examples"
      value={schema.examples}
      className="mx-0 mt-[5px] mb-[5px] json-schema-2020-12-keyword--examples"
    />
  )
}

Examples.propTypes = {
  schema: schema.isRequired,
}

export default Examples
