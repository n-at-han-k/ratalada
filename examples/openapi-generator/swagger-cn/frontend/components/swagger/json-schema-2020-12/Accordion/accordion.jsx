/**
 * @prettier
 */
import React, { useCallback } from "react"
import PropTypes from "prop-types"
import classNames from "classnames"

import { useComponent } from "@/lib/swagger/plugins/json-schema-2020-12/hooks"
import { Button } from "@/components/ui/button"

const Accordion = ({ expanded = false, children, onChange }) => {
  const ChevronRightIcon = useComponent("ChevronRightIcon")

  const handleExpansion = useCallback(
    (event) => {
      onChange(event, !expanded)
    },
    [expanded, onChange]
  )

  return (
    <Button variant="ghost" size="sm"
      type="button"
      className="json-schema-2020-12-accordion"
      onClick={handleExpansion}
    >
      <div className="inline-block">{children}</div>
      <span
        className={classNames("json-schema-2020-12-accordion__icon", {
          "json-schema-2020-12-accordion__icon--expanded": expanded,
          "json-schema-2020-12-accordion__icon--collapsed": !expanded,
        })}
      >
        <ChevronRightIcon />
      </span>
    </Button>
  )
}

Accordion.propTypes = {
  expanded: PropTypes.bool,
  children: PropTypes.node.isRequired,
  onChange: PropTypes.func.isRequired,
}

export default Accordion
