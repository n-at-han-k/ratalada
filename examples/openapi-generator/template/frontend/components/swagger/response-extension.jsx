import React from "react"
import PropTypes from "prop-types"

export const ResponseExtension = ({ xKey, xVal }) => {
    return <div className="italic font-semibold text-[12px] font-[monospace] text-[rgb(50%,50%,50%)]">{ xKey }: { String(xVal) }</div>
}
ResponseExtension.propTypes = {
  xKey: PropTypes.string,
  xVal: PropTypes.any
}

export default ResponseExtension
