/**
 * @prettier
 */
import React, { Component } from "react"
import PropTypes from "prop-types"
import { List } from "immutable"
import ImPropTypes from "react-immutable-proptypes"
import { sanitizeUrl } from "@/lib/swagger/utils/url"
import classNames from "classnames"
import { getExtensions } from "@/lib/swagger/utils/index"
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table"

const braceOpen = "{"
const braceClose = "}"
const propClass = "property"

export default class ObjectModel extends Component {
  static propTypes = {
    schema: PropTypes.object.isRequired,
    getComponent: PropTypes.func.isRequired,
    getConfigs: PropTypes.func.isRequired,
    expanded: PropTypes.bool,
    onToggle: PropTypes.func,
    specSelectors: PropTypes.object.isRequired,
    name: PropTypes.string,
    displayName: PropTypes.string,
    isRef: PropTypes.bool,
    expandDepth: PropTypes.number,
    depth: PropTypes.number,
    specPath: ImPropTypes.list.isRequired,
    includeReadOnly: PropTypes.bool,
    includeWriteOnly: PropTypes.bool,
    layoutActions: PropTypes.shape({
      show: PropTypes.func.isRequired,
    }),
    layoutSelectors: PropTypes.shape({
      isShown: PropTypes.func.isRequired,
    }),
  }

  handleToggle = (modelName, shown) => {
    const { layoutActions, specPath } = this.props
    layoutActions?.show(specPath.toJS(), shown)
  }

