"use client"

import { useState } from "react"
import { Badge } from "@/components/reui/badge"
import { Rating } from "@/components/reui/rating"
import { cn } from "cn"

import { Button } from "@/components/ui/button"
import {
  ButtonGroup,
  ButtonGroupText,
} from "@/components/ui/button-group"
import { Item } from "@/components/ui/item"
import {
  COLORS,
  ECOMMERCE_LINK_CLASS_NAME,
  HIGHLIGHTS,
  PRODUCT,
  SIZES,
  type ColorOption,
  type SizeOption,
} from "./data"
import { CheckIcon, MinusIcon, PlusIcon, ShoppingBagIcon, HeartIcon } from "lucide-react"

function formatCurrency(value: number) {
  return new Intl.NumberFormat("en-US", {
    style: "currency",
    currency: "USD",
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  }).format(value)
}

export function BuyBox() {
  const [colorId, setColorId] = useState<string>(COLORS[0]?.id ?? "")
  const [sizeId, setSizeId] = useState<string>(SIZES[2]?.id ?? "")
  const [quantity, setQuantity] = useState<number>(1)
  const [wishlisted, setWishlisted] = useState<boolean>(false)
  const [wishlistTouched, setWishlistTouched] = useState<boolean>(false)

  const selectedColor =
    COLORS.find((c) => c.id === colorId) ?? (COLORS[0] as ColorOption)
  const selectedSize =
    SIZES.find((s) => s.id === sizeId) ?? (SIZES[0] as SizeOption)
  const wishlistLabel = wishlisted
    ? `Remove ${PRODUCT.name} from wishlist`
    : `Add ${PRODUCT.name} to wishlist`

  function toggleWishlist() {
    setWishlisted((v) => !v)
    setWishlistTouched(true)
  }

  return (
    <div className="flex min-w-0 flex-col gap-6">
      {/* Title block: brand · category eyebrow, linked name, rating */}
      <header className="flex min-w-0 flex-col gap-2">
        <p className="flex min-w-0 flex-wrap items-center gap-x-2 gap-y-1 text-xs font-medium tracking-wide uppercase">
          <a
            href={PRODUCT.brand.href}
            className={cn(
              "text-muted-foreground min-w-0 truncate",
              ECOMMERCE_LINK_CLASS_NAME
            )}
          >
            {PRODUCT.brand.label}
          </a>
          <span
            aria-hidden="true"
            className="bg-muted-foreground/40 size-1 shrink-0 rounded-full"
          />
          <a
            href={PRODUCT.category.href}
            aria-label={`View ${PRODUCT.category.label} products`}
            className={cn(
              "text-muted-foreground min-w-0 truncate",
              ECOMMERCE_LINK_CLASS_NAME
            )}
          >
            {PRODUCT.category.label}
          </a>
        </p>
        <h1 className="text-foreground text-xl leading-tight font-semibold tracking-tight md:text-2xl">
          <a
            href={PRODUCT.href}
            className={cn("text-foreground block", ECOMMERCE_LINK_CLASS_NAME)}
          >
            {PRODUCT.name}
          </a>
        </h1>
        <div className="flex flex-wrap items-center gap-x-3 gap-y-1 text-sm">
          <Rating rating={PRODUCT.rating} size="sm" showValue />
          <a
            href="#reviews"
            aria-label={`Read ${PRODUCT.reviewCount} reviews for ${PRODUCT.name}`}
            className={cn("text-muted-foreground", ECOMMERCE_LINK_CLASS_NAME)}
          >
            ({PRODUCT.reviewCount.toLocaleString()} reviews)
          </a>
        </div>
      </header>

      {/* Price - canonical pattern: same-size baseline-aligned prices, center-aligned badge */}
      <div className="flex flex-wrap items-center gap-3">
        <div className="flex items-baseline gap-2 text-xl font-semibold tabular-nums md:text-2xl">
          <span className="text-foreground whitespace-nowrap">
            {formatCurrency(PRODUCT.price)}
          </span>
          {PRODUCT.compareAtPrice ? (
            <span className="text-muted-foreground font-normal whitespace-nowrap line-through">
              {formatCurrency(PRODUCT.compareAtPrice)}
            </span>
          ) : null}
        </div>
        <Badge variant="destructive" radius="full">
          {PRODUCT.discountLabel}
        </Badge>
      </div>

      {/* Highlights - small primary checks read as benefits, not meta */}
      <ul
        className="flex flex-col gap-2"
        role="list"
        aria-label="Key highlights"
      >
        {HIGHLIGHTS.map((label) => (
          <li key={label} className="flex min-w-0 items-start gap-2.5 text-sm">
            <CheckIcon className="text-primary mt-0.5 size-4 shrink-0" aria-hidden="true" />
            <span className="text-foreground min-w-0 leading-snug">
              {label}
            </span>
          </li>
        ))}
      </ul>

      {/* Color picker */}
      <ColorPicker
        colors={COLORS}
        selectedId={colorId}
        onSelect={setColorId}
        selectedName={selectedColor?.name}
      />

      {/* Size picker */}
      <SizePicker
        sizes={SIZES}
        selectedId={sizeId}
        onSelect={setSizeId}
        selectedLabel={selectedSize?.label}
      />

      {/* Stock + shipping line - placed above CTAs so the urgency reads first */}
      <p
        aria-label="Stock and shipping"
        className="text-muted-foreground flex flex-wrap items-center gap-x-3 gap-y-1 text-sm"
      >
        <span className="text-foreground inline-flex items-center gap-1.5 font-medium">
          <span
            aria-hidden="true"
            className="size-1.5 shrink-0 rounded-full bg-emerald-500"
          />
          Only {PRODUCT.stockLeft} left in {selectedColor?.name}
        </span>
        <span
          aria-hidden="true"
          className="bg-muted-foreground/40 size-1 shrink-0 rounded-full"
        />
        <span>
          Free shipping over {formatCurrency(PRODUCT.shippingFreeOver)}
        </span>
      </p>

      {/* Quantity + CTAs */}
      <div className="flex flex-col gap-2.5">
        <div className="flex items-stretch gap-2">
          <ButtonGroup aria-label="Quantity">
            <Button
              variant="outline"
              type="button"
              aria-label="Decrease quantity"
              disabled={quantity <= 1}
              onClick={() => setQuantity(Math.max(1, quantity - 1))}
            >
              <MinusIcon aria-hidden="true" />
            </Button>
            <ButtonGroupText className="min-w-10 justify-center text-sm tabular-nums">
              {quantity}
            </ButtonGroupText>
            <Button
              variant="outline"
              type="button"
              aria-label="Increase quantity"
              disabled={quantity >= PRODUCT.stockLeft}
              onClick={() =>
                setQuantity(Math.min(PRODUCT.stockLeft, quantity + 1))
              }
            >
              <PlusIcon aria-hidden="true" />
            </Button>
          </ButtonGroup>
          <Button type="button" className="flex-1">
            <ShoppingBagIcon className="size-4" aria-hidden="true" />
            Add To Cart
          </Button>
        </div>
        <div className="flex items-stretch gap-2">
          <Button type="button" variant="outline" className="flex-1">
            Buy Now
          </Button>
          <Button
            type="button"
            variant="outline"
            size="icon"
            aria-pressed={wishlisted}
            aria-label={wishlistLabel}
            onClick={toggleWishlist}
          >
            <HeartIcon className={cn(
                                      "size-4 transition-transform duration-200",
                                      wishlisted && "fill-destructive text-destructive scale-110"
                                    )} aria-hidden="true" />
          </Button>
        </div>
      </div>
      <span aria-live="polite" className="sr-only">
        {wishlistTouched
          ? wishlisted
            ? `${PRODUCT.name} added to wishlist`
            : `${PRODUCT.name} removed from wishlist`
          : ""}
      </span>
    </div>
  )
}

