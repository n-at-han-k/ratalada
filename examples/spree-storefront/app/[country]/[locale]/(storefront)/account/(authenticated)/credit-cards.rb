# frozen_string_literal: true

# reui: solution-billing-4
#
# <h1>
# <PaymentMethodsCard>                        # blocks/solution-billing-4/payment-methods-card
#   <PaymentMethodsRow>                       # blocks/solution-billing-4/payment-methods-row
#     <BillingIconTile>                       # blocks/solution-billing-4/billing-icon-tile — brand
#     <p>                                     # last4 + expiry
#     <Badge>                                 # reui/badge — default
#     <AlertDialog>                           # ui/alert-dialog — confirm delete
# <Empty>                                     # ui/empty — no cards

helpers do
  # ponytail: fixture props, swap for the Spree Store API call when it is wired
  def fixture_credit_cards
    [
      { id: "1", brand: "Visa", last4: "4242", expiry: "04/27", default: true },
      { id: "2", brand: "Mastercard", last4: "8210", expiry: "11/26", default: false },
    ]
  end
end

get "/" do
  inertia("[country]/[locale]/(storefront)/account/(authenticated)/credit-cards", props: {
    customer: fixture_customer,
    cards:    fixture_credit_cards,
  })
end

# ponytail: no Spree Store API wired, so this just redirects back --
# nothing is actually removed.
delete "/[id]" do
  redirect("/#{params['country']}/#{params['locale']}/account/credit-cards", 303)
end

__END__

import { Form, Head, usePage } from "@inertiajs/react"

import { BillingIconTile } from "@/components/blocks/solution-billing-4/components/billing-icon-tile"
import { Badge } from "@/components/reui/badge"
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
  AlertDialogTrigger,
} from "@/components/ui/alert-dialog"
import { Button } from "@/components/ui/button"
import { Card, CardContent } from "@/components/ui/card"
import { Empty, EmptyDescription, EmptyHeader, EmptyMedia, EmptyTitle } from "@/components/ui/empty"
import { CreditCardIcon } from "lucide-react"

type CreditCard = { id: string; brand: string; last4: string; expiry: string; default: boolean }

export default function CreditCards({ cards }: { cards: CreditCard[] }) {
  const { url } = usePage()

  return (
    <div className="space-y-6">
      <Head title="Credit cards" />
      <h1 className="text-2xl font-semibold tracking-tight">Credit cards</h1>

      {cards.length === 0 ? (
        <Empty>
          <EmptyHeader>
            <EmptyMedia variant="icon">
              <CreditCardIcon aria-hidden="true" />
            </EmptyMedia>
            <EmptyTitle>No cards saved</EmptyTitle>
            <EmptyDescription>Cards you save at checkout show up here.</EmptyDescription>
          </EmptyHeader>
        </Empty>
      ) : (
        <Card className="gap-0 p-0">
          <CardContent className="divide-y p-0">
            {cards.map((card) => (
              <div key={card.id} className="flex items-center gap-4 px-6 py-4">
                <BillingIconTile>
                  <CreditCardIcon aria-hidden="true" />
                </BillingIconTile>

                <div className="min-w-0 flex-1">
                  <p className="text-sm font-medium">
                    {card.brand} &middot;&middot;&middot;&middot; {card.last4}
                  </p>
                  <p className="text-muted-foreground text-sm">Expires {card.expiry}</p>
                </div>

                {card.default && <Badge>Default</Badge>}

                <AlertDialog>
                  <AlertDialogTrigger
                    render={<Button type="button" variant="ghost" size="sm" disabled={card.default} />}
                  >
                    Delete
                  </AlertDialogTrigger>
                  <AlertDialogContent size="sm">
                    <AlertDialogHeader>
                      <AlertDialogTitle>Remove this card?</AlertDialogTitle>
                      <AlertDialogDescription>
                        {card.brand} ending in {card.last4} will be removed from your account.
                      </AlertDialogDescription>
                    </AlertDialogHeader>
                    <AlertDialogFooter>
                      <AlertDialogCancel>Cancel</AlertDialogCancel>
                      <Form action={`${url}/${card.id}`} method="delete">
                        {({ processing }) => (
                          <AlertDialogAction type="submit" variant="destructive" disabled={processing}>
                            Remove card
                          </AlertDialogAction>
                        )}
                      </Form>
                    </AlertDialogFooter>
                  </AlertDialogContent>
                </AlertDialog>
              </div>
            ))}
          </CardContent>
        </Card>
      )}
    </div>
  )
}
