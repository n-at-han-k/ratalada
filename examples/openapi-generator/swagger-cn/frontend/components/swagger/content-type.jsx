import React from "react"
import PropTypes from "prop-types"
import ImPropTypes from "react-immutable-proptypes"
import { fromJS } from "immutable"
import { Select } from "@/components/select"

const noop = ()=>{}

export default class ContentType extends React.Component {
  static propTypes = {
    ariaControls: PropTypes.string,
    contentTypes: PropTypes.oneOfType([ImPropTypes.list, ImPropTypes.set, ImPropTypes.seq]),
    controlId: PropTypes.string,
    value: PropTypes.string,
    onChange: PropTypes.func,
    className: PropTypes.string,
    ariaLabel: PropTypes.string
  }

  static defaultProps = {
    onChange: noop,
    value: null,
    contentTypes: fromJS(["application/json"]),
  }

  componentDidMount() {
    // Populate the form initially, but only if there is no valid value already set
    const { contentTypes, value, onChange } = this.props
    if (contentTypes && contentTypes.size && !contentTypes.includes(value)) {
      onChange(contentTypes.first())
    }
  }

  componentDidUpdate() {
    const { contentTypes, value, onChange } = this.props

    if (!contentTypes || !contentTypes.size) {
      return
    }

    if (!contentTypes.includes(value)) {
      onChange(contentTypes.first())
    }
  }

  // the registry's Select hands over the value, not an event
  onChangeWrapper = (value) => this.props.onChange(value)

  render() {
    let { ariaControls, ariaLabel, className, contentTypes, controlId, value } = this.props

    if ( !contentTypes || !contentTypes.size )
      return null

    return (
      <div className={ "content-type-wrapper " + ( className || "" ) }>
        <Select
          aria-controls={ariaControls}
          aria-label={ariaLabel}
          className="content-type"
          id={controlId}
          onChange={this.onChangeWrapper}
          value={value || ""}
          allowEmptyValue={false}
          allowedValues={contentTypes.toArray()}
        />
      </div>
    )
  }
  
}