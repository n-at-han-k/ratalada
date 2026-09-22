/**
 * @prettier
 */
import React from "react"

import { schema } from "@/lib/swagger/plugins/json-schema-2020-12/prop-types"

const $schema = ({ schema }) => {
  if (!schema?.$schema) return null

  return (
    <div className="mx-0 mt-[5px] mb-[5px] json-schema-2020-12-keyword--$schema">
      <span className="json-schema-2020-12-keyword__name json-schema-2020-12-keyword__name--secondary">
        $schema
      </span>
      <span className="italic text-[#6b6b6b] text-[12px] font-normal json-schema-2020-12-keyword__value--secondary">
        {schema.$schema}
      </span>
    </div>
  )
}

$schema.propTypes = {
  schema: schema.isRequired,
}

export default $schema
