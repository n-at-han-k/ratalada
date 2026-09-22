/**
 * @prettier
 */
import React, { useCallback, useEffect } from "react"
import { OrderedMap } from "immutable"
import PropTypes from "prop-types"
import ImPropTypes from "react-immutable-proptypes"
import { Select } from "@/components/select"
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table"

const Servers = ({
  servers,
  currentServer,
  setSelectedServer,
  setServerVariableValue,
  getServerVariable,
  getEffectiveServerValue,
}) => {
  const currentServerDefinition =
    servers.find((s) => s.get("url") === currentServer) || OrderedMap()
  const currentServerVariableDefs =
    currentServerDefinition.get("variables") || OrderedMap()
  const shouldShowVariableUI = currentServerVariableDefs.size !== 0

  useEffect(() => {
    if (currentServer) return

    // fire 'change' event to set default 'value' of select
    setSelectedServer(servers.first()?.get("url"))
  }, [])

  useEffect(() => {
    // server has changed, we may need to set default values
    const currentServerDefinition = servers.find(
      (server) => server.get("url") === currentServer
    )
    if (!currentServerDefinition) {
      setSelectedServer(servers.first().get("url"))
      return
    }

    const currentServerVariableDefs =
      currentServerDefinition.get("variables") || OrderedMap()
    currentServerVariableDefs.map((val, key) => {
      setServerVariableValue({
        server: currentServer,
        key,
        val: val.get("default") || "",
      })
    })
  }, [currentServer, servers])

  const handleServerChange = useCallback(
    (value) => {
      setSelectedServer(value)
    },
    [setSelectedServer]
  )

  const handleServerVariableChange = useCallback(
    (e) => {
      const variableName = e.target.getAttribute("data-variable")
      const newVariableValue = e.target.value

      setServerVariableValue({
        server: currentServer,
        key: variableName,
        val: newVariableValue,
      })
    },
    [setServerVariableValue, currentServer]
  )

  return (
    <div className="servers [&_h4.message]:pb-[2em] [&_table_td:first-of-type]:pr-[1em]">
      <label htmlFor="servers">
        <Select
          id="servers"
          onChange={handleServerChange}
          value={currentServer}
          allowEmptyValue={false}
          allowedValues={servers.valueSeq().map((s) => s.get("url")).toArray()}
        />
      </label>
      {shouldShowVariableUI && (
        <div>
          <div className={"computed-url"}>
            Computed URL:
            <code>{getEffectiveServerValue(currentServer)}</code>
          </div>
          <h4>Server variables</h4>
          <Table>
            <TableBody>
              {currentServerVariableDefs.entrySeq().map(([name, val]) => {
                return (
                  <TableRow key={name}>
                    <TableCell>{name}</TableCell>
                    <TableCell>
                      {val.get("enum") ? (
                        <Select
                          allowEmptyValue={false}
                          value={getServerVariable(currentServer, name) || ""}
                          allowedValues={val.get("enum").toArray()}
                          onChange={(value) =>
                            handleServerVariableChange({
                              target: { value, getAttribute: () => name },
                            })
                          }
                        />
                      ) : (
                        <input
                          type={"text"}
                          value={getServerVariable(currentServer, name) || ""}
                          onChange={handleServerVariableChange}
                          data-variable={name}
                        ></input>
                      )}
                    </TableCell>
                  </TableRow>
                )
              })}
            </TableBody>
          </Table>
        </div>
      )}
    </div>
  )
}
Servers.propTypes = {
  servers: ImPropTypes.list.isRequired,
  currentServer: PropTypes.string.isRequired,
  setSelectedServer: PropTypes.func.isRequired,
  setServerVariableValue: PropTypes.func.isRequired,
  getServerVariable: PropTypes.func.isRequired,
  getEffectiveServerValue: PropTypes.func.isRequired,
}

export default Servers
