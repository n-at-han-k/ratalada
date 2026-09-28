# frozen_string_literal: true

# reui: shopping-cart-4
#
# <WholesaleHeader>                           # blocks/navbar-12/navbar, trimmed
# <Cart>                                      # blocks/shopping-cart-4/cart
#   <CartItemRow>                             # blocks/shopping-cart-4/cart-item-row
#     <p>                                     # sku / case pack / unit price
#     <NumberField>                           # reui/number-field
#     <Button>                                # remove
#   <OrderSummary>                            # blocks/shopping-cart-4/order-summary
#     <Button>                                # checkout
#     <Button>                                # browse catalog
# <Empty>                                     # ui/empty — empty cart

# ponytail: fixture props. Two of the five catalog products, pre-added, so
# the cart page has something to render -- swap for the Store API cart the
# wholesale-bound CartProvider reads in the reference once it's wired.
def wholesale_cart_lines
  [
    wholesale_product("case-of-mugs").merge(cases: 3),
    wholesale_product("olive-wood-board-case").merge(cases: 1),
  ]
end

get "/" do
  gate = wholesale_status

  inertia("[country]/[locale]/(wholesale)/wholesale/cart", props: {
    gate:     gate,
    customer: gate == "guest" ? nil : wholesale_customer,
    lines:    gate == "approved" ? wholesale_cart_lines : [],
  })
end

# One route branching on `action`, mirroring the storefront cart.rb: this
# file only owns /wholesale/cart, and nothing here persists (no backend cart
# yet) -- each action just bounces back to the cart page.
post "/" do
  case params["action"]
  when "update_cases", "remove"
    # ponytail: swap for a Store API cart line-item update/remove call.
  end

  redirect("/wholesale/cart", 303)
end

__END__

import { Form, Head, Link } from "@inertiajs/react"
import { ShoppingCartIcon, XIcon } from "lucide-react"

import {
  WholesaleApplicationPending,
  WholesaleHeader,
  WholesaleSignInWall,
} from "@/components/wholesale"
import {
  NumberField,
  NumberFieldDecrement,
  NumberFieldGroup,
  NumberFieldIncrement,
  NumberFieldInput,
} from "@/components/reui/number-field"
import { Button } from "@/components/ui/button"
import { Empty, EmptyContent, EmptyDescription, EmptyHeader, EmptyMedia, EmptyTitle } from "@/components/ui/empty"

interface CartLine {
  slug: string
  name: string
  sku: string
  category: string
  case_pack: number
  trade_price: number
  retail_price: number
  image: string
  cases: number
}

const money = (value: number) => `$${value.toFixed(2)}`

function CartItemRow({ line }: { line: CartLine }) {
  const units = line.cases * line.case_pack
  const total = units * line.trade_price

  return (
    <li className="flex gap-4 py-5 first:pt-0 last:pb-0">
      <img
        src={line.image}
        alt={line.name}
        className="size-20 shrink-0 rounded-lg bg-slate-100 object-cover sm:size-24"
        loading="lazy"
      />
      <div className="flex min-w-0 flex-1 flex-col gap-2">
        <div className="flex items-start justify-between gap-3">
          <div className="min-w-0">
            <h3 className="text-sm font-semibold text-slate-900 sm:text-base">{line.name}</h3>
            <p className="mt-0.5 text-xs text-slate-500">
              SKU {line.sku} · case of {line.case_pack} · {money(line.trade_price)} / unit
            </p>
          </div>
          <Form action="/wholesale/cart" method="post">
            <input type="hidden" name="action" value="remove" />
            <input type="hidden" name="slug" value={line.slug} />
            <Button
              variant="ghost"
              size="icon-sm"
              type="submit"
              aria-label={`Remove ${line.name} from cart`}
              className="-mt-1 -mr-1 shrink-0 text-slate-400 hover:text-destructive"
            >
              <XIcon aria-hidden="true" />
            </Button>
          </Form>
        </div>

        <div className="mt-auto flex flex-wrap items-center justify-between gap-3">
          <Form action="/wholesale/cart" method="post" className="flex items-center gap-2">
            <input type="hidden" name="action" value="update_cases" />
            <input type="hidden" name="slug" value={line.slug} />
            <NumberField name="cases" defaultValue={line.cases} min={1} size="sm">
              <NumberFieldGroup>
                <NumberFieldDecrement />
                <NumberFieldInput />
                <NumberFieldIncrement />
              </NumberFieldGroup>
            </NumberField>
            <span className="text-xs text-slate-500">{units} units</span>
            <Button variant="outline" size="sm" type="submit">
              Update
            </Button>
          </Form>
          <p className="text-sm font-semibold tabular-nums text-slate-900 sm:text-base">{money(total)}</p>
        </div>
      </div>
    </li>
  )
}

