import React from "react"
import PropTypes from "prop-types"
import { Select } from "@/components/select"
import { Field, FieldLabel } from "@/components/ui/field"

export default class Schemes extends React.Component {

  static propTypes = {
    specActions: PropTypes.object.isRequired,
    schemes: PropTypes.object.isRequired,
    currentScheme: PropTypes.string.isRequired,
    path: PropTypes.string,
    method: PropTypes.string,
  }

  UNSAFE_componentWillMount() {
    let { schemes } = this.props

    //fire 'change' event to set default 'value' of select
    this.setScheme(schemes.first())
  }

  UNSAFE_componentWillReceiveProps(nextProps) {
    if ( !this.props.currentScheme || !nextProps.schemes.includes(this.props.currentScheme) ) {
      // if we don't have a selected currentScheme or if our selected scheme is no longer an option,
      // then fire 'change' event and select the first scheme in the list of options
      this.setScheme(nextProps.schemes.first())
    }
  }

  onChange = (value) => {
    this.setScheme(value)
  }

  setScheme = ( value ) => {
    let { path, method, specActions } = this.props

    specActions.setScheme( value, path, method )
  }

  render() {
    let { schemes, currentScheme } = this.props

    return (
      <Field>
        <FieldLabel htmlFor="schemes">Schemes</FieldLabel>
        <Select
          id="schemes"
          onChange={ this.onChange }
          value={ currentScheme }
          allowEmptyValue={ false }
          allowedValues={ schemes.valueSeq().toArray() }
        />
      </Field>
    )
  }
}
