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

export const OperationExtRow = ({ xKey, xVal }) => {
  const xNormalizedValue = !xVal ? null : xVal.toJS ? xVal.toJS() : xVal

    return (<TableRow>
        <TableCell>{ xKey }</TableCell>
        <TableCell>{ JSON.stringify(xNormalizedValue) }</TableCell>
    </TableRow>)
}
OperationExtRow.propTypes = {
  xKey: PropTypes.string,
  xVal: PropTypes.any
}

export default OperationExtRow
