/**
 * @prettier
 */
import React from "react"
import PropTypes from "prop-types"

import { schema } from "@/lib/swagger/plugins/json-schema-2020-12/prop-types"
import { useFn } from "@/lib/swagger/plugins/json-schema-2020-12/hooks"

const Type = ({ schema, isCircular = false }) => {
  const fn = useFn()
  const type = fn.getType(schema)
  const circularSuffix = isCircular ? " [circular]" : ""

  return (
    <strong className="lowercase font-[monospace] text-[#3b4151] text-[12px] pl-2.5 json-schema-2020-12__attribute--primary">
      {`${type}${circularSuffix}`}
    </strong>
  )
}

Type.propTypes = {
  schema: schema.isRequired,
  isCircular: PropTypes.bool,
}

export default Type
