import React, { Component } from "react"
import PropTypes from "prop-types"

export default class Clear extends Component {

  onClick =() => {
    let { specActions, path, method } = this.props
    specActions.clearResponse( path, method )
    specActions.clearRequest( path, method )
  }

  render(){
    return (
      <button className="btn btn-clear opblock-control__btn [&.btn-sm]:text-[12px] [&.btn-sm]:py-1 [&.btn-sm]:pr-[23px] [&.btn-sm]:pl-[23px] [&_[disabled]]:cursor-not-allowed [&_[disabled]]:opacity-30" onClick={ this.onClick }>
        Clear
      </button>
    )
  }

  static propTypes = {
    specActions: PropTypes.object.isRequired,
    path: PropTypes.string.isRequired,
    method: PropTypes.string.isRequired,
  }
}
