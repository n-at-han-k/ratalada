# frozen_string_literal: true

# reui: receipt-1, solution-inventory-4
#
# <Link>                                      # back to orders
# <Receipt>                                   # blocks/receipt-1/receipt
#   <h1>                                      # order number
#   <p>                                       # placed at
#   <Item>                                    # line item rows
#   <dl>                                      # totals
#   <dl>                                      # shipping + billing address
#   <Badge>                                   # reui/badge — payment state
# <PoLineItems>                               # blocks/solution-inventory-4/po-line-items — per shipment
# <PoActivity>                                # blocks/solution-inventory-4/po-activity — tracking timeline
# <Empty>                                     # ui/empty — order not found

helpers do
  # ponytail: fixture props, swap for the Spree Store API call when it is
  # wired. Keyed by the same ids as fixture_orders in ../orders.rb.
  def fixture_order(id)
    {
      "1" => {
        id:             "1",
        number:         "R123456789",
        placed_on:      "September 12, 2026 at 3:41 PM",
        payment_state:  { label: "Paid", variant: "success-light" },
        customer_email: fixture_customer[:email],
        items: [
          { id: "1", name: "Canvas Weekender Bag", variant: "Sand",  quantity: 1, price: "$88.00" },
          { id: "2", name: "Wool Beanie",           variant: "Grey", quantity: 2, price: "$20.20" },
        ],
        totals: { subtotal: "$128.40", shipping: "Free", tax: "$0.00", total: "$128.40" },
        ship_address: { name: "Jordan Avery", line1: "742 Evergreen Terrace", city: "Springfield", state: "OR", postal_code: "97403" },
        bill_address: { name: "Jordan Avery", line1: "742 Evergreen Terrace", city: "Springfield", state: "OR", postal_code: "97403" },
        shipment: {
          carrier:         "UPS",
          service:         "Ground",
          tracking_number: "1Z999AA10123456784",
          events: [
            { id: 1, title: "Delivered",   at: "Sep 16, 2026, 1:12 PM", status: "completed", description: "Left at front door." },
            { id: 2, title: "Out for delivery", at: "Sep 16, 2026, 8:03 AM", status: "completed", description: "On vehicle for delivery." },
            { id: 3, title: "Shipped",      at: "Sep 13, 2026, 6:40 PM", status: "completed", description: "Departed UPS facility." },
            { id: 4, title: "Order placed", at: "Sep 12, 2026, 3:41 PM", status: "completed", description: "Payment confirmed." },
          ],
        },
      },
    }[id]
  end
end

get "/" do
  order = fixture_order(params["id"])

  inertia("[country]/[locale]/(storefront)/account/(authenticated)/orders/[id]", props: {
    customer: fixture_customer,
    order:    order,
  })
end

__END__

import { Head, Link, usePage } from "@inertiajs/react"

import { Badge } from "@/components/reui/badge"
import {
  Timeline,
  TimelineContent,
  TimelineHeader,
  TimelineIndicator,
  TimelineItem,
  TimelineSeparator,
  TimelineTitle,
} from "@/components/reui/timeline"
import {
  Card,
  CardContent,
  CardFooter,
  CardHeader,
  CardTitle,
} from "@/components/ui/card"
import { Empty, EmptyDescription, EmptyHeader, EmptyMedia, EmptyTitle } from "@/components/ui/empty"
import { Separator } from "@/components/ui/separator"
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table"
import { ChevronLeftIcon, CircleCheckIcon, PackageSearchIcon } from "lucide-react"

type Address = { name: string; line1: string; city: string; state: string; postal_code: string }
type LineItem = { id: string; name: string; variant: string; quantity: number; price: string }
type TrackingEvent = { id: number; title: string; at: string; status: string; description: string }

type Order = {
  id: string
  number: string
  placed_on: string
  payment_state: { label: string; variant: string }
  customer_email: string
  items: LineItem[]
  totals: { subtotal: string; shipping: string; tax: string; total: string }
  ship_address: Address
  bill_address: Address
  shipment: { carrier: string; service: string; tracking_number: string; events: TrackingEvent[] }
}

function AddressBlock({ label, address }: { label: string; address: Address }) {
  return (
    <div>
      <p className="text-muted-foreground text-xs font-medium tracking-[0.16em] uppercase">{label}</p>
      <address className="text-sm leading-snug not-italic">
        <p className="font-medium">{address.name}</p>
        <p className="text-muted-foreground">{address.line1}</p>
        <p className="text-muted-foreground">
          {address.city}, {address.state} {address.postal_code}
        </p>
      </address>
    </div>
  )
}

