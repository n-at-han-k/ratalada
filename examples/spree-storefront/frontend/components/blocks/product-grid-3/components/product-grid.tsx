import { useState } from "react"

import { DEFAULT_LIKED_PRODUCT_IDS, PRODUCTS } from "./data"
import { ProductCard } from "./product-card"

// ─────────────────────────────────────────────────────────────────────────
// Product grid. Frameless 3x2 browse grid: six curated travel bags
// rendered through `ProductCard`, which drops the Card/Frame chrome and
// adds a full-width "Add to Cart" CTA per tile. Wishlist state is shared
// across the grid through a `Set<string>`; cart state is intentionally
// ephemeral here (the consumer wires their own cart store), but the
// callback is exposed via the `onAddToCart` prop so the integration
// point is clear.
// ─────────────────────────────────────────────────────────────────────────

export function ProductGrid() {
  const [likedProducts, setLikedProducts] = useState<Set<string>>(
    () => new Set(DEFAULT_LIKED_PRODUCT_IDS)
  )

  function handleLikedChange(productId: string) {
    setLikedProducts((prev) => {
      const next = new Set(prev)
      if (next.has(productId)) {
        next.delete(productId)
      } else {
        next.add(productId)
      }
      return next
    })
  }

  function handleAddToCart(productId: string) {
    // Demo callback. A real composer would dispatch to the cart store
    // here; the block deliberately doesn't try to fake that state.
    if (typeof window !== "undefined") {
      window.dispatchEvent(
        new CustomEvent("reui:add-to-cart", { detail: { productId } })
      )
    }
  }

  return (
    <section
      aria-label="Travel bags"
      className="mx-auto w-full max-w-6xl px-4 py-8 md:px-6 md:py-12"
    >
      <div className="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-3 lg:gap-8">
        {PRODUCTS.map((product) => (
          <ProductCard
            key={product.id}
            product={product}
            liked={likedProducts.has(product.id)}
            onLikedChange={handleLikedChange}
            onAddToCart={handleAddToCart}
          />
        ))}
      </div>
    </section>
  )
}