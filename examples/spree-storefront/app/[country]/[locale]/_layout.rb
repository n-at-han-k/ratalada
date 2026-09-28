# frozen_string_literal: true

# reui: shopping-cart-7
#
# <StoreProvider>
#   <AuthProvider>
#     <CartProvider>
#       <JsonLd>
#       {children}
#       <CartDrawer>                          # blocks/shopping-cart-7/mini-cart-sheet
#         <Sheet>
#           <SheetContent>
#             <SheetHeader>
#               <SheetTitle>
#               <Button>                      # close
#             <ul>
#               <li>                          # blocks/shopping-cart-7/cart-line-row
#                 <ProductImage>
#                 <Link>
#                 <Button>                    # remove
#                 <NumberField>               # reui/number-field
#             <SheetFooter>
#               <Progress>                    # free-shipping bar, from the block
#               <ExpressCheckoutButton>
#               <Button>                      # checkout
#               <Button>                      # view cart
#       <Toaster>                             # ui/sonner — local wrapper, sonner npm pkg

__END__

import type { PropsWithChildren } from "react"
import { Link } from "@inertiajs/react"
import { XIcon, MinusIcon, PlusIcon, ShoppingBagIcon, AppleIcon } from "lucide-react"

import { type CartLine, useCart } from "@/contexts/cart"
import { Button } from "@/components/ui/button"
import { Item } from "@/components/ui/item"
import { Progress } from "@/components/ui/progress"
import { Toaster } from "@/components/ui/sonner"
import {
  Sheet,
  SheetClose,
  SheetContent,
  SheetDescription,
  SheetFooter,
  SheetHeader,
  SheetTitle,
} from "@/components/ui/sheet"

// StoreProvider / AuthProvider: no Spree Store API session to hydrate yet, so
// these are just passthrough scopes. Wire them to real context (store config,
// current customer) when the API is.
function StoreProvider({ children }: PropsWithChildren) {
  return <>{children}</>
}

function AuthProvider({ children }: PropsWithChildren) {
  return <>{children}</>
}

const FREE_SHIPPING_THRESHOLD = 200

function CartProvider({ children }: PropsWithChildren) {
  return <>{children}</>
}

// Organization structured data. Static for now — there's no Store API to pull
// name/logo/social links from yet.
function JsonLd() {
  const data = {
    "@context": "https://schema.org",
    "@type": "Organization",
    name: "Spree Storefront",
    url: "/",
  }
  return <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(data) }} />
}

const formatCurrency = new Intl.NumberFormat("en-US", { style: "currency", currency: "USD" })

function CartLineRow({ line, onQuantityChange }: { line: CartLine; onQuantityChange: (quantity: number) => void }) {
  return (
    <li className="grid grid-cols-[56px_minmax(0,1fr)_auto] items-start gap-3 py-3">
      <Item variant="muted" className="relative size-14 overflow-hidden p-0">
        <img src={line.image.src} alt={line.image.alt} className="absolute inset-0 size-full object-cover" loading="lazy" />
      </Item>

      <div className="flex min-w-0 flex-col gap-2">
        <div>
          <Link href={`/products/${line.id}`} className="hover:text-primary block truncate text-sm font-medium">
            {line.name}
          </Link>
          <p className="text-muted-foreground truncate text-xs">{line.variant}</p>
        </div>

        <div className="border-input flex w-fit items-center gap-1 rounded-md border">
          <Button
            variant="ghost"
            size="icon-xs"
            type="button"
            aria-label={line.quantity <= 1 ? `Remove ${line.name}` : `Decrease quantity`}
            onClick={() => onQuantityChange(line.quantity - 1)}
          >
            <MinusIcon className="size-3" aria-hidden="true" />
          </Button>
          <span className="min-w-6 text-center text-xs tabular-nums">{line.quantity}</span>
          <Button variant="ghost" size="icon-xs" type="button" aria-label="Increase quantity" onClick={() => onQuantityChange(line.quantity + 1)}>
            <PlusIcon className="size-3" aria-hidden="true" />
          </Button>
        </div>
      </div>

      <p className="text-sm font-semibold tabular-nums">{formatCurrency.format(line.unitPrice * line.quantity)}</p>
    </li>
  )
}

function CartDrawer() {
  const cart = useCart()
  const subtotal = cart.lines.reduce((sum, line) => sum + line.unitPrice * line.quantity, 0)
  const shippingProgress = Math.min((subtotal / FREE_SHIPPING_THRESHOLD) * 100, 100)

  return (
    <Sheet open={cart.isOpen} onOpenChange={(open) => (open ? cart.open() : cart.close())}>
      <SheetContent side="right" className="flex w-full flex-col gap-0 sm:max-w-sm">
        <SheetHeader className="flex-row items-center justify-between space-y-0 border-b">
          <SheetTitle>Your cart</SheetTitle>
          <SheetDescription className="sr-only">Review the items in your cart and check out.</SheetDescription>
          <SheetClose render={<Button variant="ghost" size="icon-sm" aria-label="Close cart"><XIcon aria-hidden="true" /></Button>} />
        </SheetHeader>

        {cart.lines.length > 0 ? (
          <>
            <ul role="list" className="divide-border flex-1 divide-y overflow-y-auto px-4">
              {cart.lines.map((line) => (
                <CartLineRow key={line.id} line={line} onQuantityChange={(quantity) => cart.setQuantity(line.id, quantity)} />
              ))}
            </ul>

            <SheetFooter className="border-t">
              <div className="flex flex-col gap-1.5">
                <p className="text-muted-foreground text-xs">
                  {subtotal >= FREE_SHIPPING_THRESHOLD
                    ? "You've unlocked free shipping"
                    : `${formatCurrency.format(FREE_SHIPPING_THRESHOLD - subtotal)} away from free shipping`}
                </p>
                <Progress value={shippingProgress} aria-label="Free shipping progress" className="h-1.5" />
              </div>

              <div className="flex items-baseline justify-between text-sm font-semibold">
                <span>Subtotal</span>
                <span className="tabular-nums">{formatCurrency.format(subtotal)}</span>
              </div>

              {/* Express checkout — no payment provider wired yet, so this is chrome only */}
              <Button variant="outline" className="w-full" disabled>
                <AppleIcon aria-hidden="true" /> Pay
              </Button>

              <Button nativeButton={false} render={<Link href="/checkout" />} className="w-full">
                Checkout
              </Button>
              <Button nativeButton={false} variant="outline" render={<Link href="/cart" />} className="w-full">
                View cart
              </Button>
            </SheetFooter>
          </>
        ) : (
          <div className="text-muted-foreground flex flex-1 flex-col items-center justify-center gap-2 p-6 text-center text-sm">
            <ShoppingBagIcon className="size-8" aria-hidden="true" />
            Your cart is empty
          </div>
        )}
      </SheetContent>
    </Sheet>
  )
}

export default function LocaleLayout({ children }: PropsWithChildren) {
  return (
    <StoreProvider>
      <AuthProvider>
        <CartProvider>
          <JsonLd />
          {children}
          <CartDrawer />
          <Toaster />
        </CartProvider>
      </AuthProvider>
    </StoreProvider>
  )
}
