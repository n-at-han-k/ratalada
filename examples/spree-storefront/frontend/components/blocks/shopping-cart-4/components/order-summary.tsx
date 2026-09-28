import { Badge } from "@/components/reui/badge"

import { Button } from "@/components/ui/button"
import {
  Card,
  CardContent,
  CardHeader,
} from "@/components/ui/card"
import {
  Field,
  FieldError,
} from "@/components/ui/field"
import {
  InputGroup,
  InputGroupAddon,
  InputGroupButton,
  InputGroupInput,
  InputGroupText,
} from "@/components/ui/input-group"
import { Separator } from "@/components/ui/separator"
import {
  Tooltip,
  TooltipContent,
  TooltipProvider,
  TooltipTrigger,
} from "@/components/ui/tooltip"
import { PROMO_RATE, TAX_RATE, type CartItem } from "./data"
import { InfoIcon, SparklesIcon, CheckIcon, XIcon, TicketPercentIcon, ShieldCheckIcon, LockIcon } from "lucide-react"

const formatCurrency = new Intl.NumberFormat("en-US", {
  style: "currency",
  currency: "USD",
})

const formatPercent = new Intl.NumberFormat("en-US", {
  style: "percent",
  maximumFractionDigits: 0,
})

export interface OrderTotals {
  subtotal: number
  deliveryFee: number
  pickupFee: number
  discount: number
  tax: number
  total: number
  deliveryCount: number
  pickupCount: number
}

function SummaryRow({
  label,
  meta,
  value,
  tone,
  info,
}: {
  label: string
  meta?: string
  value: string
  tone?: "success" | "muted"
  info?: string
}) {
  return (
    <div className="flex items-center justify-between gap-3 text-sm">
      <span className="text-muted-foreground inline-flex items-center gap-1.5">
        <span>{label}</span>
        {meta != null ? (
          <span className="text-muted-foreground/80 tabular-nums">{meta}</span>
        ) : null}
        {info != null ? (
          <Tooltip>
            <TooltipTrigger
              render={
                <Button
                  variant="ghost"
                  size="icon-xs"
                  type="button"
                  aria-label={info}
                  className="text-muted-foreground/70 hover:text-foreground"
                />
              }
            >
              <InfoIcon aria-hidden="true" className="size-3.5" />
            </TooltipTrigger>
            <TooltipContent>{info}</TooltipContent>
          </Tooltip>
        ) : null}
      </span>
      <span
        className={
          tone === "success"
            ? "text-success font-semibold tabular-nums"
            : tone === "muted"
              ? "text-muted-foreground font-medium tabular-nums"
              : "text-foreground font-semibold tabular-nums"
        }
      >
        {value}
      </span>
    </div>
  )
}

