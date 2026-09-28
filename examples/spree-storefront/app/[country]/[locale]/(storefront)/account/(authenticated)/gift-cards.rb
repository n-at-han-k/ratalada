# frozen_string_literal: true

# reui: coupon-4
#
# <h1>
# <Coupon>                                    # blocks/coupon-4/coupon — one per gift card
#   <span>                                    # code
#   <Button>                                  # copy — hooks/use-copy-to-clipboard
#   <Badge>                                   # reui/badge — balance / expiry
# <Empty>                                     # ui/empty — no gift cards

helpers do
  # ponytail: fixture props, swap for the Spree Store API call when it is wired
  def fixture_gift_cards
    [
      { code: "GIFT-4F2A-9K1P", balance: "$50.00", expires_on: "Dec 2026" },
      { code: "GIFT-88ZQ-3T0X", balance: "$12.50", expires_on: "Jun 2027" },
    ]
  end
end

get "/" do
  inertia("[country]/[locale]/(storefront)/account/(authenticated)/gift-cards", props: {
    customer:   fixture_customer,
    gift_cards: fixture_gift_cards,
  })
end

__END__

import { Head } from "@inertiajs/react"

import { Badge } from "@/components/reui/badge"
import { Button } from "@/components/ui/button"
import { Card } from "@/components/ui/card"
import { Empty, EmptyDescription, EmptyHeader, EmptyMedia, EmptyTitle } from "@/components/ui/empty"
import { Item, ItemActions, ItemContent, ItemTitle } from "@/components/ui/item"
import { useCopyToClipboard } from "@/hooks/use-copy-to-clipboard"
import { CheckIcon, CopyIcon, GiftIcon } from "lucide-react"

type GiftCard = { code: string; balance: string; expires_on: string }

function GiftCardItem({ card }: { card: GiftCard }) {
  const { isCopied, copyToClipboard } = useCopyToClipboard()

  return (
    <Card className="flex-row items-center gap-4 p-4">
      <Item variant="muted" size="sm" className="border-border bg-muted/25 min-w-0 flex-1 border border-dashed">
        <ItemContent className="min-w-0 gap-0.5">
          <span className="text-muted-foreground text-[0.625rem] font-semibold tracking-wider uppercase">
            Gift card
          </span>
          <ItemTitle className="font-mono text-lg font-semibold tracking-[0.1em] uppercase select-all">
            {card.code}
          </ItemTitle>
        </ItemContent>
        <ItemActions>
          <Button
            type="button"
            variant={isCopied ? "secondary" : "outline"}
            size="sm"
            onClick={() => copyToClipboard(card.code)}
            aria-label={isCopied ? "Code copied" : `Copy code ${card.code}`}
          >
            {isCopied ? <CheckIcon aria-hidden="true" /> : <CopyIcon aria-hidden="true" />}
            {isCopied ? "Copied" : "Copy"}
          </Button>
        </ItemActions>
      </Item>

      <div className="flex shrink-0 flex-col items-end gap-1.5">
        <Badge variant="success-light">{card.balance}</Badge>
        <Badge variant="outline">Expires {card.expires_on}</Badge>
      </div>
    </Card>
  )
}

export default function GiftCards({ gift_cards }: { gift_cards: GiftCard[] }) {
  return (
    <div className="space-y-6">
      <Head title="Gift cards" />
      <h1 className="text-2xl font-semibold tracking-tight">Gift cards</h1>

      {gift_cards.length === 0 ? (
        <Empty>
          <EmptyHeader>
            <EmptyMedia variant="icon">
              <GiftIcon aria-hidden="true" />
            </EmptyMedia>
            <EmptyTitle>No gift cards</EmptyTitle>
            <EmptyDescription>Gift cards applied to your account show up here.</EmptyDescription>
          </EmptyHeader>
        </Empty>
      ) : (
        <div className="space-y-4">
          {gift_cards.map((card) => (
            <GiftCardItem key={card.code} card={card} />
          ))}
        </div>
      )}
    </div>
  )
}
