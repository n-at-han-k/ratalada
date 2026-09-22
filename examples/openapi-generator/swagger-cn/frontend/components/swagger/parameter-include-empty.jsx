import React, { Component } from "react"
import cx from "classnames"
import PropTypes from "prop-types"
import { Checkbox } from "@/components/ui/checkbox"
import { Field, FieldLabel } from "@/components/ui/field"


const noop = () => { }

const ParameterIncludeEmptyPropTypes = {
  isIncluded: PropTypes.bool.isRequired,
  isDisabled: PropTypes.bool.isRequired,
  isIncludedOptions: PropTypes.object,
  onChange: PropTypes.func.isRequired,
}

const ParameterIncludeEmptyDefaultProps = {
  onChange: noop,
  isIncludedOptions: {},
}
export default class ParameterIncludeEmpty extends Component {
  static propTypes = ParameterIncludeEmptyPropTypes
  static defaultProps = ParameterIncludeEmptyDefaultProps

  componentDidMount() {
    const { isIncludedOptions, onChange } = this.props
    const { shouldDispatchInit, defaultValue } = isIncludedOptions
    if (shouldDispatchInit) {
      onChange(defaultValue)
    }
  }

  onCheckboxChange = e => {
    const { onChange } = this.props
    onChange(e.target.checked)
  }

  render() {
    let { isIncluded, isDisabled } = this.props

    return (
      <Field orientation="horizontal">
        <Checkbox
          id="include_empty_value"
          disabled={isDisabled}
          checked={!isDisabled && isIncluded}
          onCheckedChange={(checked) => this.onCheckboxChange({ target: { checked } })}
        />
        <FieldLabel htmlFor="include_empty_value" className={isDisabled ? "opacity-70" : undefined}>
          Send empty value
        </FieldLabel>
      </Field>
    )
  }
}
