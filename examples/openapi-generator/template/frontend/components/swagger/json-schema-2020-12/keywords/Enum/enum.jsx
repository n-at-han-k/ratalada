/**
 * @prettier
 */
import React from "react"

import { schema } from "@/lib/swagger/plugins/json-schema-2020-12/prop-types"
import { useComponent } from "@/lib/swagger/plugins/json-schema-2020-12/hooks"

const Enum = ({ schema }) => {
  const JSONViewer = useComponent("JSONViewer")

  if (!Array.isArray(schema?.enum)) return null

  return (
    <JSONViewer
      name="Enum"
      value={schema.enum}
      className="mx-0 mt-[5px] mb-[5px] json-schema-2020-12-keyword--enum"
    />
  )
}

Enum.propTypes = {
  schema: schema.isRequired,
}

export default Enum
