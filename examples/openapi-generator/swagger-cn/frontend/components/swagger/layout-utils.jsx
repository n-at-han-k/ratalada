import React from "react"
import PropTypes from "prop-types"

function xclass(...args) {
  return args.filter(a => !!a).join(" ").trim()
}

export class Container extends React.Component {
  render() {
    let { fullscreen, full, ...rest } = this.props
    // Normal element

    if(fullscreen)
      return <section {...rest}/>

    let containerClass = "swagger-container" + (full ? "-full" : "")
    return (
      <section {...rest} className={xclass(rest.className, containerClass)}/>
    )
  }
}

Container.propTypes = {
  fullscreen: PropTypes.bool,
  full: PropTypes.bool,
  className: PropTypes.string
}

const DEVICES = {
  "mobile": "",
  "tablet": "-tablet",
  "desktop": "-desktop",
  "large": "-hd"
}

export class Col extends React.Component {

  render() {
    const {
      hide,
      keepContents,
      /* we don't want these in the `rest` object that passes to the final component,
         since React now complains. So we extract them */
      /* eslint-disable no-unused-vars */
      mobile,
      tablet,
      desktop,
      large,
      /* eslint-enable no-unused-vars */
      ...rest
    } = this.props

    if(hide && !keepContents)
      return <span/>

    let classesAr = []

    for (let device in DEVICES) {
      if (!Object.prototype.hasOwnProperty.call(DEVICES, device)) {
        continue
      }
      let deviceClass = DEVICES[device]
      if(device in this.props) {
        let val = this.props[device]

        if(val < 1) {
          classesAr.push("none" + deviceClass)
          continue
        }

        classesAr.push("sw-block" + deviceClass)
        classesAr.push("col-" + val + deviceClass)
      }
    }

    if (hide) {
      classesAr.push("hidden")
    }

    let classes = xclass(rest.className, ...classesAr)

    return (
      <section {...rest} className={classes}/>
    )
  }

}

Col.propTypes = {
  hide: PropTypes.bool,
  keepContents: PropTypes.bool,
  mobile: PropTypes.number,
  tablet: PropTypes.number,
  desktop: PropTypes.number,
  large: PropTypes.number,
  className: PropTypes.string
}

export class Row extends React.Component {

  render() {
    return <div {...this.props} className={xclass(this.props.className, "wrapper")} />
  }

}

Row.propTypes = {
  className: PropTypes.string
}

// Button, TextArea and Input are gone. They were a <button>, a <textarea>
// and an <input> with a class on them; the registry now answers those names
// with the shadcn components, so every `getComponent("Button")` in the app
// gets one without a single call site changing.
//
// See presets/base/plugins/form-components.

// Select is gone too -- see components/select.jsx, which presents this same
// API over ReUI's composed Select.

export class Link extends React.Component {

  render() {
    return <a {...this.props} rel="noopener noreferrer" className={xclass(this.props.className, "link")}/>
  }

}

Link.propTypes = {
  className: PropTypes.string
}

const NoMargin = ({children}) => <div className="h-auto m-0 p-0 border-none"> {children} </div>

NoMargin.propTypes = {
  children: PropTypes.node
}

export class Collapse extends React.Component {

  static propTypes = {
    isOpened: PropTypes.bool,
    children: PropTypes.node.isRequired,
    animated: PropTypes.bool
  }

  static defaultProps = {
    isOpened: false,
    animated: false
  }

  renderNotAnimated() {
    if(!this.props.isOpened)
      return <noscript/>
    return (
      <NoMargin>
        {this.props.children}
      </NoMargin>
    )
  }

  render() {
    let { animated, isOpened, children } = this.props

    if(!animated)
      return this.renderNotAnimated()

    children = isOpened ? children : null
    return (
      <NoMargin>
        {children}
      </NoMargin>
    )
  }

}
