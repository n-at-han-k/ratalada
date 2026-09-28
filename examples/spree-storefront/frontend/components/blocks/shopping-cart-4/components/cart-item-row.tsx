import { Button } from "@/components/ui/button"
import {
  ButtonGroup,
  ButtonGroupText,
} from "@/components/ui/button-group"
import { Item } from "@/components/ui/item"
import {
  ToggleGroup,
  ToggleGroupItem,
} from "@/components/ui/toggle-group"
import {
  ECOMMERCE_LINK_CLASS_NAME,
  type CartItem,
  type FulfillmentMode,
  type FulfillmentOption,
} from "./data"
import { TruckIcon, StoreIcon, XIcon, MinusIcon, PlusIcon } from "lucide-react"

const formatCurrency = new Intl.NumberFormat("en-US", {
  style: "currency",
  currency: "USD",
})

function formatFulfillmentPrice(price: number) {
  if (price === 0) {
    return "Free"
  }
  return `+${formatCurrency.format(price)}`
}

function FulfillmentChoice({
  option,
  label,
}: {
  option: FulfillmentOption
  label: string
}) {
  const isDelivery = option.mode === "delivery"
  const priceLabel = formatFulfillmentPrice(option.price)

  return (
    <span className="flex items-center gap-1.5">
      {isDelivery ? (
        <TruckIcon aria-hidden="true" className="size-3.5 shrink-0" />
      ) : (
        <StoreIcon aria-hidden="true" className="size-3.5 shrink-0" />
      )}
      <span className="sr-only">{label}</span>
      <span className="tabular-nums">{option.date}</span>
      <span className="text-foreground font-semibold tabular-nums">
        {priceLabel}
      </span>
    </span>
  )
}

export function CartItemRow({
  item,
  priority,
  onDecrease,
  onIncrease,
  onRemove,
  onModeChange,
}: {
  item: CartItem
  priority?: boolean
  onDecrease: (itemId: string) => void
  onIncrease: (itemId: string) => void
  onRemove: (itemId: string) => void
  onModeChange: (itemId: string, mode: FulfillmentMode) => void
}) {
  const lineTotal = item.unitPrice * item.quantity

  return (
    <div className="grid grid-cols-[auto_minmax(0,1fr)] gap-3 sm:gap-4">
      {/* Thumbnail */}
      <a
        href="#"
        aria-label={`View ${item.name}`}
        className="focus-visible:ring-ring focus-visible:ring-offset-background shrink-0 outline-none focus-visible:ring-2 focus-visible:ring-offset-2"
      >
        <Item
          variant="muted"
          className="relative size-20 overflow-hidden p-0 sm:size-24"
        >
          <img
            src={item.image.src}
            alt={item.image.alt}
            className="absolute inset-0 h-full w-full object-cover transition-transform duration-300 ease-out group-hover/row:scale-105"
            loading={priority ? "eager" : "lazy"}
            fetchPriority={priority ? "high" : "auto"}
          />
        </Item>
      </a>

      {/* Content */}
      <div className="flex min-w-0 flex-col gap-2">
        {/* Title row */}
        <div className="flex items-start justify-between gap-3">
          <div className="min-w-0">
            <h3 className="text-foreground text-sm leading-tight font-semibold tracking-tight sm:text-base">
              <a href="#" className={ECOMMERCE_LINK_CLASS_NAME}>
                {item.name}
              </a>
            </h3>
            <p className="text-muted-foreground mt-0.5 flex flex-wrap items-center gap-x-1.5 text-xs">
              <span>Color</span>
              <span
                aria-hidden="true"
                className="bg-muted-foreground/40 size-1 shrink-0 rounded-full"
              />
              <a
                href="#"
                aria-label={`Filter by color ${item.color}`}
                className={`text-foreground font-medium ${ECOMMERCE_LINK_CLASS_NAME}`}
              >
                {item.color}
              </a>
            </p>
          </div>
          <Button
            variant="ghost"
            size="icon-sm"
            type="button"
            onClick={() => onRemove(item.id)}
            aria-label={`Remove ${item.name} from cart`}
            className="text-muted-foreground hover:text-destructive -mt-1 -mr-1 shrink-0"
          >
            <XIcon aria-hidden="true" />
          </Button>
        </div>

        {/* Actions row */}
        <div className="mt-auto flex flex-wrap items-center justify-between gap-x-3 gap-y-2">
          {/* Fulfillment */}
          <ToggleGroup
            value={[item.mode]}
            onValueChange={(values) => {
              const next = values[0]
              if (next === "delivery" || next === "pickup") {
                onModeChange(item.id, next)
              }
            }}
            variant="outline"
            size="sm"
            aria-label={`Fulfillment for ${item.name}`}
            className="text-muted-foreground text-xs"
          >
            <ToggleGroupItem value="delivery" className="px-2.5">
              <FulfillmentChoice option={item.delivery} label="Delivery" />
            </ToggleGroupItem>
            <ToggleGroupItem value="pickup" className="px-2.5">
              <FulfillmentChoice option={item.pickup} label="Pickup" />
            </ToggleGroupItem>
          </ToggleGroup>

          {/* Quantity + Line total */}
          <div className="flex items-center gap-3">
            <ButtonGroup aria-label={`Quantity for ${item.name}`}>
              <Button
                variant="outline"
                size="icon-sm"
                type="button"
                aria-label={`Decrease quantity for ${item.name}`}
                disabled={item.quantity <= 1}
                onClick={() => onDecrease(item.id)}
              >
                <MinusIcon aria-hidden="true" />
              </Button>
              <ButtonGroupText className="min-w-8 justify-center text-sm tabular-nums">
                {item.quantity}
              </ButtonGroupText>
              <Button
                variant="outline"
                size="icon-sm"
                type="button"
                aria-label={`Increase quantity for ${item.name}`}
                onClick={() => onIncrease(item.id)}
              >
                <PlusIcon aria-hidden="true" />
              </Button>
            </ButtonGroup>
            <p className="text-foreground text-sm font-semibold tabular-nums sm:text-base">
              {formatCurrency.format(lineTotal)}
            </p>
          </div>
        </div>
      </div>
    </div>
  )
}