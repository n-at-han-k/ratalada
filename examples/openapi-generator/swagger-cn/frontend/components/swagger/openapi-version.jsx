import React from "react"
import PropTypes from "prop-types"

import { Badge } from "@/components/reui/badge"

// The OAS version stamp beside the API title. Olive, as it always was --
// mapped by hue rather than by a theme name, because this theme's `info` is
// violet and `primary` is near-black.
const OpenAPIVersion = ({ oasVersion }) => (
  <Badge className="version-stamp ml-2 border-transparent bg-lime-600 align-middle text-white">
    OAS {oasVersion}
  </Badge>
)

OpenAPIVersion.propTypes = {
  oasVersion: PropTypes.string.isRequired,
}

export default OpenAPIVersion
