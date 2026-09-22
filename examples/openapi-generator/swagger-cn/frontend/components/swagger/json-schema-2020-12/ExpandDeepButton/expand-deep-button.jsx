/**
 * @prettier
 */
import React, { useCallback } from "react"
import PropTypes from "prop-types"
import { Button } from "@/components/ui/button"

const ExpandDeepButton = ({ expanded, onClick }) => {
  const handleExpansion = useCallback(
    (event) => {
      onClick(event, !expanded)
    },
    [expanded, onClick]
  )

  return (
    <Button variant="ghost" size="sm"
      type="button"
      className="json-schema-2020-12-expand-deep-button"
      onClick={handleExpansion}
    >
      {expanded ? "Collapse all" : "Expand all"}
    </Button>
  )
}

ExpandDeepButton.propTypes = {
  expanded: PropTypes.bool.isRequired,
  onClick: PropTypes.func.isRequired,
}

export default ExpandDeepButton
