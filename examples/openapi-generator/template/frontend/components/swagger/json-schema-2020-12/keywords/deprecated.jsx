/**
 * @prettier
 */
import React from "react"

import { schema } from "@/lib/swagger/plugins/json-schema-2020-12/prop-types"

const Deprecated = ({ schema }) => {
  if (schema?.deprecated !== true) return null

  return (
    <span className="lowercase font-[monospace] text-[#3b4151] text-[12px] pl-2.5 json-schema-2020-12__attribute--warning">
      deprecated
    </span>
  )
}

Deprecated.propTypes = {
  schema: schema.isRequired,
}

export default Deprecated
