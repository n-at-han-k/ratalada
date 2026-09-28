import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import {
  InputGroup,
  InputGroupAddon,
  InputGroupInput,
} from "@/components/ui/input-group"
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
import {
  Tooltip,
  TooltipContent,
  TooltipTrigger,
} from "@/components/ui/tooltip"
import {
  INVOICE_PRODUCTS,
  PRODUCT_BY_ID,
  TAX_RATE_OPTIONS,
  type InvoiceLineItem,
} from "./data"
import { InfoIcon, Trash2Icon } from "lucide-react"

function formatCurrency(value: number, currency: string) {
  return new Intl.NumberFormat("en-US", {
    style: "currency",
    currency: currency.toUpperCase(),
  }).format(value)
}

function getLineTotal(line: InvoiceLineItem) {
  return line.quantity * line.unitPrice
}

function ProductDescriptionTooltip({
  name,
  description,
}: {
  name: string
  description: string
}) {
  return (
    <Tooltip>
      <TooltipTrigger
        render={
          <Button
            type="button"
            variant="ghost"
            size="icon-xs"
            className="text-muted-foreground hover:text-foreground shrink-0"
            aria-label={`${name} details`}
          />
        }
      >
        <InfoIcon aria-hidden="true" />
      </TooltipTrigger>
      <TooltipContent side="top" className="max-w-64 text-xs leading-relaxed">
        {description}
      </TooltipContent>
    </Tooltip>
  )
}

export function InvoiceLineItems({
  items,
  onProductChange,
  onQuantityChange,
  onUnitPriceChange,
  onTaxRateChange,
  onRemoveItem,
  currency,
}: {
  items: InvoiceLineItem[]
  currency: string
  onProductChange: (id: string, productId: string) => void
  onQuantityChange: (id: string, quantity: number) => void
  onUnitPriceChange: (id: string, unitPrice: number) => void
  onTaxRateChange: (id: string, taxRate: string) => void
  onRemoveItem: (id: string) => void
}) {
  return (
    <Table aria-label="Invoice line items" className="min-w-[820px]">
      <TableHeader>
        <TableRow>
          <TableHead className="w-[42%]">Item</TableHead>
          <TableHead className="w-24">Qty</TableHead>
          <TableHead className="w-36">Rate</TableHead>
          <TableHead className="w-32">Tax</TableHead>
          <TableHead className="w-32 text-right">Amount</TableHead>
          <TableHead className="w-10" />
        </TableRow>
      </TableHeader>
      <TableBody>
        {items.map((item) => {
          const product =
            PRODUCT_BY_ID.get(item.productId) ?? INVOICE_PRODUCTS[0]

          return (
            <TableRow key={item.id}>
              <TableCell className="align-middle">
                <div className="flex min-w-0 items-center gap-2">
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
                        {INVOICE_PRODUCTS.map((productOption) => (
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
                  <ProductDescriptionTooltip
                    name={product.name}
                    description={product.description}
                  />
                </div>
              </TableCell>
              <TableCell className="align-middle">
                <Input
                  type="number"
                  min={1}
                  step={1}
                  value={item.quantity}
                  aria-label={`Quantity for ${product.name}`}
                  className="w-20"
                  onChange={(event) =>
                    onQuantityChange(item.id, Number(event.target.value) || 1)
                  }
                />
              </TableCell>
              <TableCell className="align-middle">
                <InputGroup className="min-w-28">
                  <InputGroupAddon>$</InputGroupAddon>
                  <InputGroupInput
                    type="number"
                    min={0}
                    step={50}
                    value={item.unitPrice}
                    aria-label={`Rate for ${product.name}`}
                    onChange={(event) =>
                      onUnitPriceChange(
                        item.id,
                        Number(event.target.value) || 0
                      )
                    }
                  />
                </InputGroup>
              </TableCell>
              <TableCell className="align-middle">
                <Select
                  value={item.taxRate}
                  onValueChange={(value) =>
                    value && onTaxRateChange(item.id, value)
                  }
                >
                  <SelectTrigger
                    aria-label={`Tax rate for ${product.name}`}
                    className="min-w-24"
                  >
                    <SelectValue>
                      {TAX_RATE_OPTIONS.find(
                        (option) => option.value === item.taxRate
                      )?.label ?? item.taxRate}
                    </SelectValue>
                  </SelectTrigger>
                  <SelectContent>
                    <SelectGroup>
                      {TAX_RATE_OPTIONS.map((option) => (
                        <SelectItem key={option.value} value={option.value}>
                          {option.label}
                        </SelectItem>
                      ))}
                    </SelectGroup>
                  </SelectContent>
                </Select>
              </TableCell>
              <TableCell className="text-right align-middle font-medium tabular-nums">
                <span className="inline-flex min-h-9 items-center justify-end">
                  {formatCurrency(getLineTotal(item), currency)}
                </span>
              </TableCell>
              <TableCell className="align-middle">
                <Button
                  type="button"
                  variant="ghost"
                  size="icon-sm"
                  aria-label={`Remove ${product.name}`}
                  disabled={items.length === 1}
                  onClick={() => onRemoveItem(item.id)}
                >
                  <Trash2Icon aria-hidden="true" />
                </Button>
              </TableCell>
            </TableRow>
          )
        })}
      </TableBody>
    </Table>
  )
}