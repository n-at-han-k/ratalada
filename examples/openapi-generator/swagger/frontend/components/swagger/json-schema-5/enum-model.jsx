import React from "react"
import PropTypes from "prop-types"
import ImPropTypes from "react-immutable-proptypes"

const EnumModel = ({ value, getComponent }) => {
  let ModelCollapse = getComponent("ModelCollapse")
  let collapsedContent = <span>Array [ { value.count() } ]</span>
  return <span className="block">
    Enum:<br />
    <ModelCollapse collapsedContent={ collapsedContent }>
      [ { value.map(String).join(", ") } ]
    </ModelCollapse>
  </span>
}
EnumModel.propTypes = {
  value: ImPropTypes.iterable,
  getComponent: PropTypes.func
}

export default EnumModel
