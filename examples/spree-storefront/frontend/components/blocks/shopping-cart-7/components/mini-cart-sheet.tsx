import { useMemo, useState } from "react"
import { Badge } from "@/components/reui/badge"

import { Button } from "@/components/ui/button"
import {
  Empty,
  EmptyDescription,
  EmptyHeader,
  EmptyMedia,
  EmptyTitle,
} from "@/components/ui/empty"
import { Item } from "@/components/ui/item"
import { Progress } from "@/components/ui/progress"
import { ScrollArea } from "@/components/ui/scroll-area"
import {
  Sheet,
  SheetClose,
  SheetContent,
  SheetDescription,
  SheetFooter,
  SheetHeader,
  SheetTitle,
  SheetTrigger,
} from "@/components/ui/sheet"
import { CartLineRow } from "./cart-line-row"
import {
  CART_LINES,
  FREE_SHIPPING_THRESHOLD,
  JUST_ADDED_TIMESTAMP,
  type CartLine,
} from "./data"
import { ShoppingBagIcon, XIcon, CheckIcon, CircleCheckIcon, ArrowRightIcon } from "lucide-react"

const formatCurrency = new Intl.NumberFormat("en-US", {
  style: "currency",
  currency: "USD",
})

export function MiniCartSheet() {
  const [open, setOpen] = useState(true)
  const [lines, setLines] = useState<CartLine[]>(CART_LINES)

  const itemCount = lines.reduce((sum, line) => sum + line.quantity, 0)
  const subtotal = useMemo(
    () => lines.reduce((sum, line) => sum + line.unitPrice * line.quantity, 0),
    [lines]
  )
  const hasItems = lines.length > 0
  const justAddedLine = hasItems ? lines[0] : null
  const restOfLines = lines.slice(1)

  const remainingForFreeShipping = Math.max(
    FREE_SHIPPING_THRESHOLD - subtotal,
    0
  )
  const freeShippingProgress = Math.min(
    (subtotal / FREE_SHIPPING_THRESHOLD) * 100,
    100
  )
  const freeShippingUnlocked = subtotal >= FREE_SHIPPING_THRESHOLD

  function handleDecrease(lineId: string) {
    setLines((current) => {
      const line = current.find((entry) => entry.id === lineId)
      if (!line) {
        return current
      }
      if (line.quantity <= 1) {
        return current.filter((entry) => entry.id !== lineId)
      }
      return current.map((entry) =>
        entry.id === lineId ? { ...entry, quantity: entry.quantity - 1 } : entry
      )
    })
  }

  function handleIncrease(lineId: string) {
    setLines((current) =>
      current.map((line) =>
        line.id === lineId ? { ...line, quantity: line.quantity + 1 } : line
      )
    )
  }

  function handleRestore() {
    setLines(CART_LINES)
  }

  return (
    <Sheet open={open} onOpenChange={setOpen}>
      <div className="flex min-h-[360px] items-center justify-center">
        <SheetTrigger
          render={
            <Button type="button" variant="outline">
              <ShoppingBagIcon data-icon="inline-start" aria-hidden="true" />
              Open Cart
              <Badge
                size="xs"
                className="ml-1.5 rounded-full!"
                aria-label={`${itemCount} items in cart`}
              >
                {itemCount}
              </Badge>
            </Button>
          }
        />
      </div>

      <SheetContent
        side="right"
        showCloseButton={false}
        initialFocus={false}
        className="inset-y-4 right-4 left-auto flex h-[calc(100svh-2rem)] w-[min(26rem,calc(100vw-2rem))] max-w-none flex-col gap-0 overflow-hidden rounded-xl p-0 outline-none"
      >
        {/* Header */}
        <SheetHeader className="shrink-0 p-0">
          <div className="flex min-h-12 items-center justify-between gap-2 border-b px-4">
            <div className="flex min-w-0 items-baseline gap-2">
              <SheetTitle className="truncate text-sm font-semibold">
                Your Cart
              </SheetTitle>
              <span className="text-muted-foreground text-xs tabular-nums">
                {itemCount} {itemCount === 1 ? "item" : "items"}
              </span>
            </div>
            <SheetClose
              render={
                <Button
                  type="button"
                  variant="ghost"
                  size="icon-sm"
                  aria-label="Close cart"
                  className="shrink-0"
                >
                  <XIcon aria-hidden="true" />
                </Button>
              }
            />
          </div>
          <SheetDescription className="sr-only">
            Review the items you just added to your cart and proceed to
            checkout.
          </SheetDescription>
        </SheetHeader>

        {/* Body */}
        {hasItems ? (
          <div className="min-h-0 flex-1">
            <ScrollArea className="h-full">
              <div className="flex flex-col gap-5 p-4">
                {/* Just Added */}
                {justAddedLine ? (
                  <section
                    aria-label="Just added"
                    className="flex flex-col gap-2"
                  >
                    <div className="flex items-center justify-between gap-2">
                      <div className="inline-flex items-center gap-1.5">
                        <Badge variant="success-light" size="sm">
                          <CheckIcon aria-hidden="true" className="size-2.5" />
                          Just Added
                        </Badge>
                        <span className="text-muted-foreground text-xs">
                          {JUST_ADDED_TIMESTAMP}
                        </span>
                      </div>
                    </div>
                    <Item
                      variant="outline"
                      className="border-success/25 bg-success/[0.03] block p-3"
                    >
                      <CartLineRow
                        line={justAddedLine}
                        priority
                        onDecrease={handleDecrease}
                        onIncrease={handleIncrease}
                      />
                    </Item>
                  </section>
                ) : null}

                {/* Also In Your Cart */}
                {restOfLines.length > 0 ? (
                  <section
                    aria-label="Also in your cart"
                    className="flex flex-col gap-2"
                  >
                    <h3 className="text-muted-foreground text-[10px] font-semibold tracking-widest uppercase">
                      Also In Your Cart ({restOfLines.length})
                    </h3>
                    <ul role="list" className="divide-border divide-y">
                      {restOfLines.map((line) => (
                        <li key={line.id} className="py-3 first:pt-0 last:pb-0">
                          <CartLineRow
                            line={line}
                            onDecrease={handleDecrease}
                            onIncrease={handleIncrease}
                          />
                        </li>
                      ))}
                    </ul>
                  </section>
                ) : null}
              </div>
            </ScrollArea>
          </div>
        ) : (
          <div className="flex min-h-0 flex-1 items-center justify-center px-4">
            <Empty>
              <EmptyHeader>
                <EmptyMedia variant="icon">
                  <ShoppingBagIcon aria-hidden="true" className="size-5" />
                </EmptyMedia>
                <EmptyTitle>Your Cart Is Empty</EmptyTitle>
                <EmptyDescription>
                  Items you add will appear here, ready to review.
                </EmptyDescription>
              </EmptyHeader>
              <Button
                type="button"
                size="sm"
                variant="outline"
                onClick={handleRestore}
              >
                Restore Sample Cart
              </Button>
            </Empty>
          </div>
        )}

        {/* Footer */}
        {hasItems ? (
          <SheetFooter className="bg-muted/30 shrink-0 gap-3 border-t p-4">
            {/* Free shipping progress */}
            <div className="flex flex-col gap-1.5">
              {freeShippingUnlocked ? (
                <p className="text-foreground inline-flex items-center gap-1.5 text-xs font-medium">
                  <CircleCheckIcon aria-hidden="true" className="text-success size-3.5 shrink-0" />
                  <span>You've unlocked free shipping</span>
                </p>
              ) : (
                <p className="text-muted-foreground text-xs">
                  <span className="text-foreground font-medium tabular-nums">
                    {formatCurrency.format(remainingForFreeShipping)}
                  </span>{" "}
                  away from free shipping
                </p>
              )}
              <Progress
                value={freeShippingProgress}
                aria-label="Free shipping progress"
                className="h-1.5"
              />
            </div>

            {/* Subtotal */}
            <div className="flex items-baseline justify-between gap-3">
              <span className="text-muted-foreground text-xs">
                Subtotal{" "}
                <span className="text-foreground/80 tabular-nums">
                  ({itemCount} {itemCount === 1 ? "item" : "items"})
                </span>
              </span>
              <span className="text-foreground text-base font-semibold tabular-nums">
                {formatCurrency.format(subtotal)}
              </span>
            </div>

            {/* Actions */}
            <div className="grid grid-cols-[auto_minmax(0,1fr)] gap-2">
              <Button
                variant="outline"
                size="sm"
                nativeButton={false}
                render={<a href="#cart" />}
              >
                View Cart
              </Button>
              <Button
                size="sm"
                nativeButton={false}
                render={<a href="#checkout" />}
              >
                Checkout
                <ArrowRightIcon data-icon="inline-end" aria-hidden="true" />
              </Button>
            </div>

            <p className="text-muted-foreground text-center text-[11px]">
              Taxes and discounts calculated at checkout.
            </p>
          </SheetFooter>
        ) : null}
      </SheetContent>
    </Sheet>
  )
}