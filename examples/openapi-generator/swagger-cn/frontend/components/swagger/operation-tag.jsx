import React from "react"
import PropTypes from "prop-types"
import ImPropTypes from "react-immutable-proptypes"
import { fromJS } from "immutable"
import { createDeepLinkPath, escapeDeepLinkPath, isFunc } from "@/lib/swagger/utils/index"
import { safeBuildUrl, sanitizeUrl } from "@/lib/swagger/utils/url"

/* eslint-disable  react/jsx-no-bind */

export default class OperationTag extends React.Component {

  static defaultProps = {
    tagObj: fromJS({}),
    tag: "",
  }

  static propTypes = {
    tagObj: ImPropTypes.map.isRequired,
    tag: PropTypes.string.isRequired,

    oas3Selectors: PropTypes.func.isRequired,
    layoutSelectors: PropTypes.object.isRequired,
    layoutActions: PropTypes.object.isRequired,

    getConfigs: PropTypes.func.isRequired,
    getComponent: PropTypes.func.isRequired,

    specUrl: PropTypes.string.isRequired,

    children: PropTypes.element,
  }

  render() {
    const {
      tagObj,
      tag,
      children,
      oas3Selectors,
      layoutSelectors,
      layoutActions,
      getConfigs,
      getComponent,
      specUrl,
    } = this.props

    let {
      docExpansion,
      deepLinking,
    } = getConfigs()

    const Markdown = getComponent("Markdown", true)
    const DeepLink = getComponent("DeepLink")
    const Link = getComponent("Link")

    let tagDescription = tagObj.getIn(["tagDetails", "description"], null)
    let tagExternalDocsDescription = tagObj.getIn(["tagDetails", "externalDocs", "description"])
    let rawTagExternalDocsUrl = tagObj.getIn(["tagDetails", "externalDocs", "url"])
    let tagExternalDocsUrl
    if (isFunc(oas3Selectors) && isFunc(oas3Selectors.selectedServer)) {
      tagExternalDocsUrl = safeBuildUrl(rawTagExternalDocsUrl, specUrl, { selectedServer: oas3Selectors.selectedServer() })
    } else {
      tagExternalDocsUrl = rawTagExternalDocsUrl
    }

    let isShownKey = ["operations-tag", tag]
    let showTag = layoutSelectors.isShown(isShownKey, docExpansion === "full" || docExpansion === "list")

    // The tag header: name, description, external docs. The expand button
    // and its arrow icons are gone -- the accordion trigger this sits inside
    // is the control, and it draws its own chevron.
    const header = (
      <div
        className="flex flex-1 flex-wrap items-baseline gap-x-3 gap-y-1 py-3"
        id={isShownKey.map((v) => escapeDeepLinkPath(v)).join("-")}
        data-tag={tag}
        data-is-open={showTag}
      >
        <DeepLink
          enabled={deepLinking}
          path={createDeepLinkPath(tag)}
          text={tag}
          className="text-lg font-semibold"
        />

        {tagDescription && (
          <span className="text-muted-foreground text-sm">
            <Markdown source={tagDescription} />
          </span>
        )}

        {tagExternalDocsUrl && (
          <span className="ml-auto text-sm">
            <Link
              href={sanitizeUrl(tagExternalDocsUrl)}
              onClick={(e) => e.stopPropagation()}
              target="_blank"
              className="text-primary underline underline-offset-4"
            >
              {tagExternalDocsDescription || tagExternalDocsUrl}
            </Link>
          </span>
        )}
      </div>
    )

    // Virtualized path — render only the header
    if (children == null) {
      return header
    }

    const value = isShownKey.map((v) => escapeDeepLinkPath(v)).join("-")

    return (
      <Accordion
        multiple
        value={showTag ? [value] : []}
        onValueChange={(next) => layoutActions.show(isShownKey, next.includes(value))}
        className="border-0"
      >
        <AccordionItem
          value={value}
          className={showTag ? "opblock-tag-section is-open border-0" : "opblock-tag-section border-0"}
        >
          {/* `render` makes the trigger a div: the header carries its own
              links and buttons, and a button cannot contain one. */}
          <AccordionTrigger render={<div />}
            nativeButton={false} className="px-0 py-0 hover:no-underline w-full [&>*:first-child]:flex-1 [&>*:first-child]:w-full">
            {header}
          </AccordionTrigger>
          <AccordionContent className="px-0 pt-0 pb-0">
            {children}
          </AccordionContent>
        </AccordionItem>
      </Accordion>
    )
  }
}
