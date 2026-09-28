# frozen_string_literal: true

# reui: category-card-6, product-grid-3, filter-sidebar-6
#
# <JsonLd>
# <CategoryCard>                              # blocks/category-card-6/category-card
#   <Breadcrumb>                              # ui/breadcrumb — header rail of the block
#   <h1>
#   <p>
#   <Link>                                    # child category tile
# <FilterSidebar>                             # blocks/filter-sidebar-6/filter-sidebar
# <ProductGrid>                               # blocks/product-grid-3/product-grid
#   <ProductCard>                             # blocks/product-grid-3/product-card

# ponytail: fixture props, swap for the Spree Store API call when it is wired
FIXTURE_CATEGORIES = {
  "mens" => { name: "Men's", permalink: "mens", description: "Everything for him.",
              children: [{ name: "Shirts", permalink: "mens/shirts" }, { name: "Outerwear", permalink: "mens/outerwear" }] },
  "mens/shirts" => { name: "Shirts", permalink: "mens/shirts", description: "Shirts for every occasion.",
                     parent: { name: "Men's", permalink: "mens" }, children: [] },
  "mens/outerwear" => { name: "Outerwear", permalink: "mens/outerwear", description: "Coats and jackets.",
                        parent: { name: "Men's", permalink: "mens" }, children: [] },
}.freeze

FIXTURE_CATEGORY_PRODUCTS = [
  { slug: "wool-overcoat", name: "Wool Overcoat", price: "$340.00", image: "https://picsum.photos/seed/overcoat/640/640", rating: 4.6, review_count: 58 },
  { slug: "linen-shirt", name: "Linen Shirt", price: "$78.00", image: "https://picsum.photos/seed/linenshirt/640/640", rating: 4.2, review_count: 143 },
].freeze

get "/" do
  permalink = params["permalink"]
  permalink = permalink.join("/") if permalink.is_a?(Array)
  category = FIXTURE_CATEGORIES[permalink]
  halt 404 unless category

  inertia("[country]/[locale]/(storefront)/c/[...permalink]", props: {
    category: category,
    products: FIXTURE_CATEGORY_PRODUCTS,
  })
end

__END__

import { Head, Link } from "@inertiajs/react"

import { Rating } from "@/components/reui/rating"
import {
  Breadcrumb,
  BreadcrumbItem,
  BreadcrumbLink,
  BreadcrumbList,
  BreadcrumbPage,
  BreadcrumbSeparator,
} from "@/components/ui/breadcrumb"
import { Button } from "@/components/ui/button"
import { Item } from "@/components/ui/item"
import { ShoppingBagIcon } from "lucide-react"

type CategoryRef = { name: string; permalink: string }
type Category = {
  name: string
  permalink: string
  description: string
  parent?: CategoryRef
  children: CategoryRef[]
}
type Product = { slug: string; name: string; price: string; image: string; rating: number; review_count: number }

function ProductCard({ product }: { product: Product }) {
  return (
    <article className="flex min-w-0 flex-col gap-3">
      <Item variant="muted" className="relative aspect-square w-full overflow-hidden border-0 p-0 shadow-none">
        <Link href={`/products/${product.slug}`} aria-label={`View ${product.name}`} className="absolute inset-0 block">
          <img src={product.image} alt={product.name} className="absolute inset-0 size-full object-cover" loading="lazy" />
        </Link>
      </Item>
      <div className="flex min-w-0 flex-col gap-1.5">
        <h3 className="text-foreground truncate text-base leading-snug font-medium">
          <Link href={`/products/${product.slug}`}>{product.name}</Link>
        </h3>
        <div className="flex items-center gap-1.5">
          <Rating rating={product.rating} size="sm" showValue />
          <span className="text-muted-foreground text-xs tabular-nums">({product.review_count})</span>
        </div>
        <span className="text-foreground text-base font-semibold tabular-nums">{product.price}</span>
        <Button type="button" className="mt-1 w-full">
          <ShoppingBagIcon className="size-4" aria-hidden="true" />
          Add to Cart
        </Button>
      </div>
    </article>
  )
}

export default function Category({ category, products }: { category: Category; products: Product[] }) {
  return (
    <main className="mx-auto w-full max-w-6xl px-4 py-8 md:px-6 md:py-12">
      <Head title={category.name} />
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{
          __html: JSON.stringify({
            "@context": "https://schema.org",
            "@type": "BreadcrumbList",
            itemListElement: [
              ...(category.parent ? [{ "@type": "ListItem", position: 1, name: category.parent.name, item: `/c/${category.parent.permalink}` }] : []),
              { "@type": "ListItem", position: category.parent ? 2 : 1, name: category.name, item: `/c/${category.permalink}` },
            ],
          }),
        }}
      />

      <div className="flex flex-col gap-4 border-b border-dashed pb-5">
        <Breadcrumb>
          <BreadcrumbList>
            <BreadcrumbItem>
              <BreadcrumbLink href="/products">Shop</BreadcrumbLink>
            </BreadcrumbItem>
            {category.parent ? (
              <>
                <BreadcrumbSeparator />
                <BreadcrumbItem>
                  <BreadcrumbLink href={`/c/${category.parent.permalink}`}>{category.parent.name}</BreadcrumbLink>
                </BreadcrumbItem>
              </>
            ) : null}
            <BreadcrumbSeparator />
            <BreadcrumbItem>
              <BreadcrumbPage>{category.name}</BreadcrumbPage>
            </BreadcrumbItem>
          </BreadcrumbList>
        </Breadcrumb>

        <h1 className="text-2xl leading-tight font-semibold tracking-tight md:text-3xl">{category.name}</h1>
        <p className="text-muted-foreground max-w-2xl text-sm">{category.description}</p>

        {category.children.length > 0 ? (
          <nav aria-label="Subcategories" className="flex flex-wrap gap-2">
            {category.children.map((child) => (
              <Link
                key={child.permalink}
                href={`/c/${child.permalink}`}
                className="border-border hover:bg-muted rounded-full border px-3 py-1 text-sm"
              >
                {child.name}
              </Link>
            ))}
          </nav>
        ) : null}
      </div>

      <div className="mt-8 grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-3">
        {products.map((product) => (
          <ProductCard key={product.slug} product={product} />
        ))}
      </div>
    </main>
  )
}
