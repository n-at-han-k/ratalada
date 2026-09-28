import { Badge } from "@/components/reui/badge"

import {
  InputGroup,
  InputGroupAddon,
  InputGroupInput,
} from "@/components/ui/input-group"
import { Item } from "@/components/ui/item"
import { Separator } from "@/components/ui/separator"
import { CircleCheckIcon } from "lucide-react"

function formatCurrency(value: number, currency: string) {
  return new Intl.NumberFormat("en-US", {
    style: "currency",
    currency: currency.toUpperCase(),
  }).format(value)
}

function SummaryRow({
  label,
  value,
  strong,
}: {
  label: string
  value: string
  strong?: boolean
}) {
  return (
    <div className="flex items-center justify-between gap-4">
      <dt className={strong ? "text-foreground font-medium" : undefined}>
        {label}
      </dt>
      <dd
        className={
          strong
            ? "text-foreground text-base font-semibold tabular-nums"
            : "text-foreground tabular-nums"
        }
      >
        {value}
      </dd>
    </div>
  )
}

export function PoSummary({
  subtotal,
  freight,
  taxAmount,
  total,
  receivedValue,
  editable,
  onFreightChange,
}: {
  subtotal: number
  freight: number
  taxAmount: number
  total: number
  receivedValue: number
  editable: boolean
  onFreightChange: (value: number) => void
}) {
  return (
    <div className="grid gap-5 lg:grid-cols-[1fr_21rem] lg:items-start">
      <div className="flex min-w-0 flex-col gap-3">
        <div className="flex flex-wrap items-center gap-2">
          <Badge variant="info-light">
            <CircleCheckIcon aria-hidden="true" />
            {formatCurrency(receivedValue, "usd")} received
          </Badge>
          <Badge variant="outline" className="gap-1.5">
            <span>Average Cost</span>
            <span
              aria-hidden="true"
              className="bg-muted-foreground/40 size-1 shrink-0 rounded-full"
            />
            <span>Main Warehouse</span>
          </Badge>
        </div>
        <div className="text-muted-foreground flex min-w-0 flex-col gap-1 text-sm">
          <p>Dock scans post received value.</p>
          <p>Tax includes freight, due Jun 19.</p>
        </div>
      </div>

      <Item variant="outline" className="flex-col items-stretch gap-4 p-4">
        <div className="grid gap-3 sm:grid-cols-[1fr_auto] sm:items-center">
          <div className="flex min-w-0 flex-col gap-0.5">
            <span className="text-sm font-medium">Freight</span>
            <span className="text-muted-foreground text-xs">
              Added before tax.
            </span>
          </div>

          {editable ? (
            <InputGroup className="w-full sm:w-40">
              <InputGroupAddon>$</InputGroupAddon>
              <InputGroupInput
                type="number"
                min={0}
                step={10}
                value={freight}
                aria-label="Freight cost"
                className="text-right font-semibold tabular-nums"
                onChange={(event) =>
                  onFreightChange(Number(event.target.value) || 0)
                }
              />
            </InputGroup>
          ) : (
            <div className="flex min-w-32 flex-col items-start sm:items-end">
              <span className="text-foreground text-lg leading-none font-semibold tabular-nums">
                {formatCurrency(freight, "usd")}
              </span>
              <span className="text-muted-foreground mt-1 text-xs">Locked</span>
            </div>
          )}
        </div>

        <Separator />

        <dl className="grid gap-2.5 text-sm">
          <SummaryRow
            label="Subtotal"
            value={formatCurrency(subtotal, "usd")}
          />
          <SummaryRow label="Freight" value={formatCurrency(freight, "usd")} />
          <SummaryRow label="Tax" value={formatCurrency(taxAmount, "usd")} />
          <SummaryRow
            label="Total"
            value={formatCurrency(total, "usd")}
            strong
          />
        </dl>
      </Item>
    </div>
  )
}