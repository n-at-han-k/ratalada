/**
 * @prettier
 */

import React from "react"
import PropTypes from "prop-types"
import ImPropTypes from "react-immutable-proptypes"
import { stringify } from "@/lib/swagger/utils/index"
import { Map } from "immutable"

export default function Example(props) {
  const { example, showValue, getComponent } = props

  const Markdown = getComponent("Markdown", true)
  const HighlightCode = getComponent("HighlightCode", true)

  if (!example || !Map.isMap(example)) return null

  return (
    <div className="example">
      {example.get("description") ? (
        <section className="mt-[1.5em]">
          <div className="mb-2 font-bold text-[0.9rem]">Example Description</div>
          <p>
            <Markdown source={example.get("description")} />
          </p>
        </section>
      ) : null}
      {showValue && example.has("value") ? (
        <section className="mt-[1.5em]">
          <div className="mb-2 font-bold text-[0.9rem]">Example Value</div>
          <HighlightCode>{stringify(example.get("value"))}</HighlightCode>
        </section>
      ) : null}
    </div>
  )
}

Example.propTypes = {
  example: ImPropTypes.map.isRequired,
  showValue: PropTypes.bool,
  getComponent: PropTypes.func.isRequired,
}
