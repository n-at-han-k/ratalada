import React from "react"
import PropTypes from "prop-types"
import { Button } from "@/components/ui/button"

export default class AuthorizeBtn extends React.Component {
  static propTypes = {
    onClick: PropTypes.func,
    isAuthorized: PropTypes.bool,
    showPopup: PropTypes.bool,
    getComponent: PropTypes.func.isRequired
  }

  render() {
    let { isAuthorized, showPopup, onClick, getComponent } = this.props

    //must be moved out of button component
    const AuthorizationPopup = getComponent("authorizationPopup", true)
    const LockAuthIcon = getComponent("LockAuthIcon", true)
    const UnlockAuthIcon = getComponent("UnlockAuthIcon", true)

    return (
      <div className="auth-wrapper [&_.authorize]:pr-5 [&_.authorize]:ml-2.5 [&_.authorize]:mr-2.5">
        <Button
          variant="success"
          className={isAuthorized ? "authorize locked" : "authorize unlocked"}
          onClick={onClick}
        >
          <span>Authorize</span>
          {isAuthorized ? <LockAuthIcon /> : <UnlockAuthIcon />}
        </Button>
      { showPopup && <AuthorizationPopup /> }
      </div>
    )
  }
}
