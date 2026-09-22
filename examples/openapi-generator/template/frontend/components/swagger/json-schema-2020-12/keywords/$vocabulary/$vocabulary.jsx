/**
 * @prettier
 */
import React, { useCallback } from "react"
import classNames from "classnames"

import { schema } from "@/lib/swagger/plugins/json-schema-2020-12/prop-types"
import { useComponent, useIsExpanded, usePath } from "@/lib/swagger/plugins/json-schema-2020-12/hooks"
import { JSONSchemaPathContext } from "@/lib/swagger/plugins/json-schema-2020-12/context"

const $vocabulary = ({ schema }) => {
  const pathToken = "$vocabulary"
  const { path } = usePath(pathToken)
  const { isExpanded, setExpanded, setCollapsed } = useIsExpanded(pathToken)
  const Accordion = useComponent("Accordion")

  const handleExpansion = useCallback(() => {
    if (isExpanded) {
      setCollapsed()
    } else {
      setExpanded()
    }
  }, [isExpanded, setExpanded, setCollapsed])

  /**
   * Rendering.
   */
  if (!schema?.$vocabulary) return null
  if (typeof schema.$vocabulary !== "object") return null

  return (
    <JSONSchemaPathContext.Provider value={path}>
      <div className="mx-0 mt-[5px] mb-[5px] json-schema-2020-12-keyword--$vocabulary">
        <Accordion expanded={isExpanded} onChange={handleExpansion}>
          <span className="json-schema-2020-12-keyword__name json-schema-2020-12-keyword__name--secondary">
            $vocabulary
          </span>
        </Accordion>
        <strong className="lowercase font-[monospace] text-[#3b4151] text-[12px] pl-2.5 json-schema-2020-12__attribute--primary">
          object
        </strong>
        <ul>
          {isExpanded &&
            Object.entries(schema.$vocabulary).map(([uri, enabled]) => (
              <li
                key={uri}
                className={classNames("json-schema-2020-12-$vocabulary-uri", {
                  "json-schema-2020-12-$vocabulary-uri--disabled": !enabled,
                })}
              >
                <span className="italic text-[#6b6b6b] text-[12px] font-normal json-schema-2020-12-keyword__value--secondary">
                  {uri}
                </span>
              </li>
            ))}
        </ul>
      </div>
    </JSONSchemaPathContext.Provider>
  )
}

$vocabulary.propTypes = {
  schema: schema.isRequired,
}

export default $vocabulary
