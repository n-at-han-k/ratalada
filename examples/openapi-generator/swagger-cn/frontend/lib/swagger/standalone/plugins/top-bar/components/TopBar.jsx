import React, { cloneElement } from "react"
import PropTypes from "prop-types"

import {parseSearch, serializeSearch} from "@/lib/swagger/utils/index"
import { Select } from "@/components/select"

class TopBar extends React.Component {

  static propTypes = {
    layoutActions: PropTypes.object.isRequired,
    authActions: PropTypes.object.isRequired
  }

  constructor(props, context) {
    super(props, context)
    this.state = { url: props.specSelectors.url(), selectedIndex: 0 }
  }

  UNSAFE_componentWillReceiveProps(nextProps) {
    this.setState({ url: nextProps.specSelectors.url() })
  }

  onUrlChange =(e)=> {
    let {target: {value}} = e
    this.setState({url: value})
  }

  flushAuthData() {
    const { persistAuthorization } = this.props.getConfigs()
    if (persistAuthorization)
    {
      return
    }
    this.props.authActions.restoreAuthorization({
      authorized: {}
    })
  }

  loadSpec = (url) => {
    this.flushAuthData()
    this.props.specActions.updateUrl(url)
    this.props.specActions.download(url)
  }

  // The registry's Select hands over the value; the anchor form still
  // arrives as an event, so both are accepted.
  onUrlSelect = (eventOrValue) => {
    const url = typeof eventOrValue === "string"
      ? eventOrValue
      : eventOrValue?.target?.value || eventOrValue?.target?.href
    this.loadSpec(url)
    this.setSelectedUrl(url)
    eventOrValue?.preventDefault?.()
  }

  downloadUrl = (e) => {
    this.loadSpec(this.state.url)
    e.preventDefault()
  }

  setSearch = (spec) => {
    let search = parseSearch()
    search["urls.primaryName"] = spec.name
    const newUrl = `${window.location.protocol}//${window.location.host}${window.location.pathname}`
    if(window && window.history && window.history.pushState) {
      window.history.replaceState(null, "", `${newUrl}?${serializeSearch(search)}`)
    }
  }

  setSelectedUrl = (selectedUrl) => {
    const configs = this.props.getConfigs()
    const urls = configs.urls || []

    if(urls && urls.length) {
      if(selectedUrl)
      {
        urls.forEach((spec, i) => {
          if(spec.url === selectedUrl)
            {
              this.setState({selectedIndex: i})
              this.setSearch(spec)
            }
        })
      }
    }
  }

  componentDidMount() {
    const configs = this.props.getConfigs()
    const urls = configs.urls || []

    if(urls && urls.length) {
      var targetIndex = this.state.selectedIndex
      let search = parseSearch()
      let primaryName = search["urls.primaryName"] || configs.urls.primaryName
      if(primaryName)
      {
        urls.forEach((spec, i) => {
          if(spec.name === primaryName)
            {
              this.setState({selectedIndex: i})
              targetIndex = i
            }
        })
      }

      this.loadSpec(urls[targetIndex].url)
    }
  }

  onFilterChange =(e) => {
    let {target: {value}} = e
    this.props.layoutActions.updateFilter(value)
  }

  render() {
    let { getComponent, specSelectors, getConfigs } = this.props
    const Button = getComponent("Button")
    const Link = getComponent("Link")
    const Logo = getComponent("Logo")
    const DarkModeToggle = getComponent("DarkModeToggle")

    let isLoading = specSelectors.loadingStatus() === "loading"
    let isFailed = specSelectors.loadingStatus() === "failed"

    const classNames = ["download-url-input"]
    if (isFailed) classNames.push("failed")
    if (isLoading) classNames.push("loading")

    const { urls } = getConfigs()
    let control = []
    let formOnSubmit = null

    if(urls) {
      control.push(
        <label className="select-label" htmlFor="select"><span>Select a definition</span>
          <Select
            id="select"
            disabled={isLoading}
            onChange={this.onUrlSelect}
            allowEmptyValue={false}
            value={urls[this.state.selectedIndex].url}
            allowedValues={urls.map((link) => ({ value: link.url, label: link.name }))}
          />
        </label>
      )
    }
    else {
      formOnSubmit = this.downloadUrl
      control.push(
        <input
          className={classNames.join(" ")}
          type="text"
          onChange={this.onUrlChange}
          value={this.state.url}
          disabled={isLoading}
          id="download-url-input"
        />
      )
      control.push(<Button variant="default" className="download-url-button" onClick={ this.downloadUrl }>Explore</Button>)
    }

    return (
      <header className="topbar [&_.download-url-wrapper_.select-label_span]:text-right [&_.download-url-wrapper_.select-label_span]:text-[16px] [&_.download-url-wrapper_.select-label_span]:flex-[1] [&_.download-url-wrapper_.select-label_span]:py-0 [&_.download-url-wrapper_.select-label_span]:pl-0 [&_.download-url-wrapper_.select-label_span]:pr-2.5 [&_.dark-mode-toggle_button_svg]:fill-[#e4e6e6] [&_.dark-mode-toggle:hover]:opacity-100" role="banner">
        <div className="wrapper">
          <div className="topbar-wrapper items-center flex flex-wrap gap-[10px]">
            <Link>
              <Logo/>
            </Link>
            <form className="download-url-wrapper" onSubmit={formOnSubmit}>
              {control.map((el, i) => cloneElement(el, { key: i }))}
            </form>
            <DarkModeToggle />
          </div>
        </div>
      </header>
    )
  }
}

TopBar.propTypes = {
  specSelectors: PropTypes.object.isRequired,
  specActions: PropTypes.object.isRequired,
  getComponent: PropTypes.func.isRequired,
  getConfigs: PropTypes.func.isRequired
}

export default TopBar
