import React, { PureComponent } from "react"
import PropTypes from "prop-types"
import { Iterable } from "immutable"

import { Badge } from "@/components/reui/badge"

// The verb chip. swagger-ui coloured it from a dozen CSS rules, one per
// method, each overriding a black default.
//
// Mapped by HUE, not by the theme's semantic names: this theme defines
// `--info` as violet and `--primary` as near-black, so `variant="info"` would
// turn GET purple and `primary-light` would turn HEAD black. The colours are
// how people read the verb at a glance, so they keep the hues swagger always
// used -- blue read, green create, orange replace, red delete.
const COLOUR = {
  get: "bg-sky-500 text-white",
  post: "bg-emerald-500 text-white",
  put: "bg-orange-400 text-white",
  patch: "bg-teal-400 text-white",
  delete: "bg-red-500 text-white",
  head: "bg-violet-600 text-white",
  options: "bg-blue-800 text-white",
  trace: "bg-slate-500 text-white",
}

export default class OperationSummaryMethod extends PureComponent {
  static propTypes = {
    operationProps: PropTypes.instanceOf(Iterable).isRequired,
    method: PropTypes.string.isRequired,
  }

  static defaultProps = {
    operationProps: null,
  }

  render() {
    const { method } = this.props

    return (
      <Badge
        className={`opblock-summary-method min-w-20 justify-center border-transparent font-bold ${
          COLOUR[method?.toLowerCase()] ?? "bg-slate-400 text-white"
        }`}
      >
        {method.toUpperCase()}
      </Badge>
    )
  }
}
