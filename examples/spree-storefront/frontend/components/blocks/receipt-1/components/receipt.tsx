"use client"

import { Badge } from "@/components/reui/badge"
import { cn } from "cn"

import { Button } from "@/components/ui/button"
import {
  Card,
  CardContent,
  CardDescription,
  CardFooter,
  CardHeader,
  CardTitle,
} from "@/components/ui/card"
import { Item, ItemMedia } from "@/components/ui/item"
import { Separator } from "@/components/ui/separator"
import {
  BILL_TO,
  ECOMMERCE_LINK_CLASS_NAME,
  ITEMS,
  ORDER,
  PAYMENT,
  SHIP_TO,
  SHIPMENT,
  SHOP,
  TOTALS,
  type Address,
  type ReceiptItem,
  type ReceiptTotals,
} from "./data"
import { DownloadIcon, MailIcon, PrinterIcon, CircleCheckIcon, TruckIcon, ArrowRightIcon, LifeBuoyIcon, CreditCardIcon } from "lucide-react"

// ─────────────────────────────────────────────────────────────────────────
// Receipt. Single-column printable receipt for a completed ecommerce
// order. Top of the page carries the brand + Download / Email / Print
// actions; the Card below holds the receipt content: order header strip
// (status badge, receipt number, date), a 3-up Ship To / Bill To /
// Payment grid, the itemized line items, a right-aligned totals block,
// and a footer with the shipment estimate plus a support link.
// ─────────────────────────────────────────────────────────────────────────

function formatCurrency(amount: number, currency: ReceiptTotals["currency"]) {
  return new Intl.NumberFormat("en-US", {
    style: "currency",
    currency,
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  }).format(amount)
}

function dispatchReceiptAction(action: "download" | "email" | "print") {
  if (typeof window === "undefined") return
  if (action === "print") {
    window.print()
    return
  }
  window.dispatchEvent(
    new CustomEvent(`reui:receipt-${action}`, {
      detail: { receiptNumber: ORDER.receiptNumber },
    })
  )
}

