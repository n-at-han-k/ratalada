import React from "react"
import { fromJS, Iterable } from "immutable"
import PropTypes from "prop-types"
import ImPropTypes from "react-immutable-proptypes"
import { defaultStatusCode, getAcceptControllingResponse, isExtension } from "@/lib/swagger/utils/index"
import createHtmlReadyId from "@/lib/swagger/utils/create-html-ready-id"
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table"

export default class Responses extends React.Component {
  static propTypes = {
    tryItOutResponse: PropTypes.instanceOf(Iterable),
    responses: PropTypes.instanceOf(Iterable).isRequired,
    produces: PropTypes.instanceOf(Iterable),
    producesValue: PropTypes.any,
    displayRequestDuration: PropTypes.bool.isRequired,
    path: PropTypes.string.isRequired,
    method: PropTypes.string.isRequired,
    getComponent: PropTypes.func.isRequired,
    getConfigs: PropTypes.func.isRequired,
    specSelectors: PropTypes.object.isRequired,
    specActions: PropTypes.object.isRequired,
    oas3Actions: PropTypes.object.isRequired,
    oas3Selectors: PropTypes.object.isRequired,
    specPath: ImPropTypes.list.isRequired,
    fn: PropTypes.object.isRequired
  }

  static defaultProps = {
    tryItOutResponse: null,
    produces: fromJS(["application/json"]),
    displayRequestDuration: false
  }

  // These performance-enhancing checks were disabled as part of Multiple Examples
  // because they were causing data-consistency issues
  //
  // shouldComponentUpdate(nextProps) {
  //   // BUG: props.tryItOutResponse is always coming back as a new Immutable instance
  //   let render = this.props.tryItOutResponse !== nextProps.tryItOutResponse
  //   || this.props.responses !== nextProps.responses
  //   || this.props.produces !== nextProps.produces
  //   || this.props.producesValue !== nextProps.producesValue
  //   || this.props.displayRequestDuration !== nextProps.displayRequestDuration
  //   || this.props.path !== nextProps.path
  //   || this.props.method !== nextProps.method
  //   return render
  // }

	onChangeProducesWrapper = ( val ) => this.props.specActions.changeProducesValue([this.props.path, this.props.method], val)

  onResponseContentTypeChange = ({ controlsAcceptHeader, value }) => {
    const { oas3Actions, path, method } = this.props
    if(controlsAcceptHeader) {
      oas3Actions.setResponseContentType({
        value,
        path,
        method
      })
    }
  }

  render() {
    let {
      responses,
      tryItOutResponse,
      getComponent,
      getConfigs,
      specSelectors,
      fn,
      producesValue,
      displayRequestDuration,
      specPath,
      path,
      method,
      oas3Selectors,
      oas3Actions,
    } = this.props
    let defaultCode = defaultStatusCode( responses )

    const ContentType = getComponent( "contentType" )
    const LiveResponse = getComponent( "liveResponse" )
    const Response = getComponent( "response" )

    let produces = this.props.produces && this.props.produces.size ? this.props.produces : Responses.defaultProps.produces

    const isSpecOAS3 = specSelectors.isOAS3()

    const acceptControllingResponse = isSpecOAS3 ?
      getAcceptControllingResponse(responses) : null

    const nonExtensionResponses = responses.filter((_, key) => !isExtension(key))
    const regionId = createHtmlReadyId(`${method}${path}_responses`)
    const controlId = `${regionId}_select`

    return (!nonExtensionResponses || !nonExtensionResponses.size) ? null : (
      <div className="responses-wrapper">
        <div className="opblock-section-header">
          <h4>Responses</h4>
            { specSelectors.isOAS3() ? null : <label htmlFor={controlId}>
              <span>Response content type</span>
              <ContentType value={producesValue}
                         ariaControls={regionId}
                         ariaLabel="Response content type"
                         className="execute-content-type"
                         contentTypes={produces}
                         controlId={controlId}
                         onChange={this.onChangeProducesWrapper} />
                     </label> }
        </div>
        <div className="responses-inner">
          {
            !tryItOutResponse ? null
                              : <div>
                                  <LiveResponse response={ tryItOutResponse }
                                                getComponent={ getComponent }
                                                getConfigs={ getConfigs }
                                                specSelectors={ specSelectors }
                                                path={ this.props.path }
                                                method={ this.props.method }
                                                displayRequestDuration={ displayRequestDuration } />
                                  <h4>Responses</h4>
                                </div>

          }

          <Table aria-live="polite" className="responses-table" id={regionId} role="region">
            <TableHeader>
              <TableRow className="responses-header">
                <TableCell className="col_header response-col_status">Code</TableCell>
                <TableCell className="col_header response-col_description [&_.markdown_p:first-child]:m-0 [&_.renderedMarkdown_p:first-child]:m-0 [&_.markdown_p:last-child]:mb-0 [&_.renderedMarkdown_p:last-child]:mb-0">Description</TableCell>
                { specSelectors.isOAS3() ? <TableCell className="col col_header response-col_links [&_.operation-link]:mb-[1.5em] [&_.operation-link_.description]:mb-[0.5em]">Links</TableCell> : null }
              </TableRow>
            </TableHeader>
            <TableBody>
              {
                nonExtensionResponses.entrySeq().map( ([code, response]) => {

                  let className = tryItOutResponse && tryItOutResponse.get("status") == code ? "response_current" : ""
                  return (
                    <Response key={ code }
                              path={path}
                              method={method}
                              specPath={specPath.push(code)}
                              isDefault={defaultCode === code}
                              fn={fn}
                              className={ className }
                              code={ code }
                              response={ response }
                              specSelectors={ specSelectors }
                              controlsAcceptHeader={response === acceptControllingResponse}
                              onContentTypeChange={this.onResponseContentTypeChange}
                              contentType={ producesValue }
                              getConfigs={ getConfigs }
                              activeExamplesKey={oas3Selectors.activeExamplesMember(
                                path,
                                method,
                                "responses",
                                code
                              )}
                              oas3Actions={oas3Actions}
                              oas3Selectors={oas3Selectors}
                              getComponent={ getComponent }/>
                    )
                }).toArray()
              }
            </TableBody>
          </Table>
        </div>
      </div>
    )
  }
}