  render() {
    let {
      schema,
      name,
      displayName,
      isRef,
      getComponent,
      getConfigs,
      depth,
      specPath,
      ...otherProps
    } = this.props
    let {
      specSelectors,
      expandDepth,
      includeReadOnly,
      includeWriteOnly,
      layoutSelectors,
    } = otherProps
    const { isOAS3 } = specSelectors
    const isEmbedded = depth > 2 || (depth === 2 && specPath.last() !== "items")
    const defaultExpanded = depth <= expandDepth
    const isExpanded =
      layoutSelectors?.isShown(specPath.toJS(), defaultExpanded) ??
      defaultExpanded

    if (!schema) {
      return null
    }

    const { showExtensions } = getConfigs()
    const extensions = showExtensions ? getExtensions(schema) : List()

    let description = schema.get("description")
    let properties = schema.get("properties")
    let additionalProperties = schema.get("additionalProperties")
    let title = schema.get("title") || displayName || name
    let requiredProperties = schema.get("required")
    let infoProperties = schema.filter(
      (v, key) =>
        ["maxProperties", "minProperties", "nullable", "example"].indexOf(
          key
        ) !== -1
    )
    let deprecated = schema.get("deprecated")
    let externalDocsUrl = schema.getIn(["externalDocs", "url"])
    let externalDocsDescription = schema.getIn(["externalDocs", "description"])

    const JumpToPath = getComponent("JumpToPath", true)
    const Markdown = getComponent("Markdown", true)
    const Model = getComponent("Model")
    const ModelCollapse = getComponent("ModelCollapse")
    const Property = getComponent("Property")
    const Link = getComponent("Link")
    const ModelExtensions = getComponent("ModelExtensions")

    const JumpToPathSection = () => {
      return (
        <span className="model-jump-to-path">
          <JumpToPath path={specPath} />
        </span>
      )
    }
    const collapsedContent = (
      <span>
        <span>{braceOpen}</span>...<span>{braceClose}</span>
        {isRef ? <JumpToPathSection /> : ""}
      </span>
    )

    const allOf = specSelectors.isOAS3() ? schema.get("allOf") : null
    const anyOf = specSelectors.isOAS3() ? schema.get("anyOf") : null
    const oneOf = specSelectors.isOAS3() ? schema.get("oneOf") : null
    const not = specSelectors.isOAS3() ? schema.get("not") : null

    const titleEl = title && (
      <strong className="model-title">
        {isRef && schema.get("$$ref") && (
          <span
            className={`${classNames("model-hint", {
              "model-hint--embedded": isEmbedded,
            })} hover:[.model-title_&]:block`}
          >
            {schema.get("$$ref")}
          </span>
        )}
        <span className="model-title__text">{title}</span>
      </strong>
    )

    return (
      <span className="model [&_.property.primitive]:text-[#6b6b6b] [&_.property.primitive.extension]:block [&_tr.property-row_td]:align-top [&_tr.property-row_td:first-child]:pr-[0.2em] [&_tr.property-row_.star]:text-[red] [&_tr.extension]:text-[#777] [&_tr.extension_td:last-child]:align-top [&_tr_.renderedMarkdown_p:first-child]:mt-0">
        <ModelCollapse
          modelName={name}
          title={titleEl}
          onToggle={this.handleToggle}
          expanded={isExpanded}
          collapsedContent={collapsedContent}
        >
          <span className="brace-open object">{braceOpen}</span>
          {!isRef ? null : <JumpToPathSection />}
          <span className="inner-object">
            {
              <Table className="model [&_.property.primitive]:text-[#6b6b6b] [&_.property.primitive.extension]:block [&_tr.property-row_td]:align-top [&_tr.property-row_td:first-child]:pr-[0.2em] [&_tr.property-row_.star]:text-[red] [&_tr.extension]:text-[#777] [&_tr.extension_td:last-child]:align-top [&_tr_.renderedMarkdown_p:first-child]:mt-0">
                <TableBody>
                  {!description ? null : (
                    <TableRow className="description text-[#666] font-normal">
                      <TableCell>description:</TableCell>
                      <TableCell>
                        <Markdown source={description} />
                      </TableCell>
                    </TableRow>
                  )}
                  {externalDocsUrl && (
                    <TableRow className={"external-docs"}>
                      <TableCell>externalDocs:</TableCell>
                      <TableCell>
                        <Link
                          target="_blank"
                          href={sanitizeUrl(externalDocsUrl)}
                        >
                          {externalDocsDescription || externalDocsUrl}
                        </Link>
                      </TableCell>
                    </TableRow>
                  )}
                  {!deprecated ? null : (
                    <TableRow className={"property"}>
                      <TableCell>deprecated:</TableCell>
                      <TableCell>true</TableCell>
                    </TableRow>
                  )}
                  {!(properties && properties.size)
                    ? null
                    : properties
                        .entrySeq()
                        .filter(([, value]) => {
                          return (
                            (!value.get("readOnly") || includeReadOnly) &&
                            (!value.get("writeOnly") || includeWriteOnly)
                          )
                        })
                        .map(([key, value]) => {
                          let isDeprecated = isOAS3() && value.get("deprecated")
                          let isRequired =
                            List.isList(requiredProperties) &&
                            requiredProperties.contains(key)

                          let classNames = ["property-row"]

                          if (isDeprecated) {
                            classNames.push("deprecated")
                          }

                          if (isRequired) {
                            classNames.push("required")
                          }

                          return (
                            <TableRow key={key} className={classNames.join(" ")}>
                              <TableCell>
                                {key}
                                {isRequired && <span className="star">*</span>}
                              </TableCell>
                              <TableCell>
                                <Model
                                  key={`object-${name}-${key}_${value}`}
                                  {...otherProps}
                                  required={isRequired}
                                  getComponent={getComponent}
                                  specPath={specPath.push("properties", key)}
                                  getConfigs={getConfigs}
                                  schema={value}
                                  depth={depth + 1}
                                />
                              </TableCell>
                            </TableRow>
                          )
                        })
                        .toArray()}
                  {extensions.size === 0 ? null : (
                    <>
                      <TableRow>
                        <TableCell>&nbsp;</TableCell>
                      </TableRow>
                      <ModelExtensions
                        extensions={extensions}
                        propClass="extension"
                      />
                    </>
                  )}
                  {!additionalProperties ||
                  !additionalProperties.size ? null : (
                    <TableRow>
                      <TableCell>{"< * >:"}</TableCell>
                      <TableCell>
                        <Model
                          {...otherProps}
                          required={false}
                          getComponent={getComponent}
                          specPath={specPath.push("additionalProperties")}
                          getConfigs={getConfigs}
                          schema={additionalProperties}
                          depth={depth + 1}
                        />
                      </TableCell>
                    </TableRow>
                  )}
                  {!allOf ? null : (
                    <TableRow>
                      <TableCell>{"allOf ->"}</TableCell>
                      <TableCell>
                        {allOf.map((schema, k) => {
                          return (
                            <div key={k}>
                              <Model
                                {...otherProps}
                                required={false}
                                getComponent={getComponent}
                                specPath={specPath.push("allOf", k)}
                                getConfigs={getConfigs}
                                schema={schema}
                                depth={depth + 1}
                              />
                            </div>
                          )
                        })}
                      </TableCell>
                    </TableRow>
                  )}
                  {!anyOf ? null : (
                    <TableRow>
                      <TableCell>{"anyOf ->"}</TableCell>
                      <TableCell>
                        {anyOf.map((schema, k) => {
                          return (
                            <div key={k}>
                              <Model
                                {...otherProps}
                                required={false}
                                getComponent={getComponent}
                                specPath={specPath.push("anyOf", k)}
                                getConfigs={getConfigs}
                                schema={schema}
                                depth={depth + 1}
                              />
                            </div>
                          )
                        })}
                      </TableCell>
                    </TableRow>
                  )}
                  {!oneOf ? null : (
                    <TableRow>
                      <TableCell>{"oneOf ->"}</TableCell>
                      <TableCell>
                        {oneOf.map((schema, k) => {
                          return (
                            <div key={k}>
                              <Model
                                {...otherProps}
                                required={false}
                                getComponent={getComponent}
                                specPath={specPath.push("oneOf", k)}
                                getConfigs={getConfigs}
                                schema={schema}
                                depth={depth + 1}
                              />
                            </div>
                          )
                        })}
                      </TableCell>
                    </TableRow>
                  )}
                  {!not ? null : (
                    <TableRow>
                      <TableCell>{"not ->"}</TableCell>
                      <TableCell>
                        <div>
                          <Model
                            {...otherProps}
                            required={false}
                            getComponent={getComponent}
                            specPath={specPath.push("not")}
                            getConfigs={getConfigs}
                            schema={not}
                            depth={depth + 1}
                          />
                        </div>
                      </TableCell>
                    </TableRow>
                  )}
                </TableBody>
              </Table>
            }
          </span>
          <span className="brace-close">{braceClose}</span>
        </ModelCollapse>
        {infoProperties.size
          ? infoProperties
              .entrySeq()
              .map(([key, v]) => (
                <Property
                  key={`${key}-${v}`}
                  propKey={key}
                  propVal={v}
                  propClass={propClass}
                />
              ))
          : null}
      </span>
    )
  }
}