export function OrderSummary({
  items,
  totals,
  promoCode,
  promoStatus,
  onPromoCodeChange,
  onApplyPromo,
  onClearPromo,
  onCheckout,
}: {
  items: CartItem[]
  totals: OrderTotals
  promoCode: string
  promoStatus: "idle" | "applied" | "invalid"
  onPromoCodeChange: (value: string) => void
  onApplyPromo: () => void
  onClearPromo: () => void
  onCheckout: () => void
}) {
  const isInvalid = promoStatus === "invalid"
  const isApplied = promoStatus === "applied"
  const hasItems = items.length > 0
  const appliedCode = isApplied ? promoCode.trim().toUpperCase() : ""
  const hasSavings = totals.discount > 0

  return (
    <TooltipProvider>
      <Card className="overflow-hidden p-0 shadow-none">
        {/* Hero total */}
        <CardHeader className="px-5 pt-5 pb-2 sm:px-6 sm:pt-6 sm:pb-2">
          <div className="flex flex-wrap items-baseline justify-between gap-x-3 gap-y-1">
            <p className="text-muted-foreground text-xs font-medium">
              Order Total
            </p>
            <p className="text-muted-foreground text-xs tabular-nums">
              Estimated
            </p>
          </div>
          <p className="text-foreground mt-0.5 text-3xl font-semibold tracking-tight tabular-nums sm:text-[2.25rem] sm:leading-[1.05]">
            {formatCurrency.format(totals.total)}
          </p>
          {hasSavings ? (
            <Badge
              variant="success-light"
              className="mt-2 gap-1.5 self-start py-0.5 pr-2.5 pl-2"
            >
              <SparklesIcon aria-hidden="true" className="size-3" />
              <span className="font-semibold tabular-nums">
                You saved {formatCurrency.format(totals.discount)}
              </span>
            </Badge>
          ) : null}
        </CardHeader>

        {/* Itemized rows */}
        <CardContent className="flex flex-col gap-2 px-5 pt-2 pb-4 sm:px-6 sm:pt-2 sm:pb-5">
          <SummaryRow
            label="Subtotal"
            value={formatCurrency.format(totals.subtotal)}
          />
          {totals.deliveryCount > 0 ? (
            <SummaryRow
              label="Delivery"
              meta={`${totals.deliveryCount} ${totals.deliveryCount === 1 ? "item" : "items"}`}
              value={
                totals.deliveryFee > 0
                  ? `+${formatCurrency.format(totals.deliveryFee)}`
                  : "Free"
              }
            />
          ) : null}
          {totals.pickupCount > 0 ? (
            <SummaryRow
              label="Pickup"
              meta={`${totals.pickupCount} ${totals.pickupCount === 1 ? "item" : "items"}`}
              value={
                totals.pickupFee > 0
                  ? `+${formatCurrency.format(totals.pickupFee)}`
                  : "Free"
              }
            />
          ) : null}
          {totals.discount > 0 ? (
            <SummaryRow
              label={`Promo (${formatPercent.format(PROMO_RATE)})`}
              value={`-${formatCurrency.format(totals.discount)}`}
              tone="success"
            />
          ) : null}
          <SummaryRow
            label="Tax"
            meta={formatPercent.format(TAX_RATE)}
            value={formatCurrency.format(totals.tax)}
            info="Final tax is recalculated at checkout."
          />

          {/* Promo input or applied chip */}
          {isApplied ? (
            <div className="flex items-center justify-between gap-3 text-sm">
              <span className="text-muted-foreground">Promo code</span>
              <Badge
                variant="outline"
                className="gap-1.5 py-0.5 pr-0.5 pl-2"
              >
                <CheckIcon aria-hidden="true" className="text-success size-3" />
                <span className="text-foreground font-semibold tracking-wide">
                  {appliedCode}
                </span>
                <button
                  type="button"
                  onClick={onClearPromo}
                  aria-label={`Remove promo code ${appliedCode}`}
                  className="text-muted-foreground hover:bg-muted hover:text-foreground focus-visible:ring-ring inline-flex size-4 shrink-0 items-center justify-center rounded-full outline-none focus-visible:ring-2"
                >
                  <XIcon aria-hidden="true" className="size-2.5" />
                </button>
              </Badge>
            </div>
          ) : (
            <form
              onSubmit={(event) => {
                event.preventDefault()
                onApplyPromo()
              }}
            >
              <Field data-invalid={isInvalid}>
                <InputGroup className="pr-0">
                  <InputGroupAddon>
                    <InputGroupText>
                      <TicketPercentIcon aria-hidden="true" className="text-muted-foreground size-4" />
                    </InputGroupText>
                  </InputGroupAddon>
                  <InputGroupInput
                    id="cart-4-promo"
                    value={promoCode}
                    placeholder="Promo code"
                    aria-label="Promo code"
                    aria-invalid={isInvalid}
                    onChange={(event) => onPromoCodeChange(event.target.value)}
                  />
                  <InputGroupAddon align="inline-end" className="pr-0">
                    <InputGroupButton
                      type="submit"
                      variant="default"
                      size="sm"
                      disabled={promoCode.trim().length === 0}
                    >
                      Apply
                    </InputGroupButton>
                  </InputGroupAddon>
                </InputGroup>
                {isInvalid ? (
                  <FieldError id="cart-4-promo-error">
                    That code is not valid.
                  </FieldError>
                ) : null}
              </Field>
            </form>
          )}

          <Separator className="mt-1 mb-0.5" />

          {/* Total row */}
          <div className="flex items-baseline justify-between gap-3">
            <p className="text-foreground text-base font-semibold">Total</p>
            <p className="text-foreground text-xl font-semibold tracking-tight tabular-nums">
              {formatCurrency.format(totals.total)}
            </p>
          </div>
        </CardContent>

        {/* Action zone */}
        <div className="bg-muted/30 flex flex-col gap-2 border-t px-5 pt-4 pb-5 sm:px-6 sm:pt-4 sm:pb-5">
          <Button
            type="button"
            size="lg"
            className="w-full"
            disabled={!hasItems}
            onClick={onCheckout}
          >
            <ShieldCheckIcon data-icon="inline-start" aria-hidden="true" />
            Checkout Securely
          </Button>
          <p className="text-muted-foreground flex flex-wrap items-center justify-center gap-x-2 gap-y-1 text-xs">
            <span className="inline-flex items-center gap-1.5">
              <LockIcon aria-hidden="true" className="text-foreground/70 size-3 shrink-0" />
              Encrypted checkout
            </span>
            <span
              aria-hidden="true"
              className="bg-muted-foreground/40 size-1 shrink-0 rounded-full"
            />
            <span>60-day returns</span>
          </p>
        </div>
      </Card>
    </TooltipProvider>
  )
}