export default function Order({ order }: { order: Order | null }) {
  const { url } = usePage()
  const backHref = url.replace(/\/orders\/.+$/, "/orders")

  return (
    <div className="space-y-4">
      <Head title={order ? `Order ${order.number}` : "Order"} />

      <Link href={backHref} className="text-muted-foreground hover:text-foreground inline-flex items-center gap-1 text-sm">
        <ChevronLeftIcon className="size-4" aria-hidden="true" />
        Back to orders
      </Link>

      {!order ? (
        <Empty>
          <EmptyHeader>
            <EmptyMedia variant="icon">
              <PackageSearchIcon aria-hidden="true" />
            </EmptyMedia>
            <EmptyTitle>Order not found</EmptyTitle>
            <EmptyDescription>We couldn&apos;t find that order on your account.</EmptyDescription>
          </EmptyHeader>
        </Empty>
      ) : (
        <>
          <Card>
            <CardHeader>
              <div className="flex flex-wrap items-start justify-between gap-4">
                <div className="space-y-2">
                  <Badge variant={order.payment_state.variant as never}>
                    <CircleCheckIcon className="size-3.5" aria-hidden="true" />
                    {order.payment_state.label}
                  </Badge>
                  <CardTitle className="text-2xl tracking-tight">Order #{order.number}</CardTitle>
                  <p className="text-muted-foreground text-sm">
                    Placed {order.placed_on} &middot; sent to {order.customer_email}
                  </p>
                </div>
              </div>
            </CardHeader>

            <CardContent className="space-y-6">
              <div className="grid grid-cols-1 gap-5 sm:grid-cols-2">
                <AddressBlock label="Shipping address" address={order.ship_address} />
                <AddressBlock label="Billing address" address={order.bill_address} />
              </div>

              <Separator />

              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>Item</TableHead>
                    <TableHead className="text-right">Qty</TableHead>
                    <TableHead className="text-right">Price</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {order.items.map((item) => (
                    <TableRow key={item.id}>
                      <TableCell>
                        <p className="font-medium">{item.name}</p>
                        <p className="text-muted-foreground text-xs">{item.variant}</p>
                      </TableCell>
                      <TableCell className="text-right tabular-nums">{item.quantity}</TableCell>
                      <TableCell className="text-right tabular-nums">{item.price}</TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>

              <Separator />

              <dl className="flex flex-col gap-2 self-end text-sm sm:min-w-72 sm:ml-auto">
                <div className="flex items-baseline justify-between gap-4">
                  <dt className="text-muted-foreground">Subtotal</dt>
                  <dd className="tabular-nums">{order.totals.subtotal}</dd>
                </div>
                <div className="flex items-baseline justify-between gap-4">
                  <dt className="text-muted-foreground">Shipping</dt>
                  <dd className="tabular-nums">{order.totals.shipping}</dd>
                </div>
                <div className="flex items-baseline justify-between gap-4">
                  <dt className="text-muted-foreground">Estimated tax</dt>
                  <dd className="tabular-nums">{order.totals.tax}</dd>
                </div>
                <Separator className="my-1" />
                <div className="flex items-baseline justify-between gap-4">
                  <dt className="text-base font-semibold">Total</dt>
                  <dd className="text-base font-semibold tabular-nums">{order.totals.total}</dd>
                </div>
              </dl>
            </CardContent>

            <CardFooter className="text-muted-foreground text-sm">
              {order.shipment.carrier} {order.shipment.service} &middot; tracking {order.shipment.tracking_number}
            </CardFooter>
          </Card>

          <Card className="gap-0 p-0">
            <CardHeader className="px-5 py-4 sm:px-6">
              <CardTitle>Tracking</CardTitle>
            </CardHeader>
            <CardContent className="px-5 pb-5 sm:px-6">
              <Timeline defaultValue={0} aria-label="Shipment tracking">
                {order.shipment.events.map((event, index) => (
                  <TimelineItem key={event.id} step={event.id}>
                    <TimelineHeader>
                      {index === order.shipment.events.length - 1 ? null : <TimelineSeparator />}
                      <TimelineTitle>{event.title}</TimelineTitle>
                      <TimelineIndicator />
                    </TimelineHeader>
                    <TimelineContent>
                      <p className="text-muted-foreground text-xs tabular-nums">{event.at}</p>
                      <p className="text-muted-foreground mt-1 text-xs leading-5">{event.description}</p>
                    </TimelineContent>
                  </TimelineItem>
                ))}
              </Timeline>
            </CardContent>
          </Card>
        </>
      )}
    </div>
  )
}
