/**
 * @prettier
 */
import React, { useCallback } from "react"
import classNames from "classnames"

import { schema } from "@/lib/swagger/plugins/json-schema-2020-12/prop-types"

import {
  useComponent,
  useIsExpanded,
  useFn,
  usePath,
  useLevel,
  useConfig,
} from "@/lib/swagger/plugins/json-schema-2020-12/hooks"
import { JSONSchemaLevelContext, JSONSchemaPathContext } from "@/lib/swagger/plugins/json-schema-2020-12/context"

const ExtensionKeywords = ({ schema }) => {
  const fn = useFn()
  const pathToken = "ExtensionKeywords"
  const { path } = usePath(pathToken)
  const { isExpanded, setExpanded, setCollapsed } = useIsExpanded(pathToken)
  const [level, nextLevel] = useLevel()
  const Accordion = useComponent("Accordion")
  const ExpandDeepButton = useComponent("ExpandDeepButton")
  const JSONViewer = useComponent("JSONViewer")
  const { showExtensionKeywords } = useConfig("showExtensionKeywords")
  const extensionKeywords = fn.getExtensionKeywords(schema)

  /**
   * Event handlers.
   */
  const handleExpansion = useCallback(() => {
    if (isExpanded) {
      setCollapsed()
    } else {
      setExpanded()
    }
  }, [isExpanded, setExpanded, setCollapsed])
  const handleExpansionDeep = useCallback(
    (e, expandedDeepNew) => {
      if (expandedDeepNew) {
        setExpanded({ deep: true })
      } else {
        setCollapsed({ deep: true })
      }
    },
    [setExpanded, setCollapsed]
  )

  /**
   * Rendering.
   */
  if (!showExtensionKeywords || extensionKeywords.length === 0) {
    return null
  }

  return (
    <JSONSchemaPathContext.Provider value={path}>
      <JSONSchemaLevelContext.Provider value={nextLevel}>
        <div
          className="mx-0 mt-[5px] mb-[5px] json-schema-2020-12-keyword--extension-keywords"
          data-json-schema-level={level}
        >
          <Accordion expanded={isExpanded} onChange={handleExpansion}>
            <span className="json-schema-2020-12-keyword__name italic text-[#929292]">
              Extension Keywords
            </span>
          </Accordion>
          <ExpandDeepButton
            expanded={isExpanded}
            onClick={handleExpansionDeep}
          />
          <ul
            className={classNames("json-schema-2020-12-keyword__children", {
              "json-schema-2020-12-keyword__children--collapsed": !isExpanded,
            })}
          >
            {isExpanded && (
              <>
                {extensionKeywords.map((keyword) => (
                  <JSONViewer
                    key={keyword}
                    name={keyword}
                    value={schema[keyword]}
                    className="json-schema-2020-12-json-viewer-extension-keyword"
                  />
                ))}
              </>
            )}
          </ul>
        </div>
      </JSONSchemaLevelContext.Provider>
    </JSONSchemaPathContext.Provider>
  )
}

ExtensionKeywords.propTypes = {
  schema: schema.isRequired,
}

export default ExtensionKeywords
