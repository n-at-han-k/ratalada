"use client"

import { useState } from "react"
import { Badge } from "@/components/reui/badge"
import { cn } from "cn"

import { Button } from "@/components/ui/button"
import { Item } from "@/components/ui/item"
import { ArrowRightIcon, ArrowUpRightIcon, CheckIcon, PlusIcon } from "lucide-react"

// ─────────────────────────────────────────────────────────────────────────
// Drop Bento shop hero. A bento-style grid where one large featured tile
// carries the campaign image plus editorial overlay (eyebrow, headline,
// dual CTA), three product tiles surface immediate Add-to-Cart entry
// points, and a vibrant inverted promo tile drives the sale narrative.
// Composition is the block itself. No site header, no footer nav.
// ─────────────────────────────────────────────────────────────────────────

function DotSeparator() {
  return (
    <span
      aria-hidden="true"
      className="bg-muted-foreground/40 size-1 shrink-0 rounded-full"
    />
  )
}

type ProductBadge = {
  label: string
  variant: "default" | "destructive" | "primary-light"
}

type ShopProduct = {
  id: string
  name: string
  category: string
  href: string
  price: string
  compareAtPrice?: string
  image: string
  imageAlt: string
  badge?: ProductBadge
}

const FEATURE_TILE = {
  eyebrow: "Fall 2026 · Chapter 03",
  collection: "The Outpost Collection",
  headline: "Built For The Long Way Home.",
  lede: "An outdoor edit built in two small workshops we visit by name. Patched canvas, oiled leather, and seam-sealed shells.",
  primaryCta: { label: "Shop The Outpost", href: "#shop-outpost" },
  secondaryCta: { label: "View Lookbook", href: "#lookbook" },
  image:
    "https://images.unsplash.com/photo-1581605405669-fcdf81165afa?auto=format&fit=crop&w=1200&h=1200&q=80",
  imageAlt:
    "Outpost 45L Pack in Slate, the hero piece of the Outpost Collection",
}

const PRODUCT_TILES: ShopProduct[] = [
  {
    id: "sundown-weekender",
    name: "Sundown Weekender",
    category: "48-hour duffel",
    href: "#shop-sundown-weekender",
    price: "$224",
    image:
      "https://images.unsplash.com/photo-1547949003-9792a18a2601?auto=format&fit=crop&w=480&h=480&q=80",
    imageAlt: "Sundown Weekender duffel on a marble surface",
    badge: { label: "New", variant: "default" },
  },
  {
    id: "wayfarer-daypack",
    name: "Wayfarer Daypack",
    category: "Everyday 18L",
    href: "#shop-wayfarer-daypack",
    price: "$148",
    compareAtPrice: "$185",
    image:
      "https://images.unsplash.com/photo-1553062407-98eeb64c6a62?auto=format&fit=crop&w=480&h=480&q=80",
    imageAlt: "Wayfarer Daypack in Charcoal, three-quarter studio shot",
    badge: { label: "20% Off", variant: "destructive" },
  },
  {
    id: "field-shell-jacket",
    name: "Field Shell Jacket",
    category: "Weatherproof shell",
    href: "#shop-field-shell-jacket",
    price: "$185",
    image:
      "https://images.unsplash.com/photo-1551028719-00167b16eac5?auto=format&fit=crop&w=480&h=480&q=80",
    imageAlt: "Field Shell Jacket in Olive on a studio backdrop",
  },
]

const PROMO_TILE = {
  eyebrow: "Limited Time",
  headline: "Up To 40% Off",
  detail: "Fall Sale ends Sunday",
  ctaLabel: "Shop The Sale",
  ctaHref: "#shop-sale",
}

export function Hero() {
  const [recentlyAdded, setRecentlyAdded] = useState<string | null>(null)

  function addToCart(id: string) {
    setRecentlyAdded(id)
    window.setTimeout(() => {
      setRecentlyAdded((prev) => (prev === id ? null : prev))
    }, 1600)
  }

  return (
    <section
      aria-labelledby="shop-hero-2-title"
      className="mx-auto w-full max-w-6xl px-4 py-8 sm:px-6 md:py-10 lg:py-12"
    >
      <div
        className={cn(
          "grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-4 lg:gap-4",
          "lg:auto-rows-fr lg:grid-rows-2"
        )}
      >
        <FeatureTile
          tile={FEATURE_TILE}
          headingId="shop-hero-2-title"
          className="sm:col-span-2 lg:row-span-2"
        />
        {PRODUCT_TILES.map((product) => (
          <ProductTile
            key={product.id}
            product={product}
            wasJustAdded={recentlyAdded === product.id}
            onAdd={() => addToCart(product.id)}
          />
        ))}
        <PromoTile tile={PROMO_TILE} />
      </div>
    </section>
  )
}

// ─── Featured tile. Image fill with editorial overlay + dual CTA. ───────

