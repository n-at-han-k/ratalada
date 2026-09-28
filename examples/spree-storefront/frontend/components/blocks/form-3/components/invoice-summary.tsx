import { Badge } from "@/components/reui/badge"

import {
  InputGroup,
  InputGroupAddon,
  InputGroupInput,
} from "@/components/ui/input-group"
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

function DiscountPanelBackground() {
  return (
    <div
      className="pointer-events-none absolute inset-0 overflow-hidden"
      aria-hidden="true"
    >
      <div className="absolute inset-0 bg-[radial-gradient(ellipse_at_84%_12%,color-mix(in_oklch,var(--color-warning)_26%,transparent),transparent_34%),radial-gradient(circle_at_8%_96%,color-mix(in_oklch,var(--color-primary)_12%,transparent),transparent_30%),linear-gradient(135deg,color-mix(in_oklch,var(--color-warning)_7%,transparent),transparent_58%)]" />
      <div className="absolute inset-0 bg-[radial-gradient(circle,color-mix(in_oklch,var(--color-muted-foreground)_12%,transparent)_1px,transparent_1.6px)] [mask-image:linear-gradient(135deg,transparent_0%,black_22%,black_76%,transparent_100%)] bg-[length:20px_20px] opacity-35" />
      <svg
        viewBox="0 0 360 220"
        preserveAspectRatio="none"
        className="text-warning absolute inset-0 h-full w-full"
      >
        <path
          d="M236 8H331L360 37V126H236C225 126 216 117 216 106V28C216 17 225 8 236 8Z"
          fill="currentColor"
          opacity="0.12"
        />
        <path
          d="M331 8V37H360"
          fill="none"
          stroke="currentColor"
          strokeWidth="1.5"
          opacity="0.24"
        />
        <circle
          cx="326"
          cy="41"
          r="6.5"
          fill="var(--color-background)"
          opacity="0.88"
        />
        <g opacity="0.24">
          <circle
            cx="269"
            cy="56"
            r="15"
            fill="none"
            stroke="currentColor"
            strokeWidth="6.5"
          />
          <circle
            cx="315"
            cy="100"
            r="16"
            fill="none"
            stroke="currentColor"
            strokeWidth="6.5"
          />
          <path
            d="M251 116L333 37"
            fill="none"
            stroke="currentColor"
            strokeWidth="7.5"
            strokeLinecap="round"
          />
        </g>
        <path
          d="M147 41L156 59L175 68L156 77L147 96L138 77L119 68L138 59Z"
          fill="currentColor"
          opacity="0.12"
        />
        <path
          d="M201 145L207 157L219 163L207 169L201 181L195 169L183 163L195 157Z"
          fill="currentColor"
          opacity="0.1"
        />
        <circle cx="333" cy="162" r="42" fill="currentColor" opacity="0.07" />
        <circle cx="333" cy="162" r="18" fill="currentColor" opacity="0.09" />
        <path
          d="M-14 204C39 175 91 164 152 171C213 178 259 164 371 116V220H-14Z"
          fill="currentColor"
          opacity="0.07"
        />
      </svg>
      <div className="bg-background/90 absolute top-1/2 -right-2 size-4 rounded-full border shadow-xs" />
      <div className="bg-background/90 absolute right-16 -bottom-2 size-4 rounded-full border shadow-xs" />
    </div>
  )
}

export function InvoiceSummary({
  subtotal,
  discountPercent,
  discountAmount,
  taxAmount,
  total,
  currency,
  onDiscountChange,
}: {
  subtotal: number
  discountPercent: number
  discountAmount: number
  taxAmount: number
  total: number
  currency: string
  onDiscountChange: (value: number) => void
}) {
  return (
    <div className="grid gap-5 lg:grid-cols-[1fr_21rem] lg:items-start">
      <div className="flex min-w-0 flex-col gap-3">
        <div className="flex flex-wrap items-center gap-2">
          <Badge variant="info-light">
            <CircleCheckIcon aria-hidden="true" />
            Payment link queued
          </Badge>
          <Badge variant="outline">PDF preview ready</Badge>
        </div>
        <div className="text-muted-foreground flex min-w-0 flex-col gap-1 text-sm">
          <p>Payment link and PDF preview are prepared after sending.</p>
          <p>Totals update as items, taxes, and discounts change.</p>
        </div>
      </div>

      <div className="bg-background relative isolate overflow-hidden rounded-md border p-4 shadow-xs">
        <DiscountPanelBackground />

        <div className="relative flex flex-col gap-4">
          <div className="grid gap-3 sm:grid-cols-[1fr_8rem] sm:items-center">
            <div className="flex min-w-0 flex-col gap-0.5">
              <span className="text-sm font-medium">Invoice Discount</span>
              <span className="text-muted-foreground text-xs">
                Applied before tax calculation.
              </span>
            </div>
            <InputGroup className="bg-background/85">
              <InputGroupInput
                type="number"
                min={0}
                max={100}
                step={0.5}
                value={discountPercent}
                aria-label="Invoice discount percentage"
                onChange={(event) =>
                  onDiscountChange(Number(event.target.value) || 0)
                }
              />
              <InputGroupAddon align="inline-end">%</InputGroupAddon>
            </InputGroup>
          </div>

          <dl className="bg-background/70 grid gap-2.5 rounded-md border p-3 text-sm backdrop-blur-sm">
            <SummaryRow
              label="Subtotal"
              value={formatCurrency(subtotal, currency)}
            />
            <SummaryRow
              label="Discount"
              value={`-${formatCurrency(discountAmount, currency)}`}
            />
            <SummaryRow
              label="Tax"
              value={formatCurrency(taxAmount, currency)}
            />
            <SummaryRow
              label="Total Due"
              value={formatCurrency(total, currency)}
              strong
            />
          </dl>
        </div>
      </div>
    </div>
  )
}