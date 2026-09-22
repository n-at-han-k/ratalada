import React, { PureComponent } from "react"
import PropTypes from "prop-types"
import { Iterable } from "immutable"
import { createDeepLinkPath } from "@/lib/swagger/utils/index"
import ImPropTypes from "react-immutable-proptypes"

// The path, as the link it always was. No wrapper span, no `data-path`
// attribute nothing reads.
export default class OperationSummaryPath extends PureComponent {
  static propTypes = {
    specPath: ImPropTypes.list.isRequired,
    operationProps: PropTypes.instanceOf(Iterable).isRequired,
    getComponent: PropTypes.func.isRequired,
  }

  render() {
    const { getComponent, operationProps } = this.props
    const { deprecated, path, tag, operationId, isDeepLinkingEnabled } =
      operationProps.toObject()

    // <wbr> between segments, so a long path breaks at the slashes.
    const pathParts = path.split(/(?=\/)/g)
    for (let i = 1; i < pathParts.length; i += 2) {
      pathParts.splice(i, 0, <wbr key={i} />)
    }

    const DeepLink = getComponent("DeepLink")

    return (
      <DeepLink
        enabled={isDeepLinkingEnabled}
        path={createDeepLinkPath(`${tag}/${operationId}`)}
        text={pathParts}
        className={`font-mono text-sm font-semibold${
          deprecated ? " text-muted-foreground line-through" : ""
        }`}
      />
    )
  }
}
