/**
 * @prettier
 */
import React from "react"
import PropTypes from "prop-types"

import * as propTypes from "@/lib/swagger/plugins/json-schema-2020-12/prop-types"

const DependentRequired = ({ dependentRequired }) => {
  if (!Array.isArray(dependentRequired) || dependentRequired.length === 0) {
    return null
  }

  return (
    <div className="mx-0 mt-[5px] mb-[5px] json-schema-2020-12-keyword--dependentRequired">
      <span className="json-schema-2020-12-keyword__name json-schema-2020-12-keyword__name--primary">
        Required when defined
      </span>
      <ul>
        {dependentRequired.map((propertyName) => (
          <li key={propertyName}>
            <span className="italic text-[#6b6b6b] text-[12px] font-normal json-schema-2020-12-keyword__value--warning">
              {propertyName}
            </span>
          </li>
        ))}
      </ul>
    </div>
  )
}

DependentRequired.propTypes = {
  schema: propTypes.schema.isRequired,
  dependentRequired: PropTypes.arrayOf(PropTypes.string).isRequired,
}

export default DependentRequired
