# frozen_string_literal: true

# reui: shopping-cart-4
#
# <Cart>                                      # blocks/shopping-cart-4/cart
#   <h1>
#   <CartItemRow>                             # blocks/shopping-cart-4/cart-item-row
#     <ProductImage>
#     <h3>
#     <p>                                     # options / unit price
#     <NumberField>                           # reui/number-field
#     <Button>                                # remove
#   <OrderSummary>                            # blocks/shopping-cart-4/order-summary
#     <dl>                                    # subtotal / discount / shipping / tax / total
#     <InputGroup>                            # coupon code field
#     <ExpressCheckoutButton>                 # blocks/checkout-5 svgs (apple / paypal)
#     <Button>                                # checkout
#     <Button>                                # continue shopping
# <Empty>                                     # ui/empty — empty cart

# ponytail: fixture props, swap for the Spree Store API call when it is wired.
# One cart for the whole demo, shaped like the Spree order the reference
# storefront renders (line_items + the display_* totals Spree precomputes).
def fixture_cart
  {
    id:                  "R123456789",
    line_items:          [
      {
        id:            "li_1",
        name:          "Lumen Compact Camera",
        options_text:  "Color: Red",
        quantity:      1,
        unit_price:    "$99.89",
        display_total: "$99.89",
        image:         {
          src: "https://images.unsplash.com/photo-1495121605193-b116b5b9c5fe?auto=format&fit=crop&w=200&h=200&q=80",
          alt: "Lumen Compact Camera in red",
        },
      },
      {
        id:            "li_2",
        name:          "Velar Wireless Headphones",
        options_text:  "Color: Dark Blue",
        quantity:      2,
        unit_price:    "$71.69",
        display_total: "$143.38",
        image:         {
          src: "https://images.unsplash.com/photo-1583394838336-acd977736f90?auto=format&fit=crop&w=200&h=200&q=80",
          alt: "Velar Wireless Headphones in dark blue",
        },
      },
    ],
    display_item_total:     "$243.27",
    display_delivery_total: "$0.00",
    display_tax_total:      "$17.03",
    display_total:          "$260.30",
    coupon_code:             nil,
  }
end

get "/" do
  inertia("[country]/[locale]/(storefront)/cart", props: { cart: fixture_cart })
end

# One route, branching on an `action` field, since this file only owns the
# /cart path — mirrors the single post "/" every other route file uses.
# Nothing is persisted (there's no backend cart yet): each action just
# bounces back to the cart page.
post "/" do
  case params["action"]
  when "update_quantity", "remove"
    # ponytail: swap for a Store API cart line-item update/remove call.
  when "apply_coupon"
    page_errors(coupon_code: "That code is not valid.") if params["coupon_code"].to_s.strip.empty?
  end

  redirect(request.path, 303)
end

__END__

import { Form, Head, Link, usePage } from "@inertiajs/react"
import { MinusIcon, PlusIcon, ShoppingCartIcon, TicketPercentIcon, XIcon } from "lucide-react"

import {
  NumberField,
  NumberFieldDecrement,
  NumberFieldGroup,
  NumberFieldIncrement,
  NumberFieldInput,
} from "@/components/reui/number-field"
import { Button } from "@/components/ui/button"
import {
  Empty,
  EmptyContent,
  EmptyDescription,
  EmptyHeader,
  EmptyMedia,
  EmptyTitle,
} from "@/components/ui/empty"
import { Field, FieldError } from "@/components/ui/field"
import { Item } from "@/components/ui/item"
import {
  InputGroup,
  InputGroupAddon,
  InputGroupButton,
  InputGroupInput,
  InputGroupText,
} from "@/components/ui/input-group"
import { Separator } from "@/components/ui/separator"

interface LineItem {
  id: string
  name: string
  options_text: string
  quantity: number
  unit_price: string
  display_total: string
  image: { src: string; alt: string }
}

interface Cart {
  id: string
  line_items: LineItem[]
  display_item_total: string
  display_delivery_total: string
  display_tax_total: string
  display_total: string
  coupon_code: string | null
}

