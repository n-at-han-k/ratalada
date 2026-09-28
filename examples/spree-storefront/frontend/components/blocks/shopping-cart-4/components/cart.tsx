"use client"

import { useMemo, useState } from "react"
import { Badge } from "@/components/reui/badge"

import {
  Breadcrumb,
  BreadcrumbItem,
  BreadcrumbLink,
  BreadcrumbList,
  BreadcrumbPage,
  BreadcrumbSeparator,
} from "@/components/ui/breadcrumb"
import { Button } from "@/components/ui/button"
import {
  Empty,
  EmptyContent,
  EmptyDescription,
  EmptyHeader,
  EmptyMedia,
  EmptyTitle,
} from "@/components/ui/empty"
import { CartItemRow } from "./cart-item-row"
import {
  CART_ITEMS,
  ECOMMERCE_LINK_CLASS_NAME,
  PROMO_CODE,
  PROMO_RATE,
  TAX_RATE,
  type CartItem,
  type FulfillmentMode,
} from "./data"
import { OrderSummary, type OrderTotals } from "./order-summary"
import { TruckIcon, StoreIcon, ArrowRightIcon, ArrowLeftIcon, ShoppingCartIcon } from "lucide-react"

function getOrderTotals(
  items: CartItem[],
  promoStatus: "idle" | "applied" | "invalid"
): OrderTotals {
  const subtotal = items.reduce(
    (sum, item) => sum + item.unitPrice * item.quantity,
    0
  )
  let deliveryFee = 0
  let pickupFee = 0
  let deliveryCount = 0
  let pickupCount = 0
  for (const item of items) {
    if (item.mode === "delivery") {
      deliveryFee += item.delivery.price
      deliveryCount += 1
    } else {
      pickupFee += item.pickup.price
      pickupCount += 1
    }
  }
  const discount =
    promoStatus === "applied" && subtotal > 0 ? subtotal * PROMO_RATE : 0
  const taxable = Math.max(subtotal + deliveryFee + pickupFee - discount, 0)
  const tax = taxable * TAX_RATE
  return {
    subtotal,
    deliveryFee,
    pickupFee,
    deliveryCount,
    pickupCount,
    discount,
    tax,
    total: taxable + tax,
  }
}

interface DispatchSlot {
  mode: FulfillmentMode
  date: string
  count: number
}

function getDispatchSlots(items: CartItem[]): DispatchSlot[] {
  const order: FulfillmentMode[] = ["delivery", "pickup"]
  const slots = new Map<string, DispatchSlot>()
  for (const item of items) {
    const option = item.mode === "delivery" ? item.delivery : item.pickup
    const key = `${item.mode}:${option.date}`
    const existing = slots.get(key)
    if (existing) {
      existing.count += item.quantity
    } else {
      slots.set(key, {
        mode: item.mode,
        date: option.date,
        count: item.quantity,
      })
    }
  }
  return Array.from(slots.values()).sort(
    (a, b) => order.indexOf(a.mode) - order.indexOf(b.mode)
  )
}

function DispatchSlotChip({ slot }: { slot: DispatchSlot }) {
  const isDelivery = slot.mode === "delivery"
  const dateLabel = slot.date.toLowerCase() === "today" ? "today" : slot.date
  return (
    <span className="inline-flex items-center gap-1.5">
      {isDelivery ? (
        <TruckIcon aria-hidden="true" className="text-foreground/70 size-3.5 shrink-0" />
      ) : (
        <StoreIcon aria-hidden="true" className="text-foreground/70 size-3.5 shrink-0" />
      )}
      <span>
        <span className="text-foreground font-medium tabular-nums">
          {slot.count}
        </span>{" "}
        ready {dateLabel}
      </span>
    </span>
  )
}

