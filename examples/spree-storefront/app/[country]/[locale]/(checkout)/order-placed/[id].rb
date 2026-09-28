# frozen_string_literal: true

# reui: receipt-1
#
# <Receipt>                                   # blocks/receipt-1/receipt
#   <CircleCheckBig>
#   <h1>                                      # thank you + order number
#   <p>                                       # email confirmation
#   <Item>                                    # line item rows
#   <dl>                                      # totals
#   <dl>                                      # shipping method / payment
#   <dl>                                      # shipping + billing address
# <Empty>                                     # ui/empty — order not found

# ponytail: fixture props, swap for the Spree Store API "get completed order"
# call when it is wired. Order id "404" is kept as the not-found demo path.
def fixture_order
  return nil if params["id"] == "404"

  {
    id:                params["id"],
    number:            "R123456789",
    email:             "jordan@example.com",
    line_items:        [
      { id: "li_1", name: "Lumen Compact Camera", options_text: "Color: Red", quantity: 1, display_total: "$99.89" },
      { id: "li_2", name: "Velar Wireless Headphones", options_text: "Color: Dark Blue", quantity: 2, display_total: "$143.38" },
    ],
    display_item_total:     "$243.27",
    display_delivery_total: "$0.00",
    display_tax_total:      "$17.03",
    display_total:          "$260.30",
    ship_address:      { name: "Jordan Reeves", line1: "180 Bedford Avenue", line2: "Apt 4F", city: "Brooklyn", state: "NY", zip: "11211", country: "United States" },
    bill_address:      { name: "Jordan Reeves", line1: "180 Bedford Avenue", line2: "Apt 4F", city: "Brooklyn", state: "NY", zip: "11211", country: "United States" },
    payments:          [{ method: "Visa", last4: "4242", status: "completed" }],
    shipments:         [{ method: "Standard", display_cost: "Free" }],
  }
end

get "/" do
  inertia("[country]/[locale]/(checkout)/order-placed/[id]", props: {
    order:        fixture_order,
    hide_summary: true, # the page below already shows the full order — no sidebar duplicate
  })
end

__END__

import { Head, Link } from "@inertiajs/react"
import { CircleCheckBig, PackageIcon } from "lucide-react"

import { Button } from "@/components/ui/button"
import {
  Empty,
  EmptyContent,
  EmptyDescription,
  EmptyHeader,
  EmptyMedia,
  EmptyTitle,
} from "@/components/ui/empty"

interface Address {
  name: string
  line1: string
  line2: string
  city: string
  state: string
  zip: string
  country: string
}

interface Order {
  id: string
  number: string
  email: string
  line_items: { id: string; name: string; options_text: string; quantity: number; display_total: string }[]
  display_item_total: string
  display_delivery_total: string
  display_tax_total: string
  display_total: string
  ship_address: Address
  bill_address: Address
  payments: { method: string; last4: string; status: string }[]
  shipments: { method: string; display_cost: string }[]
}

function AddressBlock({ label, address }: { label: string; address: Address }) {
  return (
    <div className="flex flex-col gap-2">
      <p className="text-muted-foreground text-xs font-medium tracking-widest uppercase">{label}</p>
      <address className="text-foreground text-sm leading-snug not-italic">
        <p className="font-medium">{address.name}</p>
        <p className="text-muted-foreground">{address.line1}{address.line2 ? `, ${address.line2}` : ""}</p>
        <p className="text-muted-foreground">{address.city}, {address.state} {address.zip}</p>
        <p className="text-muted-foreground">{address.country}</p>
      </address>
    </div>
  )
}

export default function OrderPlaced({ order }: { order: Order | null }) {
  if (!order) {
    return (
      <>
        <Head title="Order not found" />
        <Empty className="min-h-[320px] justify-center py-10">
          <EmptyHeader>
            <EmptyMedia variant="icon">
              <PackageIcon aria-hidden="true" className="size-5" />
            </EmptyMedia>
            <EmptyTitle>Order Not Found</EmptyTitle>
            <EmptyDescription>We couldn&apos;t find that order.</EmptyDescription>
          </EmptyHeader>
          <EmptyContent>
            <Button size="sm" render={<Link href="/" />}>
              Continue Shopping
            </Button>
          </EmptyContent>
        </Empty>
      </>
    )
  }

  return (
    <div className="mx-auto flex max-w-2xl flex-col gap-6 py-4">
      <Head title="Order placed" />

      <div className="flex flex-col items-center gap-2 text-center">
        <CircleCheckBig className="text-success size-14" aria-hidden="true" />
        <h1 className="text-foreground text-2xl font-semibold">Thanks for your order</h1>
        <p className="text-muted-foreground text-sm">Order {order.number}</p>
        <p className="text-muted-foreground text-xs">A confirmation was sent to {order.email}</p>
      </div>

      <div className="rounded-lg border">
        <ul className="divide-border divide-y">
          {order.line_items.map((item) => (
            <li key={item.id} className="flex items-center justify-between gap-4 px-5 py-4">
              <div>
                <p className="text-foreground text-sm font-medium">{item.name}</p>
                <p className="text-muted-foreground text-xs">{item.options_text} · Qty {item.quantity}</p>
              </div>
              <p className="text-foreground text-sm font-medium tabular-nums">{item.display_total}</p>
            </li>
          ))}
        </ul>
        <dl className="flex flex-col gap-2 border-t p-5 text-sm">
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
          <div className="flex justify-between text-base font-semibold">
            <dt>Total</dt>
            <dd className="tabular-nums">{order.display_total}</dd>
          </div>
        </dl>
      </div>

      <div className="grid gap-6 rounded-lg border p-5 sm:grid-cols-2">
        <div>
          <h3 className="text-foreground mb-2 text-sm font-semibold">Shipping method</h3>
          {order.shipments.map((shipment) => (
            <p key={shipment.method} className="text-muted-foreground text-sm">
              {shipment.method} · {shipment.display_cost}
            </p>
          ))}
        </div>
        <div>
          <h3 className="text-foreground mb-2 text-sm font-semibold">Payment</h3>
          {order.payments.map((payment) => (
            <p key={payment.last4} className="text-muted-foreground text-sm">
              {payment.method} ending {payment.last4}
            </p>
          ))}
        </div>
      </div>

      <div className="grid gap-6 rounded-lg border p-5 sm:grid-cols-2">
        <AddressBlock label="Shipping address" address={order.ship_address} />
        <AddressBlock label="Billing address" address={order.bill_address} />
      </div>

      <div className="text-center">
        <Button size="lg" render={<Link href="/" />}>
          Continue Shopping
        </Button>
      </div>
    </div>
  )
}
