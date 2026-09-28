# frozen_string_literal: true

# reui: navbar-12, product-grid-3, filter-sidebar-6, auth-16, empty-state-14
#
# <WholesaleHeader>                           # blocks/navbar-12/navbar, trimmed
#   <Badge>                                   # reui/badge — TRADE
#   <Link>                                    # catalog / quick order / cart
#   <Button>                                  # back to store
# <h1>
# <p>
# <FilterSidebar>                             # blocks/filter-sidebar-6/filter-sidebar
# <ProductGrid>                               # blocks/product-grid-3/product-grid
#   <ProductCard>                             # blocks/product-grid-3/product-card
# <CartDrawer>                                # blocks/shopping-cart-7/mini-cart-sheet
# # gate alternatives
# <SignInWall>                                # blocks/auth-16/auth
# <ApplicationPending>                        # blocks/empty-state-14/empty-state
# <GuestBrowse>                               # same grid, prices hidden

get "/" do
  gate = wholesale_status

  inertia("[country]/[locale]/(wholesale)/wholesale/index", props: {
    gate:       gate,
    customer:   gate == "guest" ? nil : wholesale_customer,
    cart_count: gate == "approved" ? 2 : 0,
    products:   wholesale_products,
  })
end

# Fixture sign-out (the header's "Sign out" link posts here). The real thing
# destroys the Spree customer session; this just drops the fixture flag.
delete "/" do
  session[:wholesale_status] = nil
  redirect("/wholesale", 303)
end

__END__

import { Head, Link } from "@inertiajs/react"

import {
  WholesaleApplicationPending,
  WholesaleHeader,
} from "@/components/wholesale"

interface Product {
  slug: string
  name: string
  sku: string
  category: string
  case_pack: number
  trade_price: number
  retail_price: number
  image: string
}

const money = (value: number) => `$${value.toFixed(2)}`

// blocks/product-grid-3/product-card, trimmed to what the fixture carries
// (no rating/wishlist/badge -- this is a B2B case-pack listing, not the DTC
// card). `pricesHidden` swaps the price for a sign-in prompt, for a guest
// browsing the `prices_hidden` channel this fixture stands in for.
function ProductGrid({
  products,
  pricesHidden,
}: {
  products: Product[]
  pricesHidden: boolean
}) {
  return (
    <div className="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-3">
      {products.map((product) => (
        <article key={product.slug} className="flex flex-col gap-3">
          <Link
            href={`/wholesale/products/${product.slug}`}
            className="block aspect-square overflow-hidden rounded-lg bg-slate-100"
          >
            <img
              src={product.image}
              alt={product.name}
              className="size-full object-cover transition-transform duration-500 hover:scale-105"
              loading="lazy"
            />
          </Link>
          <div className="flex flex-col gap-1">
            <p className="text-xs font-medium tracking-wide text-slate-500 uppercase">
              {product.category}
            </p>
            <Link
              href={`/wholesale/products/${product.slug}`}
              className="font-medium tracking-tight text-slate-900 hover:underline"
            >
              {product.name}
            </Link>
            <p className="text-xs text-slate-500">
              SKU {product.sku} · case of {product.case_pack}
            </p>
            {pricesHidden ? (
              <Link
                href="/wholesale/sign-in"
                className="text-sm font-medium text-slate-900 underline underline-offset-4"
              >
                Sign in for pricing
              </Link>
            ) : (
              <p className="text-sm font-semibold tabular-nums text-slate-900">
                {money(product.trade_price)} / unit
                <span className="ml-2 font-normal text-slate-400 line-through">
                  {money(product.retail_price)}
                </span>
              </p>
            )}
          </div>
        </article>
      ))}
    </div>
  )
}

// blocks/filter-sidebar-6/filter-sidebar, trimmed to a static category list.
function FilterSidebar({ categories }: { categories: string[] }) {
  return (
    <aside className="hidden w-48 shrink-0 lg:block">
      {/* ponytail: decorative -- no query params wired, add real filtering
          when the catalog needs to filter for more than 5 fixture SKUs */}
      <p className="mb-2 text-xs font-semibold tracking-wide text-slate-500 uppercase">
        Category
      </p>
      <ul className="flex flex-col gap-1 text-sm text-slate-600">
        {categories.map((category) => (
          <li key={category}>{category}</li>
        ))}
      </ul>
    </aside>
  )
}

export default function Wholesale({
  gate,
  customer,
  cart_count,
  products,
}: {
  gate: "guest" | "pending" | "approved"
  customer: { name: string; email: string; company: string } | null
  cart_count: number
  products: Product[]
}) {
  const categories = [...new Set(products.map((p) => p.category))]

  if (gate === "pending" && customer) {
    return (
      <>
        <Head title="Wholesale" />
        <WholesaleApplicationPending customer={customer} />
      </>
    )
  }

  // Guest and approved both see the catalog -- this fixture's channel is
  // `prices_hidden`, so a guest browses with pricing swapped for a sign-in
  // prompt instead of hitting the hard sign-in wall (that's cart/quick-order,
  // which are ordering surfaces and always wall a guest off).
  return (
    <div className="min-h-screen bg-slate-50">
      <Head title="Wholesale" />
      <WholesaleHeader
        authenticated={gate === "approved"}
        customerName={customer?.name}
        cartCount={cart_count}
      />
      <div className="mx-auto flex gap-8 px-4 py-8 sm:px-6 lg:px-8">
        <FilterSidebar categories={categories} />
        <div className="min-w-0 flex-1">
          <h1 className="text-3xl font-bold text-slate-900">Wholesale catalog</h1>
          <p className="mt-2 text-slate-500">
            {gate === "approved"
              ? `Trade pricing for ${customer?.company}. Minimum order is one case per SKU.`
              : "Case-pack pricing for approved trade accounts."}
          </p>
          <div className="mt-8">
            <ProductGrid products={products} pricesHidden={gate !== "approved"} />
          </div>
        </div>
      </div>
    </div>
  )
}
