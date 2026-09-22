/**
 * @prettier
 */
import React from "react"
import PropTypes from "prop-types"

const Example = ({ schema, getSystem }) => {
  const { fn, getComponent } = getSystem()
  const { hasKeyword } = fn.jsonSchema202012.useFn()
  const JSONViewer = getComponent("JSONSchema202012JSONViewer")

  if (!hasKeyword(schema, "example")) return null

  return (
    <JSONViewer
      name="Example"
      value={schema.example}
      className="mx-0 mt-[5px] mb-[5px] json-schema-2020-12-keyword--example"
    />
  )
}

Example.propTypes = {
  schema: PropTypes.oneOfType([PropTypes.object, PropTypes.bool]).isRequired,
  getSystem: PropTypes.func.isRequired,
}

export default Example
