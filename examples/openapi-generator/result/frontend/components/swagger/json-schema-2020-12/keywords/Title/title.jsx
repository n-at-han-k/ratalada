/**
 * @prettier
 */
import React from "react"
import PropTypes from "prop-types"

import { schema } from "@/lib/swagger/plugins/json-schema-2020-12/prop-types"
import { useFn } from "@/lib/swagger/plugins/json-schema-2020-12/hooks"

const Title = ({ title = "", schema }) => {
  const fn = useFn()
  const renderedTitle = title || fn.getTitle(schema)

  if (!renderedTitle) return null

  return <strong className="json-schema-2020-12__title">{renderedTitle}</strong>
}

Title.propTypes = {
  title: PropTypes.oneOfType([PropTypes.string, PropTypes.element]),
  schema: schema.isRequired,
}

export default Title
