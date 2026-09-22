import React from "react"
import PropTypes from "prop-types"
import ImPropTypes from "react-immutable-proptypes"
import { Field, FieldGroup, FieldLabel } from "@/components/ui/field"

export default class BasicAuth extends React.Component {
  static propTypes = {
    authorized: ImPropTypes.map,
    schema: ImPropTypes.map,
    getComponent: PropTypes.func.isRequired,
    onChange: PropTypes.func.isRequired,
    name: PropTypes.string.isRequired,
    errSelectors: PropTypes.object.isRequired,
    authSelectors: PropTypes.object.isRequired
  }

  constructor(props, context) {
    super(props, context)
    let { schema, name } = this.props

    let value = this.getValue()
    let username = value.username

    this.state = {
      name: name,
      schema: schema,
      value: !username ? {} : {
        username: username
      }
    }
  }

  getValue () {
    let { authorized, name } = this.props

    return authorized && authorized.getIn([name, "value"]) || {}
  }

  onChange =(e) => {
    let { onChange } = this.props
    let { value, name } = e.target

    let newValue = this.state.value
    newValue[name] = value

    this.setState({ value: newValue })

    onChange(this.state)
  }

  render() {
    const { schema, getComponent, name, errSelectors, authSelectors } = this.props
    const Input = getComponent("Input")
    const AuthError = getComponent("authError")
    const Markdown = getComponent("Markdown", true)
    const username = this.getValue().username
    const errors = errSelectors.allErrors().filter((err) => err.get("authId") === name)

    return (
      <div className="space-y-3">
        <h4 className="text-sm font-semibold">Basic authorization</h4>
        {username && <p className="text-success text-sm">Authorized</p>}

        <div className="text-muted-foreground text-sm">
          <Markdown source={schema.get("description")} />
        </div>

        <FieldGroup>
          <Field>
            <FieldLabel htmlFor="auth_username">Username</FieldLabel>
            {username ? (
              <code className="text-sm">{username}</code>
            ) : (
              <Input
                id="auth_username"
                type="text"
                required
                name="username"
                onChange={this.onChange}
                autoFocus
              />
            )}
          </Field>

          <Field>
            <FieldLabel htmlFor="auth_password">Password</FieldLabel>
            {username ? (
              <code className="text-sm">******</code>
            ) : (
              <Input
                id="auth_password"
                autoComplete="new-password"
                name="password"
                type="password"
                onChange={this.onChange}
              />
            )}
          </Field>
        </FieldGroup>

        {errors.valueSeq().map((error, key) => (
          <AuthError error={error} key={key} />
        ))}
      </div>
    )
  }

}