function OrderSummary({ lines }: { lines: CartLine[] }) {
  const total = lines.reduce((sum, line) => sum + line.cases * line.case_pack * line.trade_price, 0)

  return (
    <div className="rounded-lg border border-slate-200 bg-white p-5 sm:p-6">
      <h2 className="text-sm font-semibold text-slate-900">Order summary</h2>
      <dl className="mt-4 flex flex-col gap-2 text-sm">
        <div className="flex justify-between">
          <dt className="text-slate-500">Subtotal</dt>
          <dd className="tabular-nums">{money(total)}</dd>
        </div>
        <div className="flex justify-between text-base font-semibold">
          <dt>Total</dt>
          <dd className="tabular-nums">{money(total)}</dd>
        </div>
      </dl>
      <Button size="lg" className="mt-4 w-full bg-slate-900 hover:bg-slate-800" render={<Link href="/checkout/wholesale" />}>
        Checkout
      </Button>
      <Button variant="outline" className="mt-2 w-full" render={<Link href="/wholesale" />}>
        Browse catalog
      </Button>
    </div>
  )
}

export default function WholesaleCart({
  gate,
  customer,
  lines,
}: {
  gate: "guest" | "pending" | "approved"
  customer: { name: string; email: string; company: string } | null
  lines: CartLine[]
}) {
  if (gate === "guest") {
    return (
      <>
        <Head title="Wholesale cart" />
        <WholesaleSignInWall />
      </>
    )
  }

  if (gate === "pending" && customer) {
    return (
      <>
        <Head title="Wholesale cart" />
        <WholesaleApplicationPending customer={customer} />
      </>
    )
  }

  return (
    <div className="min-h-screen bg-slate-50">
      <Head title="Wholesale cart" />
      <WholesaleHeader customerName={customer?.name} cartCount={lines.length} />
      <div className="mx-auto max-w-6xl px-4 py-8 sm:px-6 lg:px-8">
        <h1 className="mb-8 text-3xl font-bold text-slate-900">Cart</h1>

        {lines.length === 0 ? (
          <Empty className="rounded-lg border border-dashed border-slate-200 bg-white">
            <EmptyHeader>
              <EmptyMedia variant="icon">
                <ShoppingCartIcon />
              </EmptyMedia>
              <EmptyTitle>Your cart is empty</EmptyTitle>
              <EmptyDescription>Add case packs from the catalog to get started.</EmptyDescription>
            </EmptyHeader>
            <EmptyContent>
              <Button render={<Link href="/wholesale" />}>Browse catalog</Button>
            </EmptyContent>
          </Empty>
        ) : (
          <div className="grid grid-cols-1 gap-8 lg:grid-cols-3">
            <ul className="divide-y divide-slate-200 rounded-lg border border-slate-200 bg-white px-6 lg:col-span-2">
              {lines.map((line) => (
                <CartItemRow key={line.slug} line={line} />
              ))}
            </ul>
            <OrderSummary lines={lines} />
          </div>
        )}
      </div>
    </div>
  )
}
