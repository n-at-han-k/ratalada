import { Badge } from "@/components/reui/badge"

import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
  AlertDialogTrigger,
} from "@/components/ui/alert-dialog"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import {
  InputGroup,
  InputGroupAddon,
  InputGroupInput,
} from "@/components/ui/input-group"
import { ItemMedia } from "@/components/ui/item"
import {
  Select,
  SelectContent,
  SelectGroup,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select"
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table"
import { PO_PRODUCTS, PRODUCT_BY_ID, type PoLineItem } from "./data"
import { PackageIcon, Trash2Icon } from "lucide-react"

function formatCurrency(value: number) {
  return new Intl.NumberFormat("en-US", {
    style: "currency",
    currency: "USD",
  }).format(value)
}

function getLineTotal(line: PoLineItem) {
  return line.received * line.unitCost
}

export function PoLineItems({
  items,
  editable,
  onProductChange,
  onReceivedChange,
  onUnitCostChange,
  onRemoveItem,
}: {
  items: PoLineItem[]
  editable: boolean
  onProductChange: (id: string, productId: string) => void
  onReceivedChange: (id: string, received: number) => void
  onUnitCostChange: (id: string, unitCost: number) => void
  onRemoveItem: (id: string) => void
}) {
  return (
    <Table aria-label="Purchase order line items" className="min-w-[860px]">
      <TableHeader>
        <TableRow>
          <TableHead className="w-[34%]">Item</TableHead>
          <TableHead className="w-20 text-right">Ordered</TableHead>
          <TableHead className="w-28">Received</TableHead>
          <TableHead className="w-28">Backordered</TableHead>
          <TableHead className="w-32">Unit Cost</TableHead>
          <TableHead className="w-32 text-right">Line Total</TableHead>
          <TableHead className="w-10" />
        </TableRow>
      </TableHeader>
      <TableBody>
        {items.map((item) => {
          const product = PRODUCT_BY_ID.get(item.productId) ?? PO_PRODUCTS[0]
          const backordered = Math.max(item.ordered - item.received, 0)

          return (
            <TableRow key={item.id}>
              <TableCell className="align-middle">
                <div className="flex min-w-0 items-center gap-3">
                  {product.image ? (
                    <ItemMedia variant="image" className="size-11">
                      <img
                        src={product.image}
                        alt={product.name}
                        width={44}
                        height={44}
                        loading="lazy"
                        decoding="async"
                        className="size-full object-cover"
                      />
                    </ItemMedia>
                  ) : (
                    <ItemMedia
                      variant="icon"
                      className="text-muted-foreground size-11"
                      aria-hidden="true"
                    >
                      <PackageIcon
                      />
                    </ItemMedia>
                  )}
                  {editable ? (
                    <Select
                      value={item.productId}
                      onValueChange={(value) =>
                        value && onProductChange(item.id, value)
                      }
                    >
                      <SelectTrigger
                        aria-label={`Item for ${item.id}`}
                        className="min-w-0 flex-1"
                      >
                        <SelectValue>{product.name}</SelectValue>
                      </SelectTrigger>
                      <SelectContent className="w-(--anchor-width)">
                        <SelectGroup>
                          {PO_PRODUCTS.map((productOption) => (
                            <SelectItem
                              key={productOption.id}
                              value={productOption.id}
                            >
                              {productOption.name}
                            </SelectItem>
                          ))}
                        </SelectGroup>
                      </SelectContent>
                    </Select>
                  ) : (
                    <div className="flex min-w-0 flex-col">
                      <span className="truncate text-sm font-medium">
                        {product.name}
                      </span>
                      <span className="text-muted-foreground truncate text-xs tabular-nums">
                        {product.sku}
                      </span>
                    </div>
                  )}
                </div>
              </TableCell>
              <TableCell className="text-right align-middle tabular-nums">
                {item.ordered}
              </TableCell>
              <TableCell className="align-middle">
                <Input
                  type="number"
                  min={0}
                  max={item.ordered}
                  step={1}
                  value={item.received}
                  aria-label={`Received quantity for ${product.name}`}
                  className="w-24"
                  onChange={(event) =>
                    onReceivedChange(item.id, Number(event.target.value) || 0)
                  }
                />
              </TableCell>
              <TableCell className="align-middle">
                {backordered > 0 ? (
                  <Badge variant="destructive-light" className="tabular-nums">
                    {backordered}
                  </Badge>
                ) : (
                  <Badge variant="success-light">Filled</Badge>
                )}
              </TableCell>
              <TableCell className="align-middle">
                <InputGroup className="min-w-28">
                  <InputGroupAddon>$</InputGroupAddon>
                  <InputGroupInput
                    type="number"
                    min={0}
                    step={1}
                    value={item.unitCost}
                    disabled={!editable}
                    aria-label={`Unit cost for ${product.name}`}
                    onChange={(event) =>
                      onUnitCostChange(item.id, Number(event.target.value) || 0)
                    }
                  />
                </InputGroup>
              </TableCell>
              <TableCell className="text-right align-middle font-medium tabular-nums">
                <span className="inline-flex min-h-9 items-center justify-end">
                  {formatCurrency(getLineTotal(item))}
                </span>
              </TableCell>
              <TableCell className="align-middle">
                <AlertDialog>
                  <AlertDialogTrigger
                    render={
                      <Button
                        type="button"
                        variant="ghost"
                        size="icon-sm"
                        aria-label={`Remove ${product.name}`}
                        disabled={!editable || items.length === 1}
                      />
                    }
                  >
                    <Trash2Icon aria-hidden="true" />
                  </AlertDialogTrigger>
                  <AlertDialogContent size="sm">
                    <AlertDialogHeader>
                      <AlertDialogTitle>Remove Line Item?</AlertDialogTitle>
                      <AlertDialogDescription>
                        <span className="text-foreground font-medium">
                          {product.name}
                        </span>{" "}
                        will be removed from this order.
                      </AlertDialogDescription>
                    </AlertDialogHeader>
                    <AlertDialogFooter>
                      <AlertDialogCancel>Cancel</AlertDialogCancel>
                      <AlertDialogAction
                        variant="destructive"
                        onClick={() => onRemoveItem(item.id)}
                      >
                        Remove Item
                      </AlertDialogAction>
                    </AlertDialogFooter>
                  </AlertDialogContent>
                </AlertDialog>
              </TableCell>
            </TableRow>
          )
        })}
      </TableBody>
    </Table>
  )
}