function FeatureTile({
  tile,
  headingId,
  className,
}: {
  tile: typeof FEATURE_TILE
  headingId: string
  className?: string
}) {
  return (
    <Item
      variant="muted"
      className={cn(
        "group/feature relative block w-full overflow-hidden p-0",
        "aspect-[4/5] sm:aspect-[5/3] lg:aspect-auto lg:h-full",
        className
      )}
    >
      <img
        src={tile.image}
        alt={tile.imageAlt}
        className="absolute inset-0 size-full object-cover transition-transform duration-700 ease-out group-hover/feature:scale-[1.02]"
        loading="eager"
      />

      {/* Gradient overlays for legibility */}
      <div
        aria-hidden="true"
        className="absolute inset-x-0 top-0 h-1/3 bg-gradient-to-b from-black/55 to-transparent"
      />
      <div
        aria-hidden="true"
        className="absolute inset-x-0 bottom-0 h-3/4 bg-gradient-to-t from-black/90 via-black/45 to-transparent"
      />

      {/* Dark-scoped overlay so child primitives flip tokens */}
      <div className="dark relative flex h-full flex-col justify-between p-5 md:p-7 lg:p-8">
        {/* Top eyebrow */}
        <div className="flex items-center gap-2 text-white/85">
          <span className="text-[0.625rem] font-semibold tracking-[0.22em] uppercase">
            {tile.eyebrow}
          </span>
          <DotSeparator />
          <span className="text-xs">{tile.collection}</span>
        </div>

        {/* Bottom editorial */}
        <div className="flex max-w-md flex-col gap-5">
          <div className="flex flex-col gap-3">
            <h2
              id={headingId}
              className="text-3xl leading-[1.04] font-semibold tracking-tight text-balance text-white md:text-4xl lg:text-[44px]"
            >
              {tile.headline}
            </h2>
            <p className="text-sm leading-relaxed text-white/80 md:text-base">
              {tile.lede}
            </p>
          </div>
          <div className="flex flex-wrap items-center gap-x-5 gap-y-3">
            <Button
              nativeButton={false}
              size="default"
              render={
                <a
                  href={tile.primaryCta.href}
                  aria-label={tile.primaryCta.label}
                />
              }
            >
              {tile.primaryCta.label}
              <ArrowRightIcon data-icon="inline-end" aria-hidden="true" />
            </Button>
            <a
              href={tile.secondaryCta.href}
              aria-label={tile.secondaryCta.label}
              className="inline-flex items-center gap-1.5 text-sm font-medium text-white underline-offset-4 transition-colors hover:underline"
            >
              {tile.secondaryCta.label}
              <ArrowUpRightIcon className="size-3.5" aria-hidden="true" />
            </a>
          </div>
        </div>
      </div>
    </Item>
  )
}

// ─── Product tile. Image fill, badge, bottom-anchored overlay + Add. ────

function ProductTile({
  product,
  wasJustAdded,
  onAdd,
}: {
  product: ShopProduct
  wasJustAdded: boolean
  onAdd: () => void
}) {
  return (
    <Item
      variant="muted"
      className="group/product relative block aspect-square w-full overflow-hidden p-0"
    >
      <a
        href={product.href}
        aria-label={`Shop ${product.name}`}
        className="focus-visible:ring-ring absolute inset-0 z-0 focus-visible:ring-2 focus-visible:outline-none focus-visible:ring-inset"
      >
        <img
          src={product.image}
          alt={product.imageAlt}
          className="size-full object-cover transition-transform duration-700 ease-out group-hover/product:scale-[1.04]"
          loading="lazy"
        />
      </a>

      {product.badge && (
        <div className="pointer-events-none absolute top-3 left-3 z-10">
          <Badge variant={product.badge.variant}>{product.badge.label}</Badge>
        </div>
      )}

      {/* Bottom overlay */}
      <div
        aria-hidden="true"
        className="pointer-events-none absolute inset-x-0 bottom-0 z-10 h-1/2 bg-gradient-to-t from-black/85 via-black/30 to-transparent"
      />
      <div className="dark pointer-events-none absolute inset-x-0 bottom-0 z-20 flex items-end justify-between gap-3 p-3 md:p-4">
        <div className="flex min-w-0 flex-col text-white">
          <span className="truncate text-sm font-medium">{product.name}</span>
          <span className="flex items-baseline gap-1.5 text-xs text-white/80">
            <span className="tabular-nums">{product.price}</span>
            {product.compareAtPrice && (
              <span className="tabular-nums line-through">
                {product.compareAtPrice}
              </span>
            )}
          </span>
        </div>
        <Button
          type="button"
          variant={wasJustAdded ? "default" : "secondary"}
          size="icon-sm"
          className="pointer-events-auto"
          onClick={(e) => {
            e.preventDefault()
            e.stopPropagation()
            onAdd()
          }}
          aria-label={
            wasJustAdded
              ? `${product.name} added to cart`
              : `Add ${product.name} to cart`
          }
        >
          {wasJustAdded ? (
            <CheckIcon aria-hidden="true" />
          ) : (
            <PlusIcon aria-hidden="true" />
          )}
        </Button>
      </div>
    </Item>
  )
}

// ─── Promo tile. Inverted color block, no image, sale narrative. ────────

function PromoTile({ tile }: { tile: typeof PROMO_TILE }) {
  return (
    <Item
      variant="default"
      className="bg-foreground text-background relative block aspect-square w-full overflow-hidden p-5 md:p-6"
    >
      <div className="flex h-full flex-col justify-between gap-4">
        <div className="flex flex-col gap-2">
          <span className="text-background/65 text-[0.625rem] font-semibold tracking-[0.22em] uppercase">
            {tile.eyebrow}
          </span>
          <span className="text-3xl leading-[1.04] font-semibold tracking-tight text-balance md:text-4xl">
            {tile.headline}
          </span>
        </div>
        <div className="flex items-end justify-between gap-3">
          <p className="text-background/70 text-xs">{tile.detail}</p>
          <a
            href={tile.ctaHref}
            aria-label={tile.ctaLabel}
            className="inline-flex items-center gap-1 text-xs font-semibold underline-offset-4 transition-opacity hover:underline hover:opacity-90"
          >
            {tile.ctaLabel}
            <ArrowRightIcon className="size-3" aria-hidden="true" />
          </a>
        </div>
      </div>
    </Item>
  )
}