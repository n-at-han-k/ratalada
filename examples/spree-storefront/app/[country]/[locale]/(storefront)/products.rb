# frozen_string_literal: true

# reui: product-grid-3, filter-sidebar-6
#
# <h1>
# <p>
# <FilterSidebar>                             # blocks/filter-sidebar-6/filter-sidebar
#   <Checkbox>                                # facet values
#   <Slider>                                  # price range
#   <Switch>                                  # in-stock only
#   <Rating>                                  # reui/rating
# <ProductGrid>                               # blocks/product-grid-3/product-grid
#   <ProductCard>                             # blocks/product-grid-3/product-card
# <Spinner>                                   # ui/spinner — loading more
# <Empty>                                     # ui/empty — no results

# ponytail: fixture props, swap for the Spree Store API call when it is wired
FIXTURE_PRODUCTS = [
  { slug: "canvas-weekender", name: "Canvas Weekender", price: "$128.00", compare_at_price: nil,
    image: "https://picsum.photos/seed/weekender/640/640", category: "Bags", rating: 4.5, review_count: 212, in_stock: true },
  { slug: "leather-tote", name: "Leather Tote", price: "$214.00", compare_at_price: "$260.00",
    image: "https://picsum.photos/seed/tote/640/640", category: "Bags", rating: 4.8, review_count: 96, in_stock: true },
  { slug: "wool-overcoat", name: "Wool Overcoat", price: "$340.00", compare_at_price: nil,
    image: "https://picsum.photos/seed/overcoat/640/640", category: "Outerwear", rating: 4.6, review_count: 58, in_stock: false },
  { slug: "linen-shirt", name: "Linen Shirt", price: "$78.00", compare_at_price: nil,
    image: "https://picsum.photos/seed/linenshirt/640/640", category: "Tops", rating: 4.2, review_count: 143, in_stock: true },
  { slug: "suede-boots", name: "Suede Boots", price: "$189.00", compare_at_price: "$225.00",
    image: "https://picsum.photos/seed/boots/640/640", category: "Footwear", rating: 4.7, review_count: 301, in_stock: true },
  { slug: "cashmere-scarf", name: "Cashmere Scarf", price: "$96.00", compare_at_price: nil,
    image: "https://picsum.photos/seed/scarf/640/640", category: "Accessories", rating: 4.9, review_count: 44, in_stock: true },
].freeze

get "/" do
  category  = params["category"]
  in_stock  = params["in_stock"] == "1"
  min_rating = params["rating"].to_f

  products = FIXTURE_PRODUCTS
  products = products.select { _1[:category] == category } if category && !category.empty?
  products = products.select { _1[:in_stock] } if in_stock
  products = products.select { _1[:rating] >= min_rating } if min_rating.positive?

  inertia("[country]/[locale]/(storefront)/products", props: {
    products:   products,
    categories: FIXTURE_PRODUCTS.map { _1[:category] }.uniq.sort,
    filters:    { category: category, in_stock: in_stock, rating: params["rating"] },
  })
end

__END__

import { Head, Link, router } from "@inertiajs/react"

import { Badge } from "@/components/reui/badge"
import { Rating } from "@/components/reui/rating"
import { Button } from "@/components/ui/button"
import { Checkbox } from "@/components/ui/checkbox"
import { Empty, EmptyDescription, EmptyHeader, EmptyTitle } from "@/components/ui/empty"
import { Item } from "@/components/ui/item"
import { Label } from "@/components/ui/label"
import { Switch } from "@/components/ui/switch"
import { PackageSearchIcon, ShoppingBagIcon } from "lucide-react"

type Product = {
  slug: string
  name: string
  price: string
  compare_at_price: string | null
  image: string
  category: string
  rating: number
  review_count: number
  in_stock: boolean
}

type Filters = { category: string | null; in_stock: boolean; rating: string | null }

// Filter changes are Inertia visits against this same route — no client
// router, the URL is the state.
function visit(next: Partial<Filters>, filters: Filters) {
  const merged = { ...filters, ...next }
  router.get(
    "/products",
    {
      category: merged.category || undefined,
      in_stock: merged.in_stock ? "1" : undefined,
      rating: merged.rating || undefined,
    },
    { preserveState: true, preserveScroll: true, replace: true }
  )
}

