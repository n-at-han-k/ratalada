import React from "react"
import PropTypes from "prop-types"

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
        <button className={`${isAuthorized ? "btn authorize locked" : "btn authorize unlocked"} [&.btn-sm]:text-[12px] [&.btn-sm]:py-1 [&.btn-sm]:pr-[23px] [&.btn-sm]:pl-[23px] [&_[disabled]]:cursor-not-allowed [&_[disabled]]:opacity-30`} onClick={onClick}>
          <span>Authorize</span>
          {isAuthorized ? <LockAuthIcon /> : <UnlockAuthIcon />}
        </button>
      { showPopup && <AuthorizationPopup /> }
      </div>
    )
  }
}
