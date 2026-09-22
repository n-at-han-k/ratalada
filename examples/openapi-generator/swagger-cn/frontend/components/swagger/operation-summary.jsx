import React, { PureComponent } from "react"
import PropTypes from "prop-types"
import { Iterable, List } from "immutable"
import ImPropTypes from "react-immutable-proptypes"
import toString from "lodash/toString"

/**
 * The row you see for every operation: verb, path, summary, and the actions
 * that hang off it.
 *
 * Three things that used to be here are gone, because the accordion already
 * does them:
 *
 *   - the `opblock-summary-control` button that wrapped the whole row. The
 *     AccordionTrigger is the button now; having a second one inside it was
 *     invalid HTML and meant a click toggled twice, so the toggle had to be
 *     neutered to compensate.
 *   - the `opblock-control-arrow` button with its own up/down icons. The
 *     trigger draws its own chevron and rotates it.
 *   - `JumpToPath`, whose own comment said swagger-ui does not care about it.
 *     It is an editor feature and renders nothing here.
 *
 * With those gone the row is a flex line, so `isShown` and `toggleShown` are
 * no longer needed either.
 */
export default class OperationSummary extends PureComponent {
  static propTypes = {
    specPath: ImPropTypes.list.isRequired,
    operationProps: PropTypes.instanceOf(Iterable).isRequired,
    getComponent: PropTypes.func.isRequired,
    authActions: PropTypes.object,
    authSelectors: PropTypes.object,
  }

  static defaultProps = {
    operationProps: null,
    specPath: List(),
    summary: "",
  }

  render() {
    const { getComponent, authActions, authSelectors, operationProps, specPath } = this.props

    const {
      summary,
      isAuthorized,
      method,
      op,
      showSummary,
      operationId,
      originalOperationId,
      displayOperationId,
    } = operationProps.toObject()

    const resolvedSummary = op.get("summary")
    const security = operationProps.get("security")

    const AuthorizeOperationBtn = getComponent("authorizeOperationBtn", true)
    const OperationSummaryMethod = getComponent("OperationSummaryMethod")
    const OperationSummaryPath = getComponent("OperationSummaryPath")
    const CopyToClipboardBtn = getComponent("CopyToClipboardBtn", true)

    const hasSecurity = security && !!security.count()
    const securityIsOptional = hasSecurity && security.size === 1 && security.first().isEmpty()
    const allowAnonymous = !hasSecurity || securityIsOptional

    return (
      <div className="flex flex-1 flex-wrap items-center gap-x-3 gap-y-1 py-2 text-left">
        <OperationSummaryMethod method={method} />

        <div className="flex flex-1 flex-wrap items-center gap-x-3 gap-y-1">
          <OperationSummaryPath
            getComponent={getComponent}
            operationProps={operationProps}
            specPath={specPath}
          />

          {showSummary && (
            <span className="text-muted-foreground text-sm">
              {toString(resolvedSummary || summary)}
            </span>
          )}
        </div>

        {displayOperationId && (originalOperationId || operationId) ? (
          <span className="text-muted-foreground font-mono text-xs">
            {originalOperationId || operationId}
          </span>
        ) : null}

        <CopyToClipboardBtn textToCopy={`${specPath.get(1)}`} />

        {allowAnonymous ? null : (
          <AuthorizeOperationBtn
            isAuthorized={isAuthorized}
            onClick={() => {
              const applicableDefinitions =
                authSelectors.definitionsForRequirements(security)
              authActions.showDefinitions(applicableDefinitions)
            }}
          />
        )}
      </div>
    )
  }
}
