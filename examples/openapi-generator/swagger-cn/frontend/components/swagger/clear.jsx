import React, { Component } from "react"
import PropTypes from "prop-types"
import { Button } from "@/components/ui/button"

export default class Clear extends Component {

  onClick =() => {
    let { specActions, path, method } = this.props
    specActions.clearResponse( path, method )
    specActions.clearRequest( path, method )
  }

  render(){
    return (
      <Button variant="outline" className="opblock-control__btn" onClick={ this.onClick }>
        Clear
      </Button>
    )
  }

  static propTypes = {
    specActions: PropTypes.object.isRequired,
    path: PropTypes.string.isRequired,
    method: PropTypes.string.isRequired,
  }
}
