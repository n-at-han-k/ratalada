import React from "react"
import PropTypes from "prop-types"
import { Map } from "immutable"
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table"

const propClass = "header-example"

export default class Headers extends React.Component {
  static propTypes = {
    headers: PropTypes.object.isRequired,
    getComponent: PropTypes.func.isRequired
  }

  render() {
    let { headers, getComponent } = this.props

    const Property = getComponent("Property")
    const Markdown = getComponent("Markdown", true)

    if ( !headers || !headers.size )
      return null

      return (
      <div className="headers-wrapper">
        <h4 className="headers__title">Headers:</h4>
        <Table className="headers [&_.header-example]:italic [&_.header-example]:text-[#999]">
          <TableHeader>
            <TableRow className="header-row">
              <TableHead className="header-col">Name</TableHead>
              <TableHead className="header-col">Description</TableHead>
              <TableHead className="header-col">Type</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
          {
            headers.entrySeq().map( ([ key, header ]) => {
              if(!Map.isMap(header)) {
                return null
              }

              const description = header.get("description")
              const type = header.getIn(["schema"]) ? header.getIn(["schema", "type"]) : header.getIn(["type"])
              const schemaExample = header.getIn(["schema", "example"])

              return (<TableRow key={ key }>
                <TableCell className="header-col">{ key }</TableCell>
                <TableCell className="header-col">{
                  !description ? null : <Markdown source={ description } />
                }</TableCell>
                <TableCell className="header-col">{ type } { schemaExample ? <Property propKey={ "Example" } propVal={ schemaExample } propClass={ propClass } /> : null }</TableCell>
              </TableRow>)
            }).toArray()
          }
          </TableBody>
        </Table>
      </div>
    )
  }
}
