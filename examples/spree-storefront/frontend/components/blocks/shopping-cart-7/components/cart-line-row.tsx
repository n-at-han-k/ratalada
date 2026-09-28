import { Button } from "@/components/ui/button"
import {
  ButtonGroup,
  ButtonGroupText,
} from "@/components/ui/button-group"
import { Item } from "@/components/ui/item"
import { ECOMMERCE_LINK_CLASS_NAME, type CartLine } from "./data"
import { MinusIcon, PlusIcon } from "lucide-react"

const formatCurrency = new Intl.NumberFormat("en-US", {
  style: "currency",
  currency: "USD",
})

export function CartLineRow({
  line,
  priority,
  onDecrease,
  onIncrease,
}: {
  line: CartLine
  priority?: boolean
  onDecrease: (lineId: string) => void
  onIncrease: (lineId: string) => void
}) {
  const lineTotal = line.unitPrice * line.quantity
  const isLastUnit = line.quantity <= 1

  return (
    <div className="grid grid-cols-[56px_minmax(0,1fr)_auto] items-start gap-3">
      <a
        href={`#product-${line.id}`}
        aria-label={`View ${line.name}`}
        className="shrink-0"
      >
        <Item variant="muted" className="relative size-14 overflow-hidden p-0">
          <img
            src={line.image.src}
            alt={line.image.alt}
            className="absolute inset-0 h-full w-full object-cover"
            loading={priority ? "eager" : "lazy"}
            fetchPriority={priority ? "high" : "auto"}
          />
        </Item>
      </a>

      <div className="flex min-w-0 flex-col gap-2">
        <div className="flex min-w-0 flex-col gap-0.5">
          <p className="text-muted-foreground text-[10px] font-semibold tracking-widest uppercase">
            {line.category}
          </p>
          <h3 className="text-foreground min-w-0 text-sm leading-tight font-medium">
            <a
              href={`#product-${line.id}`}
              className={`block truncate ${ECOMMERCE_LINK_CLASS_NAME}`}
            >
              {line.name}
            </a>
          </h3>
          <p className="text-muted-foreground truncate text-xs">
            {line.variant}
          </p>
        </div>

        <ButtonGroup
          aria-label={`Quantity for ${line.name}`}
          className="shrink-0"
        >
          <Button
            variant="outline"
            size="icon-xs"
            type="button"
            aria-label={
              isLastUnit
                ? `Remove ${line.name} from cart`
                : `Decrease quantity for ${line.name}`
            }
            onClick={() => onDecrease(line.id)}
          >
            <MinusIcon aria-hidden="true" className="size-3" />
          </Button>
          <ButtonGroupText className="min-w-8 justify-center text-xs tabular-nums">
            {line.quantity}
          </ButtonGroupText>
          <Button
            variant="outline"
            size="icon-xs"
            type="button"
            aria-label={`Increase quantity for ${line.name}`}
            onClick={() => onIncrease(line.id)}
          >
            <PlusIcon aria-hidden="true" className="size-3" />
          </Button>
        </ButtonGroup>
      </div>

      <p className="text-foreground text-sm font-semibold tabular-nums">
        {formatCurrency.format(lineTotal)}
      </p>
    </div>
  )
}