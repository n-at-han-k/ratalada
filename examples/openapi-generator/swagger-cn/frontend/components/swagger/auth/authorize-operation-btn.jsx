import React from "react"
import PropTypes from "prop-types"
import { Button } from "@/components/ui/button"

export default class AuthorizeOperationBtn extends React.Component {
    static propTypes = {
      isAuthorized: PropTypes.bool.isRequired,
      onClick: PropTypes.func,
      getComponent: PropTypes.func.isRequired
    }

  onClick =(e) => {
    e.stopPropagation()
    let { onClick } = this.props

    if(onClick) {
      onClick()
    }
  }

  render() {
    let { isAuthorized, getComponent } = this.props

    const LockAuthOperationIcon = getComponent("LockAuthOperationIcon", true)
    const UnlockAuthOperationIcon = getComponent("UnlockAuthOperationIcon", true)

    return (
      <Button variant="ghost" size="icon-sm" className="authorization__btn [&_.locked]:opacity-100 [&_.unlocked]:opacity-40"
        aria-label={isAuthorized ? "authorization button locked" : "authorization button unlocked"}
        onClick={this.onClick}>
        {isAuthorized ? <LockAuthOperationIcon className="locked" /> : <UnlockAuthOperationIcon className="unlocked"/>}
      </Button>

    )
  }
}
