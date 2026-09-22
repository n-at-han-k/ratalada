/**
 * @prettier
 */
import React from "react"
import PropTypes from "prop-types"
import { immutableToJS } from "@/lib/swagger/utils/index"
import ImPropTypes from "react-immutable-proptypes"
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table"

export const ModelExtensions = ({ extensions, propClass = "" }) => {
  return extensions
    .entrySeq()
    .map(([key, value]) => {
      const normalizedValue = immutableToJS(value) ?? null

      return (
        <TableRow key={key} className={propClass}>
          <TableCell>{key}</TableCell>
          <TableCell>{JSON.stringify(normalizedValue)}</TableCell>
        </TableRow>
      )
    })
    .toArray()
}

ModelExtensions.propTypes = {
  extensions: ImPropTypes.map.isRequired,
  propClass: PropTypes.string,
}
