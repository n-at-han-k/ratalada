/**
 * @prettier
 */
import React from "react"

import { schema } from "@/lib/swagger/plugins/json-schema-2020-12/prop-types"

const $ref = ({ schema }) => {
  if (!schema?.$ref) return null

  return (
    <div className="mx-0 mt-[5px] mb-[5px] json-schema-2020-12-keyword--$ref">
      <span className="json-schema-2020-12-keyword__name json-schema-2020-12-keyword__name--secondary">
        $ref
      </span>
      <span className="italic text-[#6b6b6b] text-[12px] font-normal json-schema-2020-12-keyword__value--secondary">
        {schema.$ref}
      </span>
    </div>
  )
}

$ref.propTypes = {
  schema: schema.isRequired,
}

export default $ref