// ─────────────────────────────────────────────────────────────────────────
// Color picker - swatch radiogroup matched to product-detail-1
// ─────────────────────────────────────────────────────────────────────────

function ColorPicker({
  colors,
  selectedId,
  onSelect,
  selectedName,
}: {
  colors: ColorOption[]
  selectedId: string
  onSelect: (id: string) => void
  selectedName?: string
}) {
  return (
    <section aria-label="Color" className="flex flex-col gap-2.5">
      <p className="text-foreground text-sm font-medium">
        Color:{" "}
        <span className="text-muted-foreground font-normal">
          {selectedName}
        </span>
      </p>
      <div
        role="radiogroup"
        aria-label="Color"
        className="flex flex-wrap items-center gap-2"
      >
        {colors.map((c) => {
          const isActive = c.id === selectedId
          return (
            <button
              key={c.id}
              type="button"
              role="radio"
              aria-checked={isActive}
              aria-label={c.name}
              onClick={() => onSelect(c.id)}
              className={cn(
                "relative inline-flex size-7 items-center justify-center rounded-full transition outline-none",
                "focus-visible:ring-ring focus-visible:ring-2 focus-visible:ring-offset-2",
                isActive
                  ? "ring-foreground ring-offset-background ring-2 ring-offset-2"
                  : "ring-border hover:ring-foreground/40 ring-1"
              )}
            >
              <span
                className={cn(
                  "absolute inset-0 rounded-full",
                  c.swatchClassName
                )}
                aria-hidden="true"
              />
            </button>
          )
        })}
      </div>
    </section>
  )
}

// ─────────────────────────────────────────────────────────────────────────
// Size picker - Item-rendered radiogroup of pill tiles
// ─────────────────────────────────────────────────────────────────────────

function SizePicker({
  sizes,
  selectedId,
  onSelect,
  selectedLabel,
}: {
  sizes: SizeOption[]
  selectedId: string
  onSelect: (id: string) => void
  selectedLabel?: string
}) {
  return (
    <section aria-label="Size" className="flex flex-col gap-2.5">
      <div className="flex flex-wrap items-baseline justify-between gap-x-3 gap-y-1">
        <p className="text-foreground text-sm font-medium">
          Size:{" "}
          <span className="text-muted-foreground font-normal">
            {selectedLabel}
          </span>
        </p>
        <a
          href="#size-guide"
          className={cn(
            "text-muted-foreground text-xs",
            ECOMMERCE_LINK_CLASS_NAME
          )}
        >
          Size guide
        </a>
      </div>
      <div
        role="radiogroup"
        aria-label="Size"
        className="grid grid-cols-3 gap-2"
      >
        {sizes.map((s) => {
          const isActive = s.id === selectedId
          return (
            <Item
              key={s.id}
              variant="outline"
              size="sm"
              render={
                <button
                  type="button"
                  role="radio"
                  aria-checked={isActive}
                  aria-label={`Size ${s.label} (${s.caption})`}
                  onClick={() => onSelect(s.id)}
                />
              }
              className={cn(
                "min-w-0 flex-col items-center justify-center gap-0.5 px-2 py-2 text-center transition-colors",
                isActive
                  ? "border-foreground bg-foreground/[0.04]"
                  : "hover:bg-muted/50"
              )}
            >
              <span className="text-foreground text-sm font-medium">
                {s.label}
              </span>
              <span className="text-muted-foreground text-[0.625rem] leading-tight tabular-nums">
                {s.caption}
              </span>
            </Item>
          )
        })}
      </div>
    </section>
  )
}