export function Cart() {
  const [items, setItems] = useState<CartItem[]>(CART_ITEMS)
  const [promoCode, setPromoCode] = useState(PROMO_CODE)
  const [promoStatus, setPromoStatus] = useState<
    "idle" | "applied" | "invalid"
  >("applied")

  const itemCount = items.reduce((total, item) => total + item.quantity, 0)
  const totals = useMemo(
    () => getOrderTotals(items, promoStatus),
    [items, promoStatus]
  )
  const dispatchSlots = useMemo(() => getDispatchSlots(items), [items])

  function handleDecrease(itemId: string) {
    setItems((currentItems) =>
      currentItems.map((item) =>
        item.id === itemId
          ? { ...item, quantity: Math.max(item.quantity - 1, 1) }
          : item
      )
    )
  }

  function handleIncrease(itemId: string) {
    setItems((currentItems) =>
      currentItems.map((item) =>
        item.id === itemId ? { ...item, quantity: item.quantity + 1 } : item
      )
    )
  }

  function handleRemove(itemId: string) {
    setItems((currentItems) =>
      currentItems.filter((item) => item.id !== itemId)
    )
  }

  function handleModeChange(itemId: string, mode: FulfillmentMode) {
    setItems((currentItems) =>
      currentItems.map((item) =>
        item.id === itemId ? { ...item, mode } : item
      )
    )
  }

  function handleApplyPromo() {
    if (promoCode.trim().toUpperCase() === PROMO_CODE) {
      setPromoStatus("applied")
      return
    }
    setPromoStatus("invalid")
  }

  function handlePromoCodeChange(value: string) {
    setPromoCode(value)
    setPromoStatus("idle")
  }

  function handleClearPromo() {
    setPromoCode("")
    setPromoStatus("idle")
  }

  function handleCheckout() {
    if (typeof window === "undefined") {
      return
    }
    window.location.hash = "#checkout"
  }

  function handleRestoreCart() {
    setItems(CART_ITEMS)
    setPromoCode(PROMO_CODE)
    setPromoStatus("applied")
  }

  const hasItems = items.length > 0

  return (
    <section
      aria-labelledby="cart-title"
      className="mx-auto w-full max-w-6xl px-4 py-6 sm:px-8 sm:py-10"
    >
      {/* Header */}
      <header className="mb-6 flex flex-col gap-3 sm:mb-8">
        <Breadcrumb>
          <BreadcrumbList className="text-xs sm:text-sm">
            <BreadcrumbItem>
              <BreadcrumbLink href="#" className={ECOMMERCE_LINK_CLASS_NAME}>
                Shop
              </BreadcrumbLink>
            </BreadcrumbItem>
            <BreadcrumbSeparator />
            <BreadcrumbItem>
              <BreadcrumbPage>Cart</BreadcrumbPage>
            </BreadcrumbItem>
          </BreadcrumbList>
        </Breadcrumb>

        <div className="flex flex-col gap-2">
          <div className="flex flex-wrap items-center justify-between gap-x-4 gap-y-2">
            <div className="flex items-center gap-2">
              <h1
                id="cart-title"
                className="text-foreground text-2xl leading-tight font-semibold tracking-tight sm:text-[1.75rem]"
              >
                Shopping Cart
              </h1>
              {hasItems ? (
                <Badge
                  variant="default"
                  radius="full"
                  className="tabular-nums"
                  aria-label={`${itemCount} ${itemCount === 1 ? "item" : "items"} in cart`}
                >
                  {itemCount}
                </Badge>
              ) : null}
            </div>
            <Button variant="link" type="button" className="h-auto p-0 text-sm">
              Continue Shopping
              <ArrowRightIcon data-icon="inline-end" aria-hidden="true" />
            </Button>
          </div>
          {hasItems && dispatchSlots.length > 0 ? (
            <p className="text-muted-foreground flex flex-wrap items-center gap-x-3 gap-y-1.5 text-xs sm:text-sm">
              {dispatchSlots.map((slot, index) => (
                <span
                  key={`${slot.mode}-${slot.date}`}
                  className="inline-flex items-center gap-3"
                >
                  {index > 0 ? (
                    <span
                      aria-hidden="true"
                      className="bg-muted-foreground/40 size-1 shrink-0 rounded-full"
                    />
                  ) : null}
                  <DispatchSlotChip slot={slot} />
                </span>
              ))}
            </p>
          ) : null}
        </div>
      </header>

      {/* Body */}
      {hasItems ? (
        <div className="grid gap-6 lg:grid-cols-[minmax(0,1fr)_360px] lg:items-start lg:gap-10">
          {/* Items + utility row */}
          <div className="flex min-w-0 flex-col gap-4">
            <ul role="list" className="divide-border divide-y">
              {items.map((item, index) => (
                <li
                  key={item.id}
                  className="group/row py-5 first:pt-0 last:pb-0"
                >
                  <CartItemRow
                    item={item}
                    priority={index === 0}
                    onDecrease={handleDecrease}
                    onIncrease={handleIncrease}
                    onRemove={handleRemove}
                    onModeChange={handleModeChange}
                  />
                </li>
              ))}
            </ul>

            {/* Utility row */}
            <div className="flex flex-wrap items-center justify-between gap-3 border-t pt-5">
              <Button
                variant="outline"
                size="sm"
                nativeButton={false}
                render={<a href="#" aria-label="Back to catalog" />}
              >
                <ArrowLeftIcon data-icon="inline-start" aria-hidden="true" />
                Back to Catalog
              </Button>
              <p className="text-muted-foreground inline-flex items-center gap-2 text-xs">
                <StoreIcon aria-hidden="true" className="text-foreground/70 size-3.5 shrink-0" />
                <span>Free pickup at any store</span>
                <span
                  aria-hidden="true"
                  className="bg-muted-foreground/40 size-1 shrink-0 rounded-full"
                />
                <span>Toggle per item</span>
              </p>
            </div>
          </div>

          {/* Order Summary */}
          <div className="lg:sticky lg:top-6">
            <OrderSummary
              items={items}
              totals={totals}
              promoCode={promoCode}
              promoStatus={promoStatus}
              onPromoCodeChange={handlePromoCodeChange}
              onApplyPromo={handleApplyPromo}
              onClearPromo={handleClearPromo}
              onCheckout={handleCheckout}
            />
          </div>
        </div>
      ) : (
        <Empty className="min-h-[320px] justify-center py-10">
          <EmptyHeader>
            <EmptyMedia variant="icon">
              <ShoppingCartIcon aria-hidden="true" className="size-5" />
            </EmptyMedia>
            <EmptyTitle>Your Cart Is Empty</EmptyTitle>
            <EmptyDescription>
              Items you add will appear here, ready to switch between delivery
              and in-store pickup.
            </EmptyDescription>
          </EmptyHeader>
          <EmptyContent>
            <Button type="button" size="sm" onClick={handleRestoreCart}>
              Restore Sample Cart
            </Button>
          </EmptyContent>
        </Empty>
      )}
    </section>
  )
}