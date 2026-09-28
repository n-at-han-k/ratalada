# frozen_string_literal: true

# reui: product-detail-5
#
# <WholesaleHeader>                           # blocks/navbar-12/navbar, trimmed
# <p>                                         # wholesale pricing notice
# <ProductDetail>                             # blocks/product-detail-5/product-detail
#   <ProductGallery>                          # blocks/product-detail-5/product-gallery
#   <ProductInfo>                             # blocks/product-detail-5/product-info
#   <BuyBox>                                  # blocks/product-detail-5/buy-box
#     <NumberField>                           # reui/number-field — case quantity
#     <Button>                                # add to cart

get "/" do
  product = wholesale_product(params["slug"])
  halt(status(404), inertia("+not-found")) unless product

  gate = wholesale_status

  inertia("[country]/[locale]/(wholesale)/wholesale/products/[slug]", props: {
    gate:     gate,
    customer: gate == "guest" ? nil : wholesale_customer,
    product:  product,
  })
end

# ponytail: fixture add-to-cart -- there's no cart to add to yet (cart.rb's
# two lines are hardcoded), so this is a no-op redirect back to the cart.
post "/" do
  redirect("/wholesale/cart", 303)
end

__END__

import { Form, Head, Link } from "@inertiajs/react"

import {
  WholesaleApplicationPending,
  WholesaleHeader,
} from "@/components/wholesale"
import {
  NumberField,
  NumberFieldDecrement,
  NumberFieldGroup,
  NumberFieldIncrement,
  NumberFieldInput,
} from "@/components/reui/number-field"
import { Button } from "@/components/ui/button"

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

function ProductGallery({ product }: { product: Product }) {
  return (
    <div className="aspect-square overflow-hidden rounded-lg bg-slate-100">
      <img src={product.image} alt={product.name} className="size-full object-cover" loading="lazy" />
    </div>
  )
}

function ProductInfo({ product }: { product: Product }) {
  return (
    <div className="flex flex-col gap-2">
      <p className="text-xs font-medium tracking-wide text-slate-500 uppercase">{product.category}</p>
      <h1 className="text-2xl font-bold text-slate-900">{product.name}</h1>
      <p className="text-sm text-slate-500">
        SKU {product.sku} · sold by the case, {product.case_pack} units per case
      </p>
    </div>
  )
}

function BuyBox({ product, pricesHidden }: { product: Product; pricesHidden: boolean }) {
  if (pricesHidden) {
    return (
      <div className="rounded-lg border border-slate-200 bg-white p-5">
        <p className="text-sm text-slate-600">
          <Link href="/wholesale/sign-in" className="font-medium text-slate-900 underline underline-offset-4">
            Sign in
          </Link>{" "}
          to see trade pricing and order this item.
        </p>
      </div>
    )
  }

  return (
    <Form action={`/wholesale/products/${product.slug}`} method="post" className="rounded-lg border border-slate-200 bg-white p-5">
      <p className="text-xl font-semibold tabular-nums text-slate-900">
        {money(product.trade_price)} / unit
        <span className="ml-2 text-sm font-normal text-slate-400 line-through">{money(product.retail_price)}</span>
      </p>
      <p className="mt-1 text-xs text-slate-500">
        Case total: {money(product.trade_price * product.case_pack)}
      </p>

      <div className="mt-4 flex items-center gap-3">
        <NumberField name="cases" defaultValue={1} min={1} size="lg">
          <NumberFieldGroup>
            <NumberFieldDecrement />
            <NumberFieldInput aria-label="Cases" />
            <NumberFieldIncrement />
          </NumberFieldGroup>
        </NumberField>
        <Button type="submit" size="lg" className="flex-1 bg-slate-900 hover:bg-slate-800">
          Add to cart
        </Button>
      </div>
    </Form>
  )
}

export default function WholesaleProduct({
  gate,
  customer,
  product,
}: {
  gate: "guest" | "pending" | "approved"
  customer: { name: string; email: string; company: string } | null
  product: Product
}) {
  if (gate === "pending" && customer) {
    return (
      <>
        <Head title={product.name} />
        <WholesaleApplicationPending customer={customer} />
      </>
    )
  }

  // Browse surface (same posture as the catalog): guests see the product
  // with pricing swapped for a sign-in prompt, rather than the hard wall.
  return (
    <div className="min-h-screen bg-slate-50">
      <Head title={product.name} />
      <WholesaleHeader authenticated={gate === "approved"} customerName={customer?.name} />
      <div className="mx-auto max-w-5xl px-4 py-8 sm:px-6 lg:px-8">
        <p className="mb-6 inline-block rounded-md border border-slate-200 bg-white px-3 py-2 text-sm text-slate-600">
          Case-pack pricing, minimum one case per order.
        </p>
        <div className="grid grid-cols-1 gap-8 md:grid-cols-2">
          <ProductGallery product={product} />
          <div className="flex flex-col gap-6">
            <ProductInfo product={product} />
            <BuyBox product={product} pricesHidden={gate !== "approved"} />
          </div>
        </div>
      </div>
    </div>
  )
}
