/**
 * @prettier
 */
import React, { useCallback } from "react"
import classNames from "classnames"

import { schema } from "@/lib/swagger/plugins/json-schema-2020-12/prop-types"
import { useComponent, useIsExpanded, useLevel, usePath } from "@/lib/swagger/plugins/json-schema-2020-12/hooks"
import { JSONSchemaLevelContext, JSONSchemaPathContext } from "@/lib/swagger/plugins/json-schema-2020-12/context"

const DependentSchemas = ({ schema }) => {
  const dependentSchemas = schema?.dependentSchemas || []
  const pathToken = "dependentSchemas"
  const { path } = usePath(pathToken)
  const { isExpanded, setExpanded, setCollapsed } = useIsExpanded(pathToken)
  const [level, nextLevel] = useLevel()
  const Accordion = useComponent("Accordion")
  const ExpandDeepButton = useComponent("ExpandDeepButton")
  const JSONSchema = useComponent("JSONSchema")

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
  if (typeof dependentSchemas !== "object") return null
  if (Object.keys(dependentSchemas).length === 0) return null

  return (
    <JSONSchemaPathContext.Provider value={path}>
      <JSONSchemaLevelContext.Provider value={nextLevel}>
        <div
          className="mx-0 mt-[5px] mb-[5px] json-schema-2020-12-keyword--dependentSchemas"
          data-json-schema-level={level}
        >
          <Accordion expanded={isExpanded} onChange={handleExpansion}>
            <span className="json-schema-2020-12-keyword__name json-schema-2020-12-keyword__name--primary">
              Dependent schemas
            </span>
          </Accordion>
          <ExpandDeepButton
            expanded={isExpanded}
            onClick={handleExpansionDeep}
          />
          <strong className="lowercase font-[monospace] text-[#3b4151] text-[12px] pl-2.5 json-schema-2020-12__attribute--primary">
            object
          </strong>
          <ul
            className={classNames("json-schema-2020-12-keyword__children", {
              "json-schema-2020-12-keyword__children--collapsed": !isExpanded,
            })}
          >
            {isExpanded && (
              <>
                {Object.entries(dependentSchemas).map(
                  ([schemaName, schema]) => (
                    <li
                      key={schemaName}
                      className="json-schema-2020-12-property"
                    >
                      <JSONSchema name={schemaName} schema={schema} />
                    </li>
                  )
                )}
              </>
            )}
          </ul>
        </div>
      </JSONSchemaLevelContext.Provider>
    </JSONSchemaPathContext.Provider>
  )
}

DependentSchemas.propTypes = {
  schema: schema.isRequired,
}

export default DependentSchemas