export function Receipt() {
  const currency = TOTALS.currency

  return (
    <section
      aria-labelledby="receipt-heading"
      className="mx-auto w-full max-w-3xl px-4 py-8 md:px-6 md:py-12"
    >
      {/* Page header: brand on the left, receipt actions on the right */}
      <header className="mb-6 flex flex-wrap items-center justify-between gap-4 md:mb-8">
        <div className="flex min-w-0 items-center gap-2">
          <Item
            className="bg-primary text-primary-foreground size-8 shrink-0 items-center justify-center p-0"
            aria-hidden="true"
          >
            <ItemMedia variant="icon" className="size-auto">
              <svg
                width="50"
                height="50"
                viewBox="25.668 25.1352 49.6644 50"
                fill="none"
                xmlns="http://www.w3.org/2000/svg"
                className="size-4"
                aria-hidden="true"
              >
                <circle
                  cx="70.634"
                  cy="29.8334"
                  r="4.69799"
                  fill="currentColor"
                />
                <path
                  fillRule="evenodd"
                  clipRule="evenodd"
                  d="M25.668 57.0144V29.8332C25.668 27.2386 27.7713 25.1352 30.366 25.1352C32.9606 25.1352 35.0639 27.2386 35.0639 29.8332V57.0144C35.0639 61.833 38.9702 65.7392 43.7888 65.7392H57.2116C62.0302 65.7392 65.9364 61.833 65.9364 57.0144V43.7258C65.9364 41.1312 68.0398 39.0278 70.6344 39.0278C73.229 39.0278 75.3324 41.1312 75.3324 43.7258V57.0144C75.3324 67.0222 67.2194 75.1352 57.2116 75.1352H43.7888C33.7809 75.1352 25.668 67.0222 25.668 57.0144Z"
                  fill="currentColor"
                />
              </svg>
            </ItemMedia>
          </Item>
          <div className="flex min-w-0 flex-col">
            <span className="text-foreground text-sm font-semibold tracking-tight">
              {SHOP.name}
            </span>
            <span className="text-muted-foreground text-xs">
              {SHOP.tagline}
            </span>
          </div>
        </div>

        <div className="flex flex-wrap items-center gap-2">
          <Button
            type="button"
            size="sm"
            onClick={() => dispatchReceiptAction("download")}
            aria-label={`Download receipt ${ORDER.receiptNumber} as PDF`}
          >
            <DownloadIcon className="size-4" aria-hidden="true" />
            Download
          </Button>
          <Button
            type="button"
            variant="outline"
            size="sm"
            onClick={() => dispatchReceiptAction("email")}
            aria-label={`Email receipt ${ORDER.receiptNumber}`}
          >
            <MailIcon className="size-4" aria-hidden="true" />
            Email
          </Button>
          <Button
            type="button"
            variant="outline"
            size="icon-sm"
            onClick={() => dispatchReceiptAction("print")}
            aria-label={`Print receipt ${ORDER.receiptNumber}`}
          >
            <PrinterIcon className="size-4" aria-hidden="true" />
          </Button>
        </div>
      </header>

      {/* Receipt card */}
      <Card>
        <CardHeader>
          <div className="flex flex-wrap items-start justify-between gap-4">
            <div className="flex min-w-0 flex-col gap-2">
              <Badge variant="success" radius="full" className="w-fit">
                <CircleCheckIcon className="size-3.5" aria-hidden="true" />
                Paid
              </Badge>
              <CardTitle
                id="receipt-heading"
                className="text-2xl tracking-tight md:text-3xl"
              >
                Thanks For Your Order
              </CardTitle>
              <CardDescription className="text-pretty">
                A copy of this receipt was sent to{" "}
                <span className="text-foreground font-medium">
                  {ORDER.customerEmail}
                </span>
                .
              </CardDescription>
            </div>
            <dl className="text-muted-foreground grid w-full grid-cols-2 gap-x-6 gap-y-1.5 text-xs sm:w-auto sm:text-right">
              <div className="contents">
                <dt className="text-foreground font-medium">Order</dt>
                <dd className="font-mono tabular-nums">
                  <a
                    href="#"
                    aria-label={`View order ${ORDER.number} details`}
                    className={cn(ECOMMERCE_LINK_CLASS_NAME)}
                  >
                    {ORDER.number}
                  </a>
                </dd>
              </div>
              <div className="contents">
                <dt className="text-foreground font-medium">Receipt</dt>
                <dd className="font-mono tabular-nums">
                  {ORDER.receiptNumber}
                </dd>
              </div>
              <div className="contents">
                <dt className="text-foreground font-medium">Date</dt>
                <dd>{ORDER.placedAt}</dd>
              </div>
            </dl>
          </div>
        </CardHeader>

        <CardContent className="flex flex-col gap-6">
          {/* 3-up info grid: Ship To · Bill To · Payment */}
          <div className="grid grid-cols-1 gap-5 sm:grid-cols-3">
            <AddressBlock label="Ship To" address={SHIP_TO} />
            <AddressBlock label="Bill To" address={BILL_TO} />
            <PaymentBlock />
          </div>

          <Separator />

          {/* Items */}
          <div
            role="list"
            aria-label="Ordered items"
            className="flex flex-col gap-4"
          >
            {ITEMS.map((item) => (
              <ReceiptLineItem key={item.id} item={item} currency={currency} />
            ))}
          </div>

          <Separator />

          {/* Totals */}
          <TotalsBlock totals={TOTALS} />
        </CardContent>

        <CardFooter className="flex flex-col items-start gap-4 sm:flex-row sm:items-center sm:justify-between">
          <div className="flex min-w-0 items-start gap-3">
            <TruckIcon className="text-muted-foreground mt-0.5 size-5 shrink-0" aria-hidden="true" />
            <div className="flex min-w-0 flex-col gap-0.5">
              <p className="text-foreground text-sm leading-snug font-medium">
                Arrives {SHIPMENT.earliestDelivery} to {SHIPMENT.latestDelivery}
              </p>
              <p className="text-muted-foreground text-xs leading-snug">
                {SHIPMENT.carrier} · {SHIPMENT.service}
              </p>
              <a
                href={SHIPMENT.trackingHref}
                aria-label={`Track order ${ORDER.number}`}
                className={cn(
                  ECOMMERCE_LINK_CLASS_NAME,
                  "text-foreground mt-1 inline-flex w-fit items-center gap-1 text-xs font-medium"
                )}
              >
                Track Shipment
                <ArrowRightIcon className="size-3.5" aria-hidden="true" />
              </a>
            </div>
          </div>

          <a
            href={SHOP.supportHref}
            aria-label="Contact Halden support"
            className={cn(
              ECOMMERCE_LINK_CLASS_NAME,
              "text-muted-foreground hover:text-foreground inline-flex items-center gap-1.5 text-xs"
            )}
          >
            <LifeBuoyIcon className="size-3.5" aria-hidden="true" />
            Need help with this order?
          </a>
        </CardFooter>
      </Card>
    </section>
  )
}

// ─────────────────────────────────────────────────────────────────────────
// Subcomponents
// ─────────────────────────────────────────────────────────────────────────

function AddressBlock({ label, address }: { label: string; address: Address }) {
  return (
    <div className="flex min-w-0 flex-col gap-2">
      <p className="text-muted-foreground text-xs font-medium tracking-[0.16em] uppercase">
        {label}
      </p>
      <address className="text-foreground text-sm leading-snug not-italic">
        <p className="font-medium">{address.name}</p>
        {address.lines.map((line) => (
          <p key={line} className="text-muted-foreground">
            {line}
          </p>
        ))}
        <p className="text-muted-foreground">
          {address.city}, {address.region} {address.postalCode}
        </p>
        <p className="text-muted-foreground">{address.country}</p>
      </address>
    </div>
  )
}