function CartItemRow({ item }: { item: LineItem }) {
  return (
    <li className="flex gap-4 py-5 first:pt-0 last:pb-0">
      <Item variant="muted" className="size-20 shrink-0 overflow-hidden p-0 sm:size-24">
        <img
          src={item.image.src}
          alt={item.image.alt}
          className="size-full object-cover"
          loading="lazy"
        />
      </Item>

      <div className="flex min-w-0 flex-1 flex-col gap-2">
        <div className="flex items-start justify-between gap-3">
          <div className="min-w-0">
            <h3 className="text-foreground text-sm font-semibold sm:text-base">{item.name}</h3>
            <p className="text-muted-foreground mt-0.5 text-xs">{item.options_text}</p>
            <p className="text-muted-foreground mt-0.5 text-xs">{item.unit_price} each</p>
          </div>
          <Form action="/cart" method="post">
            <input type="hidden" name="action" value="remove" />
            <input type="hidden" name="item_id" value={item.id} />
            <Button
              variant="ghost"
              size="icon-sm"
              type="submit"
              aria-label={`Remove ${item.name} from cart`}
              className="text-muted-foreground hover:text-destructive -mt-1 -mr-1 shrink-0"
            >
              <XIcon aria-hidden="true" />
            </Button>
          </Form>
        </div>

        <div className="mt-auto flex flex-wrap items-center justify-between gap-3">
          <Form action="/cart" method="post" className="flex items-center gap-2">
            <input type="hidden" name="action" value="update_quantity" />
            <input type="hidden" name="item_id" value={item.id} />
            <NumberField name="quantity" defaultValue={item.quantity} min={1} size="sm">
              <NumberFieldGroup>
                <NumberFieldDecrement>
                  <MinusIcon />
                </NumberFieldDecrement>
                <NumberFieldInput />
                <NumberFieldIncrement>
                  <PlusIcon />
                </NumberFieldIncrement>
              </NumberFieldGroup>
            </NumberField>
            <Button variant="outline" size="sm" type="submit">
              Update
            </Button>
          </Form>
          <p className="text-foreground text-sm font-semibold tabular-nums sm:text-base">
            {item.display_total}
          </p>
        </div>
      </div>
    </li>
  )
}

function OrderSummary({ cart }: { cart: Cart }) {
  const { errors } = usePage().props as { errors?: Record<string, string> }

  return (
    <div className="rounded-lg border p-5 sm:p-6">
      <h2 className="text-foreground text-sm font-semibold">Order Summary</h2>

      <dl className="mt-4 flex flex-col gap-2 text-sm">
        <div className="flex justify-between">
          <dt className="text-muted-foreground">Subtotal</dt>
          <dd className="tabular-nums">{cart.display_item_total}</dd>
        </div>
        <div className="flex justify-between">
          <dt className="text-muted-foreground">Shipping</dt>
          <dd className="tabular-nums">{cart.display_delivery_total}</dd>
        </div>
        <div className="flex justify-between">
          <dt className="text-muted-foreground">Tax</dt>
          <dd className="tabular-nums">{cart.display_tax_total}</dd>
        </div>
        <Separator className="my-1" />
        <div className="flex justify-between text-base font-semibold">
          <dt>Total</dt>
          <dd className="tabular-nums">{cart.display_total}</dd>
        </div>
      </dl>

      <Form action="/cart" method="post" className="mt-4">
        <input type="hidden" name="action" value="apply_coupon" />
        <Field data-invalid={!!errors?.coupon_code}>
          <InputGroup>
            <InputGroupAddon>
              <InputGroupText>
                <TicketPercentIcon aria-hidden="true" className="text-muted-foreground size-4" />
              </InputGroupText>
            </InputGroupAddon>
            <InputGroupInput name="coupon_code" placeholder="Coupon code" defaultValue={cart.coupon_code ?? ""} />
            <InputGroupAddon align="inline-end">
              <InputGroupButton type="submit" size="sm">
                Apply
              </InputGroupButton>
            </InputGroupAddon>
          </InputGroup>
          {errors?.coupon_code ? <FieldError>{errors.coupon_code}</FieldError> : null}
        </Field>
      </Form>

      {/* ponytail: real Apple Pay / PayPal SDKs are not wired — icons only, mount point for later. */}
      <Button type="button" variant="outline" className="mt-4 w-full" disabled>
        Express Checkout
      </Button>

      <Button size="lg" className="mt-2 w-full" render={<Link href="/checkout/R123456789" />}>
        Checkout
      </Button>
      <Button variant="link" className="mt-1 w-full" render={<Link href="/products" />}>
        Continue Shopping
      </Button>
    </div>
  )
}

export default function Cart({ cart }: { cart: Cart }) {
  const hasItems = cart.line_items.length > 0

  return (
    <main className="mx-auto w-full max-w-6xl px-4 py-6 sm:px-8 sm:py-10">
      <Head title="Cart" />
      <h1 className="text-foreground mb-6 text-2xl font-semibold tracking-tight sm:mb-8">
        Shopping Cart
      </h1>

      {hasItems ? (
        <div className="grid gap-6 lg:grid-cols-[minmax(0,1fr)_360px] lg:items-start lg:gap-10">
          <ul role="list" className="divide-border divide-y">
            {cart.line_items.map((item) => (
              <CartItemRow key={item.id} item={item} />
            ))}
          </ul>
          <div className="lg:sticky lg:top-6">
            <OrderSummary cart={cart} />
          </div>
        </div>
      ) : (
        <Empty className="min-h-[320px] justify-center py-10">
          <EmptyHeader>
            <EmptyMedia variant="icon">
              <ShoppingCartIcon aria-hidden="true" className="size-5" />
            </EmptyMedia>
            <EmptyTitle>Your Cart Is Empty</EmptyTitle>
            <EmptyDescription>Items you add will appear here.</EmptyDescription>
          </EmptyHeader>
          <EmptyContent>
            <Button size="sm" render={<Link href="/products" />}>
              Continue Shopping
            </Button>
          </EmptyContent>
        </Empty>
      )}
    </main>
  )
}
