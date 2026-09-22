import React from "react"
import PropTypes from "prop-types"

import { Badge } from "@/components/reui/badge"

// The API's own version, beside its title.
const VersionStamp = ({ version }) => (
  <Badge variant="secondary" className="version ml-2 align-middle">
    {version}
  </Badge>
)

VersionStamp.propTypes = {
  version: PropTypes.string.isRequired,
}

export default VersionStamp
