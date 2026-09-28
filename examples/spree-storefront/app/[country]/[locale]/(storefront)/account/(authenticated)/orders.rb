# frozen_string_literal: true

# reui: profile-8
#
# <h1>
# <InvoiceHistoryCard>                        # blocks/profile-8/invoice-history-card
#   <Table>                                   # number / date / status / payment / total
#     <Badge>                                 # reui/badge — order state
#     <Button>                                # view order
# <Empty>                                     # ui/empty — no orders

helpers do
  # ponytail: fixture props, swap for the Spree Store API call when it is wired
  def fixture_orders
    [
      {
        id:      "1",
        number:  "R123456789",
        placed_on: "Sep 12, 2026",
        state:   { label: "Delivered", variant: "success-light" },
        payment: { label: "Paid", variant: "success-light" },
        total:   "$128.40",
      },
      {
        id:      "2",
        number:  "R123456720",
        placed_on: "Aug 30, 2026",
        state:   { label: "Shipped", variant: "info-light" },
        payment: { label: "Paid", variant: "success-light" },
        total:   "$64.00",
      },
      {
        id:      "3",
        number:  "R123456601",
        placed_on: "Jul 4, 2026",
        state:   { label: "Cancelled", variant: "destructive-light" },
        payment: { label: "Refunded", variant: "outline" },
        total:   "$42.90",
      },
    ]
  end
end

get "/" do
  inertia("[country]/[locale]/(storefront)/account/(authenticated)/orders", props: {
    customer: fixture_customer,
    orders:   fixture_orders,
  })
end

__END__

import { Head, Link, usePage } from "@inertiajs/react"

import { Badge } from "@/components/reui/badge"
import { Button } from "@/components/ui/button"
import { Card, CardContent } from "@/components/ui/card"
import { Empty, EmptyDescription, EmptyHeader, EmptyMedia, EmptyTitle } from "@/components/ui/empty"
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table"
import { ShoppingBagIcon } from "lucide-react"

type Order = {
  id: string
  number: string
  placed_on: string
  state: { label: string; variant: string }
  payment: { label: string; variant: string }
  total: string
}

export default function Orders({ orders }: { orders: Order[] }) {
  const { url } = usePage()

  return (
    <div className="space-y-6">
      <Head title="Orders" />
      <h1 className="text-2xl font-semibold tracking-tight">Orders</h1>

      {orders.length === 0 ? (
        <Empty>
          <EmptyHeader>
            <EmptyMedia variant="icon">
              <ShoppingBagIcon aria-hidden="true" />
            </EmptyMedia>
            <EmptyTitle>No orders yet</EmptyTitle>
            <EmptyDescription>Orders you place show up here.</EmptyDescription>
          </EmptyHeader>
        </Empty>
      ) : (
        <Card className="gap-0 p-0">
          <CardContent className="p-0">
            <div className="overflow-x-auto">
              <Table className="min-w-[42rem]">
                <TableHeader>
                  <TableRow>
                    <TableHead>Order</TableHead>
                    <TableHead>Date</TableHead>
                    <TableHead>Status</TableHead>
                    <TableHead>Payment</TableHead>
                    <TableHead className="text-right">Total</TableHead>
                    <TableHead className="text-right">
                      <span className="sr-only">View</span>
                    </TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {orders.map((order) => (
                    <TableRow key={order.id}>
                      <TableCell className="font-medium whitespace-nowrap">#{order.number}</TableCell>
                      <TableCell className="text-muted-foreground whitespace-nowrap">{order.placed_on}</TableCell>
                      <TableCell>
                        <Badge variant={order.state.variant as never}>{order.state.label}</Badge>
                      </TableCell>
                      <TableCell>
                        <Badge variant={order.payment.variant as never}>{order.payment.label}</Badge>
                      </TableCell>
                      <TableCell className="text-right font-semibold tabular-nums">{order.total}</TableCell>
                      <TableCell className="text-right">
                        <Button
                          variant="link"
                          size="sm"
                          render={<Link href={`${url}/${order.id}`} />}
                        >
                          View
                        </Button>
                      </TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            </div>
          </CardContent>
        </Card>
      )}
    </div>
  )
}
