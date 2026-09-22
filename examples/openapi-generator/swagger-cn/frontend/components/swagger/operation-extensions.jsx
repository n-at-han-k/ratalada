import React from "react"
import PropTypes from "prop-types"
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table"

export const OperationExt = ({ extensions, getComponent }) => {
    let OperationExtRow = getComponent("OperationExtRow")
    return (
      <div className="opblock-section">
        <div className="opblock-section-header">
          <h4>Extensions</h4>
        </div>
        <div className="p-5">

          <Table>
            <TableHeader>
              <TableRow>
                <TableCell className="col_header">Field</TableCell>
                <TableCell className="col_header">Value</TableCell>
              </TableRow>
            </TableHeader>
            <TableBody>
                {
                    extensions.entrySeq().map(([k, v]) => <OperationExtRow key={`${k}-${v}`} xKey={k} xVal={v} />)
                }
            </TableBody>
          </Table>
        </div>
      </div>
    )
}
OperationExt.propTypes = {
  extensions: PropTypes.object.isRequired,
  getComponent: PropTypes.func.isRequired
}

export default OperationExt
