import { cn } from "cn"

import { Item } from "@/components/ui/item"

import { ECOMMERCE_LINK_CLASS_NAME, PRODUCT, RELATED_PRODUCTS } from "./data"

function formatCurrency(value: number) {
  return new Intl.NumberFormat("en-US", {
    style: "currency",
    currency: "USD",
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  }).format(value)
}

export function RelatedProducts() {
  return (
    <section
      id="related"
      aria-labelledby="related-heading"
      className="flex flex-col gap-5"
    >
      <header className="flex items-baseline justify-between gap-3">
        <h2
          id="related-heading"
          className="text-foreground text-lg leading-tight font-semibold tracking-tight md:text-xl"
        >
          You May Also Like
        </h2>
        <a
          href={PRODUCT.category.href}
          aria-label={`View all ${PRODUCT.category.label}`}
          className={cn(
            "text-muted-foreground text-sm",
            ECOMMERCE_LINK_CLASS_NAME
          )}
        >
          View All
        </a>
      </header>

      <ul
        role="list"
        className="grid grid-cols-2 gap-x-4 gap-y-6 sm:grid-cols-4"
      >
        {RELATED_PRODUCTS.map((product) => (
          <li key={product.id} className="group flex flex-col gap-3">
            <Item
              variant="muted"
              render={
                <a href={product.href} aria-label={`View ${product.name}`} />
              }
              className="block aspect-square w-full overflow-hidden p-0 transition"
            >
              <img
                src={product.image}
                alt={product.imageAlt}
                className="size-full object-cover transition-transform duration-300 group-hover:scale-[1.03]"
                loading="lazy"
              />
            </Item>
            <div className="flex min-w-0 flex-col gap-1">
              <a
                href={`/shop/${product.category.toLowerCase()}`}
                aria-label={`View ${product.category} products`}
                className={cn(
                  "text-muted-foreground text-xs",
                  ECOMMERCE_LINK_CLASS_NAME
                )}
              >
                {product.category}
              </a>
              <a
                href={product.href}
                className={cn(
                  "text-foreground text-sm font-medium",
                  ECOMMERCE_LINK_CLASS_NAME
                )}
              >
                {product.name}
              </a>
              <span className="text-foreground text-sm font-semibold tabular-nums">
                {formatCurrency(product.price)}
              </span>
            </div>
          </li>
        ))}
      </ul>
    </section>
  )
}