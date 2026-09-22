/**
 * @prettier
 */
import React from "react"
import classNames from "classnames"

import { schema } from "@/lib/swagger/plugins/json-schema-2020-12/prop-types"
import { useFn, useComponent, usePath } from "@/lib/swagger/plugins/json-schema-2020-12/hooks"
import { JSONSchemaPathContext } from "@/lib/swagger/plugins/json-schema-2020-12/context"

const Properties = ({ schema }) => {
  const fn = useFn()
  const properties = schema?.properties || {}
  const required = Array.isArray(schema?.required) ? schema.required : []
  const JSONSchema = useComponent("JSONSchema")
  const { path } = usePath("properties")

  /**
   * Rendering.
   */
  if (Object.keys(properties).length === 0) {
    return null
  }

  return (
    <JSONSchemaPathContext.Provider value={path}>
      <div className="mx-0 mt-[5px] mb-[5px] json-schema-2020-12-keyword--properties">
        <ul>
          {Object.entries(properties).map(([propertyName, propertySchema]) => {
            const isRequired = required.includes(propertyName)
            const dependentRequired = fn.getDependentRequired(
              propertyName,
              schema
            )

            return (
              <li
                key={propertyName}
                className={classNames("json-schema-2020-12-property", {
                  "json-schema-2020-12-property--required": isRequired,
                })}
              >
                <JSONSchema
                  name={propertyName}
                  schema={propertySchema}
                  dependentRequired={dependentRequired}
                />
              </li>
            )
          })}
        </ul>
      </div>
    </JSONSchemaPathContext.Provider>
  )
}

Properties.propTypes = {
  schema: schema.isRequired,
}

export default Properties