function FilterSidebar({
  categories,
  filters,
}: {
  categories: string[]
  filters: Filters
}) {
  return (
    <aside aria-label="Product filters" className="w-full shrink-0 md:w-56">
      <div className="flex flex-col gap-6">
        <div>
          <h2 className="text-foreground mb-3 text-sm font-semibold tracking-tight">Category</h2>
          <ul className="flex flex-col gap-2.5">
            {categories.map((category) => {
              const id = `cat-${category}`
              const checked = filters.category === category
              return (
                <li key={category} className="flex items-center gap-2.5">
                  <Checkbox
                    id={id}
                    checked={checked}
                    onCheckedChange={() => visit({ category: checked ? null : category }, filters)}
                  />
                  <Label htmlFor={id} className="text-foreground text-sm font-normal">
                    {category}
                  </Label>
                </li>
              )
            })}
          </ul>
        </div>

        <div>
          <h2 className="text-foreground mb-3 text-sm font-semibold tracking-tight">Rating</h2>
          <div className="flex flex-col gap-2">
            {[4, 3].map((stars) => (
              <button
                key={stars}
                type="button"
                onClick={() => visit({ rating: filters.rating === String(stars) ? null : String(stars) }, filters)}
                aria-pressed={filters.rating === String(stars)}
                className="flex items-center gap-2 text-sm"
              >
                <Rating rating={stars} size="sm" />
                <span className="text-muted-foreground text-xs">& up</span>
              </button>
            ))}
          </div>
        </div>

        <div className="flex items-center justify-between gap-3">
          <Label htmlFor="in-stock" className="text-foreground text-sm font-normal">
            In stock only
          </Label>
          <Switch
            id="in-stock"
            checked={filters.in_stock}
            onCheckedChange={(checked) => visit({ in_stock: checked }, filters)}
            size="sm"
          />
        </div>
      </div>
    </aside>
  )
}

function ProductCard({ product }: { product: Product }) {
  return (
    <article className="flex min-w-0 flex-col gap-3">
      <Item variant="muted" className="relative aspect-square w-full overflow-hidden border-0 p-0 shadow-none">
        <Link href={`/products/${product.slug}`} aria-label={`View ${product.name}`} className="absolute inset-0 block">
          <img src={product.image} alt={product.name} className="absolute inset-0 size-full object-cover" loading="lazy" />
        </Link>
        {product.compare_at_price ? (
          <div className="absolute top-3 left-3">
            <Badge variant="destructive" radius="full">Sale</Badge>
          </div>
        ) : null}
      </Item>
      <div className="flex min-w-0 flex-col gap-1.5">
        <span className="text-muted-foreground text-xs font-medium tracking-wide uppercase">{product.category}</span>
        <h3 className="text-foreground truncate text-base leading-snug font-medium">
          <Link href={`/products/${product.slug}`}>{product.name}</Link>
        </h3>
        <div className="flex items-center gap-1.5">
          <Rating rating={product.rating} size="sm" showValue />
          <span className="text-muted-foreground text-xs tabular-nums">({product.review_count})</span>
        </div>
        <div className="flex items-baseline gap-2 text-base font-semibold tabular-nums">
          <span className="text-foreground">{product.price}</span>
          {product.compare_at_price ? (
            <span className="text-muted-foreground font-normal line-through">{product.compare_at_price}</span>
          ) : null}
        </div>
        <Button type="button" disabled={!product.in_stock} className="mt-1 w-full">
          <ShoppingBagIcon className="size-4" aria-hidden="true" />
          {product.in_stock ? "Add to Cart" : "Out of Stock"}
        </Button>
      </div>
    </article>
  )
}

export default function Products({
  products,
  categories,
  filters,
}: {
  products: Product[]
  categories: string[]
  filters: Filters
}) {
  return (
    <main className="mx-auto w-full max-w-6xl px-4 py-8 md:px-6 md:py-12">
      <Head title="Products" />
      <h1 className="text-2xl font-semibold">Products</h1>
      <p className="text-muted-foreground mt-1 text-sm">Browse the full collection.</p>

      <div className="mt-8 flex flex-col gap-8 md:flex-row">
        <FilterSidebar categories={categories} filters={filters} />

        {products.length === 0 ? (
          <Empty className="flex-1">
            <EmptyHeader>
              <PackageSearchIcon className="text-muted-foreground size-8" aria-hidden="true" />
              <EmptyTitle>No products found</EmptyTitle>
              <EmptyDescription>Try adjusting or clearing your filters.</EmptyDescription>
            </EmptyHeader>
          </Empty>
        ) : (
          <div className="grid flex-1 grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-3">
            {products.map((product) => (
              <ProductCard key={product.slug} product={product} />
            ))}
          </div>
        )}
      </div>
    </main>
  )
}
