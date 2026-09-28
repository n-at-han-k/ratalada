import { Fragment } from "react"
import { Badge } from "@/components/reui/badge"
import { Rating } from "@/components/reui/rating"
import { cn } from "cn"

import { Button } from "@/components/ui/button"
import { Item } from "@/components/ui/item"
import { ECOMMERCE_LINK_CLASS_NAME, type Product } from "./data"
import { HeartIcon, ShoppingBagIcon } from "lucide-react"

// ─────────────────────────────────────────────────────────────────────────
// Product card. Frameless tile, image-led: no outer Card or Frame chrome.
// Radius lives only on the media `Item`. Below the media a tight content
// stack reads as `categories · title · rating · price · CTA`.
// The full-width "Add to Cart" button uses the default size for an
// assertive commerce action; the wishlist toggle on the media corner
// stays hidden until the user hovers or focuses the card (or the product
// is already liked).
// ─────────────────────────────────────────────────────────────────────────

export function ProductCard({
  product,
  liked,
  onLikedChange,
  onAddToCart,
}: {
  product: Product
  liked: boolean
  onLikedChange: (productId: string) => void
  onAddToCart: (productId: string) => void
}) {
  const wishlistLabel = liked
    ? `Remove ${product.name} from wishlist`
    : `Add ${product.name} to wishlist`

  return (
    <article className="group/card flex min-w-0 flex-col gap-3">
      {/* Media. Item muted with border/shadow stripped owns the radius. */}
      <Item
        variant="muted"
        className="group/media relative aspect-square w-full overflow-hidden border-0 p-0 shadow-none"
      >
        <a
          href={product.href}
          aria-label={`View ${product.name}`}
          className="focus-visible:ring-ring absolute inset-0 block outline-none focus-visible:ring-2 focus-visible:ring-inset"
        >
          <img
            src={product.image.src}
            alt={product.image.alt}
            className="absolute inset-0 size-full object-cover transition-transform duration-500 ease-out motion-safe:group-hover/media:scale-105 motion-reduce:transition-none"
            loading="lazy"
          />
        </a>

        {/* Optional badge top-left. Variant maps to the product signal:
            destructive (sale), default (new), success (bestseller),
            warning (hot). */}
        {product.badge ? (
          <div className="absolute top-3 left-3">
            <Badge variant={product.badge.variant} radius="full">
              {product.badge.label}
            </Badge>
          </div>
        ) : null}

        {/* Wishlist toggle. Hidden on sm+ until the card is hovered or
            focused; always visible when already liked. */}
        <Button
          variant="secondary"
          size="icon-sm"
          type="button"
          aria-label={wishlistLabel}
          aria-pressed={liked}
          onClick={() => onLikedChange(product.id)}
          className={cn(
            "absolute top-3 right-3 transition-opacity",
            !liked &&
              "sm:opacity-0 sm:group-focus-within/card:opacity-100 sm:group-hover/card:opacity-100 sm:focus-visible:opacity-100"
          )}
        >
          <HeartIcon className={cn(
                                "size-4",
                                liked && "fill-destructive text-destructive"
                              )} aria-hidden="true" />
        </Button>
      </Item>

      {/* Content stack */}
      <div className="flex min-w-0 flex-col gap-2">
        {/* Categories eyebrow. One or two categories; the ReUI dot span
            sits between two so the eyebrow row reads as a single line of
            metadata, not two stacked labels. */}
        <nav
          aria-label="Categories"
          className="flex flex-wrap items-center gap-x-2 gap-y-1"
        >
          {product.categories.map((category, index) => (
            <Fragment key={category.label}>
              {index > 0 ? (
                <span
                  aria-hidden="true"
                  className="bg-muted-foreground/40 size-1 shrink-0 rounded-full"
                />
              ) : null}
              <a
                href={category.href}
                aria-label={`View all ${category.label}`}
                className={cn(
                  ECOMMERCE_LINK_CLASS_NAME,
                  "text-muted-foreground text-xs font-medium tracking-wide uppercase"
                )}
              >
                {category.label}
              </a>
            </Fragment>
          ))}
        </nav>

        {/* Title */}
        <h3 className="text-foreground min-w-0 text-base leading-snug font-medium tracking-tight">
          <a
            href={product.href}
            className={cn(ECOMMERCE_LINK_CLASS_NAME, "block truncate")}
          >
            {product.name}
          </a>
        </h3>

        {/* Rating row. Stars + linked review count. */}
        <div className="flex flex-wrap items-center gap-1.5">
          <Rating rating={product.rating} size="sm" showValue />
          <a
            href={`${product.href}#reviews`}
            aria-label={`Read ${product.reviewCount.toLocaleString()} reviews for ${product.name}`}
            className={cn(
              ECOMMERCE_LINK_CLASS_NAME,
              "text-muted-foreground text-xs tabular-nums"
            )}
          >
            ({product.reviewCount.toLocaleString()})
          </a>
        </div>

        {/* Price row. Same-size baseline-aligned. */}
        <div className="flex min-w-0 items-baseline gap-2 text-base font-semibold tabular-nums">
          <span className="text-foreground">{product.price}</span>
          {product.compareAtPrice ? (
            <span className="text-muted-foreground font-normal line-through">
              {product.compareAtPrice}
            </span>
          ) : null}
        </div>

        {/* Add to Cart. Default Button size, full-width primary action. */}
        <Button
          type="button"
          onClick={() => onAddToCart(product.id)}
          aria-label={`Add ${product.name} to cart`}
          className="mt-1 w-full"
        >
          <ShoppingBagIcon className="size-4" aria-hidden="true" />
          Add to Cart
        </Button>
      </div>
    </article>
  )
}