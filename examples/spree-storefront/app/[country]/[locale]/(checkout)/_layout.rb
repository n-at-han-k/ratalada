# frozen_string_literal: true

# reui: checkout-5, shopping-cart-4
#
# <header>                                    # trimmed header: logo + back to cart
#   <Link>
#     <Image>
#   <Link>
# <MobileSummaryToggle>                       # ui/accordion wrapping the summary
#   <OrderSummary>                            # blocks/shopping-cart-4/order-summary
# {children}
# <OrderSummary>                              # desktop sidebar, same block
# <footer>
#   <Link>                                    # policy links

__END__

import type { PropsWithChildren } from "react"
import { Link, usePage } from "@inertiajs/react"

import {
  Accordion,
  AccordionContent,
  AccordionItem,
  AccordionTrigger,
} from "@/components/ui/accordion"
import { Separator } from "@/components/ui/separator"

const POLICY_LINKS = [
  { name: "Shipping Policy", slug: "shipping-policy" },
  { name: "Privacy Policy", slug: "privacy-policy" },
  { name: "Returns Policy", slug: "returns-policy" },
  { name: "Terms of Service", slug: "terms-of-service" },
]

interface OrderSummaryData {
  display_item_total: string
  display_delivery_total: string
  display_tax_total: string
  display_total: string
}

// The order summary lives on every checkout-flow page's props under
// `order`, keyed the same way as the Spree order the reference storefront
// renders. confirm-payment has none (just a spinner) and order-placed asks
// to hide it (the page already shows the full receipt) — in both cases we
// render nothing, same as the reference's `summaryContent === null` check.
function OrderSummary({ order }: { order: OrderSummaryData }) {
  return (
    <dl className="flex flex-col gap-2 text-sm">
      <div className="flex justify-between">
        <dt className="text-muted-foreground">Subtotal</dt>
        <dd className="tabular-nums">{order.display_item_total}</dd>
      </div>
      <div className="flex justify-between">
        <dt className="text-muted-foreground">Shipping</dt>
        <dd className="tabular-nums">{order.display_delivery_total}</dd>
      </div>
      <div className="flex justify-between">
        <dt className="text-muted-foreground">Tax</dt>
        <dd className="tabular-nums">{order.display_tax_total}</dd>
      </div>
      <Separator className="my-1" />
      <div className="flex justify-between text-base font-semibold">
        <dt>Total</dt>
        <dd className="tabular-nums">{order.display_total}</dd>
      </div>
    </dl>
  )
}

export default function CheckoutLayout({ children }: PropsWithChildren) {
  const { order, hide_summary } = usePage().props as {
    order?: OrderSummaryData
    hide_summary?: boolean
  }
  const summary = !hide_summary && order ? <OrderSummary order={order} /> : null

  return (
    <div className="mx-auto flex min-h-screen w-full max-w-6xl flex-col px-4 py-6 sm:px-8">
      <header className="mb-6 flex items-center justify-between">
        <Link href="/" className="flex items-center">
          <img src="/spree.png" alt="Store" width={90} height={32} />
        </Link>
        <Link href="/cart" className="text-muted-foreground hover:text-foreground text-sm">
          Back to Cart
        </Link>
      </header>

      {summary ? (
        <Accordion className="mb-6 rounded-lg border lg:hidden">
          <AccordionItem value="summary">
            <AccordionTrigger className="px-4">Order Summary</AccordionTrigger>
            <AccordionContent className="px-4 pb-4">{summary}</AccordionContent>
          </AccordionItem>
        </Accordion>
      ) : null}

      <div className="grid flex-1 items-start gap-10 lg:grid-cols-[minmax(0,1fr)_340px]">
        <div className="min-w-0">{children}</div>
        {summary ? (
          <div className="hidden rounded-lg border p-6 lg:sticky lg:top-6 lg:block">{summary}</div>
        ) : null}
      </div>

      <footer className="text-muted-foreground mt-10 flex flex-wrap items-center gap-x-3 gap-y-1 border-t pt-4 text-xs">
        <p>&copy; {new Date().getFullYear()} Store. All rights reserved.</p>
        {POLICY_LINKS.map((policy) => (
          <Link
            key={policy.slug}
            href={`/policies/${policy.slug}`}
            className="text-muted-foreground hover:text-foreground underline"
          >
            {policy.name}
          </Link>
        ))}
      </footer>
    </div>
  )
}