function PaymentBlock() {
  return (
    <div className="flex min-w-0 flex-col gap-2">
      <p className="text-muted-foreground text-xs font-medium tracking-[0.16em] uppercase">
        Payment
      </p>
      <div className="flex flex-col gap-1 text-sm leading-snug">
        <div className="flex items-center gap-2">
          <Item
            variant="outline"
            className="size-8 w-auto shrink-0 justify-center px-1.5 py-1"
          >
            <CreditCardIcon className="text-muted-foreground size-4" aria-hidden="true" />
          </Item>
          <div className="flex min-w-0 flex-col">
            <span className="text-foreground font-medium tabular-nums">
              {PAYMENT.brand} · {PAYMENT.last4}
            </span>
            <span className="text-muted-foreground text-xs">
              Expires {PAYMENT.expiry}
            </span>
          </div>
        </div>
        <p className="text-muted-foreground text-xs">Charged {ORDER.paidAt}</p>
      </div>
    </div>
  )
}

function ReceiptLineItem({
  item,
  currency,
}: {
  item: ReceiptItem
  currency: ReceiptTotals["currency"]
}) {
  return (
    <article role="listitem" className="flex min-w-0 items-start gap-4">
      {/* Thumbnail */}
      <Item
        variant="muted"
        className="relative size-16 w-16 shrink-0 overflow-hidden border-0 p-0 shadow-none"
      >
        <a
          href={item.href}
          aria-label={`View ${item.name}`}
          className="focus-visible:ring-ring absolute inset-0 block outline-none focus-visible:ring-2 focus-visible:ring-inset"
        >
          <img
            src={item.image.src}
            alt={item.image.alt}
            className="absolute inset-0 size-full object-cover"
            loading="lazy"
          />
        </a>
      </Item>

      {/* Details */}
      <div className="flex min-w-0 flex-1 flex-col gap-0.5">
        <p className="text-muted-foreground text-xs font-medium tracking-wide uppercase">
          {item.brand}
        </p>
        <h3 className="text-foreground min-w-0 text-sm leading-snug font-medium">
          <a
            href={item.href}
            className={cn(ECOMMERCE_LINK_CLASS_NAME, "block truncate")}
          >
            {item.name}
          </a>
        </h3>
        <p className="text-muted-foreground text-xs">
          {item.variant} · Qty {item.quantity}
        </p>
      </div>

      {/* Pricing */}
      <div className="flex shrink-0 flex-col items-end gap-0.5 text-sm tabular-nums">
        <span className="text-foreground font-semibold">
          {formatCurrency(item.lineTotal, currency)}
        </span>
        {item.quantity > 1 ? (
          <span className="text-muted-foreground text-xs">
            {formatCurrency(item.unitPrice, currency)} each
          </span>
        ) : null}
      </div>
    </article>
  )
}

function TotalsBlock({ totals }: { totals: ReceiptTotals }) {
  const currency = totals.currency
  return (
    <dl className="flex flex-col gap-2 self-end text-sm sm:min-w-72">
      <SummaryRow
        label="Subtotal"
        value={formatCurrency(totals.subtotal, currency)}
      />
      <SummaryRow
        label="Shipping"
        value={
          totals.shipping === 0
            ? "Free"
            : formatCurrency(totals.shipping, currency)
        }
      />
      {totals.discount ? (
        <SummaryRow
          label={`Discount (${totals.discount.code})`}
          value={`-${formatCurrency(totals.discount.amount, currency)}`}
          tone="success"
        />
      ) : null}
      <SummaryRow
        label="Estimated Tax"
        value={formatCurrency(totals.tax, currency)}
      />
      <Separator className="my-1" />
      <SummaryRow
        label="Total"
        value={formatCurrency(totals.total, currency)}
        strong
      />
    </dl>
  )
}

function SummaryRow({
  label,
  value,
  tone = "default",
  strong = false,
}: {
  label: string
  value: string
  tone?: "default" | "success"
  strong?: boolean
}) {
  return (
    <div className="flex items-baseline justify-between gap-4">
      <dt
        className={cn(
          strong
            ? "text-foreground text-base font-semibold"
            : "text-muted-foreground"
        )}
      >
        {label}
      </dt>
      <dd
        className={cn(
          "tabular-nums",
          strong
            ? "text-foreground text-base font-semibold"
            : "text-foreground font-medium",
          tone === "success" && "text-success"
        )}
      >
        {value}
      </dd>
    </div>
  )
}