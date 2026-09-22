/**
 * @prettier
 */
import React from "react"

import { schema } from "@/lib/swagger/plugins/json-schema-2020-12/prop-types"

const WriteOnly = ({ schema }) => {
  if (schema?.writeOnly !== true) return null

  return (
    <span className="lowercase font-[monospace] text-[#3b4151] text-[12px] pl-2.5 json-schema-2020-12__attribute--muted">
      write-only
    </span>
  )
}

WriteOnly.propTypes = {
  schema: schema.isRequired,
}

export default WriteOnly
