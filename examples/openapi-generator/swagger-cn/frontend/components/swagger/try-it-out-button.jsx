import React from "react"
import PropTypes from "prop-types"
import { Button } from "@/components/ui/button"

export default class TryItOutButton extends React.Component {

  static propTypes = {
    onTryoutClick: PropTypes.func,
    onResetClick: PropTypes.func,
    onCancelClick: PropTypes.func,
    enabled: PropTypes.bool, // Try it out is enabled, ie: the user has access to the form
    hasUserEditedBody: PropTypes.bool, // Try it out is enabled, ie: the user has access to the form
    isOAS3: PropTypes.bool, // Try it out is enabled, ie: the user has access to the form
  }

  static defaultProps = {
    onTryoutClick: Function.prototype,
    onCancelClick: Function.prototype,
    onResetClick: Function.prototype,
    enabled: false,
    hasUserEditedBody: false,
    isOAS3: false,
  }

  render() {
    const { onTryoutClick, onCancelClick, onResetClick, enabled, hasUserEditedBody, isOAS3 } = this.props

    const showReset = isOAS3 && hasUserEditedBody
    return (
      <div className={showReset ? "try-out btn-group" : "try-out"}>
        {
          enabled ? <Button variant="outline" className="try-out__btn ml-5" onClick={ onCancelClick }>Cancel</Button>
                  : <Button variant="outline" className="try-out__btn ml-5" onClick={ onTryoutClick }>Try it out </Button>

        }
        {
          showReset && <Button variant="ghost" className="try-out__btn ml-5" onClick={ onResetClick }>Reset</Button>
        }
      </div>
    )
  }
}
