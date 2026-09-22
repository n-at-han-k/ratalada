/**
 * @prettier
 */
import React from "react"
import PropTypes from "prop-types"

const DiscriminatorMapping = ({ discriminator }) => {
  const mapping = discriminator?.mapping || {}

  if (Object.keys(mapping).length === 0) {
    return null
  }

  return Object.entries(mapping).map(([key, value]) => (
    <div key={`${key}-${value}`} className="mx-0 mt-[5px] mb-[5px]">
      <span className="json-schema-2020-12-keyword__name json-schema-2020-12-keyword__name--secondary">
        {key}
      </span>
      <span className="italic text-[#6b6b6b] text-[12px] font-normal json-schema-2020-12-keyword__value--secondary">
        {value}
      </span>
    </div>
  ))
}

DiscriminatorMapping.propTypes = {
  discriminator: PropTypes.shape({
    mapping: PropTypes.any,
  }),
}

export default DiscriminatorMapping
