import React from "react"
import PropTypes from "prop-types"

// An anchor. It used to be an anchor wrapping a span wrapping the text, with
// a `nostyle` class to undo the styling the stylesheet gave anchors -- three
// elements and a class to achieve "a link that looks like its context".
export const DeepLink = ({ enabled, path, text, className }) => (
  <a
    className={className}
    onClick={enabled ? (e) => e.preventDefault() : null}
    href={enabled ? `#/${path}` : null}
  >
    {text}
  </a>
)

DeepLink.propTypes = {
  enabled: PropTypes.bool,
  path: PropTypes.string,
  text: PropTypes.node,
  className: PropTypes.string,
}

export default DeepLink
