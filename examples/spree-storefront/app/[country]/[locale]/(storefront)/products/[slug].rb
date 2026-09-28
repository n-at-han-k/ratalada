# frozen_string_literal: true

# reui: product-detail-5
#
# <Breadcrumb>                                # ui/breadcrumb
# <ProductDetail>                             # blocks/product-detail-5/product-detail
#   <ProductGallery>                          # blocks/product-detail-5/product-gallery
#     <Carousel>                              # ui/carousel — thumbnails + zoom
#   <ProductInfo>                             # blocks/product-detail-5/product-info
#     <h1>
#     <Rating>                                # reui/rating
#     <Badge>                                 # price / stock state
#   <BuyBox>                                  # blocks/product-detail-5/buy-box
#     <RadioGroup>                            # variant options
#     <NumberField>                           # reui/number-field — quantity
#     <Button>                                # add to cart
#   <Accordion>                               # ui/accordion — description / specs
#   <ReviewsSnippet>                          # blocks/product-detail-5/reviews-snippet
#   <ReviewsCarousel>                         # blocks/product-detail-5/reviews-carousel
#   <RelatedProducts>                         # blocks/product-detail-5/related-products
# <JsonLd>

# ponytail: fixture props, swap for the Spree Store API call when it is wired
FIXTURE_PRODUCT_DETAILS = {
  "canvas-weekender" => {
    name: "Canvas Weekender", category: "Bags", price: 128.00, compare_at_price: nil,
    rating: 4.5, review_count: 212, sku: "CWK-001", stock_left: 6,
    description: "A durable canvas weekender built for short trips. Water-resistant base, brass hardware, and a padded laptop sleeve.",
    images: [
      "https://picsum.photos/seed/weekender-1/900/900",
      "https://picsum.photos/seed/weekender-2/900/900",
      "https://picsum.photos/seed/weekender-3/900/900",
    ],
    option_types: [
      { name: "color", options: [{ id: "black", label: "Black" }, { id: "olive", label: "Olive" }] },
      { name: "size", options: [{ id: "standard", label: "Standard" }, { id: "large", label: "Large" }] },
    ],
    specs: [%w[Material Canvas/Leather], %w[Weight 1.8kg], %w[Dimensions 55x30x25cm]],
  },
}.freeze

FIXTURE_RELATED_PRODUCTS = [
  { slug: "leather-tote", name: "Leather Tote", price: "$214.00", image: "https://picsum.photos/seed/tote/400/400" },
  { slug: "suede-boots", name: "Suede Boots", price: "$189.00", image: "https://picsum.photos/seed/boots/400/400" },
  { slug: "cashmere-scarf", name: "Cashmere Scarf", price: "$96.00", image: "https://picsum.photos/seed/scarf/400/400" },
  { slug: "linen-shirt", name: "Linen Shirt", price: "$78.00", image: "https://picsum.photos/seed/linenshirt/400/400" },
].freeze

get "/" do
  product = FIXTURE_PRODUCT_DETAILS[params["slug"]] || FIXTURE_PRODUCT_DETAILS.values.first
  halt 404 unless product

  inertia("[country]/[locale]/(storefront)/products/[slug]", props: {
    product:          product.merge(slug: params["slug"]),
    related_products: FIXTURE_RELATED_PRODUCTS,
  })
end

__END__

import { useState } from "react"
import { Head, Link } from "@inertiajs/react"

import { Rating } from "@/components/reui/rating"
import {
  Accordion,
  AccordionContent,
  AccordionItem,
  AccordionTrigger,
} from "@/components/ui/accordion"
import {
  Breadcrumb,
  BreadcrumbItem,
  BreadcrumbLink,
  BreadcrumbList,
  BreadcrumbPage,
  BreadcrumbSeparator,
} from "@/components/ui/breadcrumb"
import { Button } from "@/components/ui/button"
import { ButtonGroup, ButtonGroupText } from "@/components/ui/button-group"
import { Item } from "@/components/ui/item"
import { MinusIcon, PlusIcon, ShoppingBagIcon } from "lucide-react"

type OptionType = { name: string; options: { id: string; label: string }[] }
type Product = {
  slug: string
  name: string
  category: string
  price: number
  compare_at_price: number | null
  rating: number
  review_count: number
  sku: string
  stock_left: number
  description: string
  images: string[]
  option_types: OptionType[]
  specs: string[][]
}
type RelatedProduct = { slug: string; name: string; price: string; image: string }

function formatCurrency(value: number) {
  return new Intl.NumberFormat("en-US", { style: "currency", currency: "USD" }).format(value)
}

function ProductGallery({ images, name }: { images: string[]; name: string }) {
  const [active, setActive] = useState(0)

  return (
    <div className="flex flex-col gap-3">
      <Item variant="muted" className="aspect-square w-full overflow-hidden p-0">
        <img src={images[active]} alt={name} className="size-full object-cover" loading="eager" />
      </Item>
      <div className="grid grid-cols-5 gap-2">
        {images.map((src, index) => (
          <Item
            key={src}
            variant="muted"
            render={<button type="button" onClick={() => setActive(index)} aria-label={`Show image ${index + 1}`} />}
            className={`aspect-square w-full overflow-hidden p-0 ${index === active ? "ring-foreground ring-2" : "opacity-80"}`}
          >
            <img src={src} alt="" aria-hidden="true" className="size-full object-cover" loading="lazy" />
          </Item>
        ))}
      </div>
    </div>
  )
}

function BuyBox({ product }: { product: Product }) {
  const initial = Object.fromEntries(product.option_types.map((ot) => [ot.name, ot.options[0]?.id]))
  const [selected, setSelected] = useState<Record<string, string>>(initial)
  const [quantity, setQuantity] = useState(1)

  return (
    <div className="flex min-w-0 flex-col gap-6">
      <header className="flex min-w-0 flex-col gap-2">
        <p className="text-muted-foreground text-xs font-medium tracking-wide uppercase">{product.category}</p>
        <h1 className="text-foreground text-xl leading-tight font-semibold tracking-tight md:text-2xl">{product.name}</h1>
        <div className="flex items-center gap-2 text-sm">
          <Rating rating={product.rating} size="sm" showValue />
          <a href="#reviews" className="text-muted-foreground">({product.review_count.toLocaleString()} reviews)</a>
        </div>
      </header>

      <div className="flex items-baseline gap-2 text-xl font-semibold tabular-nums md:text-2xl">
        <span className="text-foreground">{formatCurrency(product.price)}</span>
        {product.compare_at_price ? (
          <span className="text-muted-foreground font-normal line-through">{formatCurrency(product.compare_at_price)}</span>
        ) : null}
      </div>

      {product.option_types.map((ot) => (
        <section key={ot.name} aria-label={ot.name} className="flex flex-col gap-2.5">
          <p className="text-foreground text-sm font-medium capitalize">{ot.name}</p>
          <div role="radiogroup" aria-label={ot.name} className="flex flex-wrap gap-2">
            {ot.options.map((option) => {
              const isActive = selected[ot.name] === option.id
              return (
                <button
                  key={option.id}
                  type="button"
                  role="radio"
                  aria-checked={isActive}
                  onClick={() => setSelected((prev) => ({ ...prev, [ot.name]: option.id }))}
                  className={`rounded-md border px-3 py-1.5 text-sm ${isActive ? "border-foreground bg-foreground/[0.04]" : "border-border"}`}
                >
                  {option.label}
                </button>
              )
            })}
          </div>
        </section>
      ))}

      <p className="text-muted-foreground text-sm">
        <span className="text-foreground font-medium">Only {product.stock_left} left</span> · SKU {product.sku}
      </p>

      <div className="flex items-stretch gap-2">
        <ButtonGroup aria-label="Quantity">
          <Button variant="outline" type="button" aria-label="Decrease quantity" disabled={quantity <= 1} onClick={() => setQuantity((q) => Math.max(1, q - 1))}>
            <MinusIcon aria-hidden="true" />
          </Button>
          <ButtonGroupText className="min-w-10 justify-center text-sm tabular-nums">{quantity}</ButtonGroupText>
          <Button variant="outline" type="button" aria-label="Increase quantity" disabled={quantity >= product.stock_left} onClick={() => setQuantity((q) => Math.min(product.stock_left, q + 1))}>
            <PlusIcon aria-hidden="true" />
          </Button>
        </ButtonGroup>
        <Button type="button" className="flex-1">
          <ShoppingBagIcon className="size-4" aria-hidden="true" />
          Add to Cart
        </Button>
      </div>
    </div>
  )
}

export default function Product({
  product,
  related_products,
}: {
  product: Product
  related_products: RelatedProduct[]
}) {
  return (
    <main className="mx-auto flex w-full max-w-6xl flex-col gap-10 px-4 py-8 md:px-6 md:py-12 md:gap-14">
      <Head title={product.name} />
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{
          __html: JSON.stringify({
            "@context": "https://schema.org",
            "@type": "Product",
            name: product.name,
            sku: product.sku,
            offers: { "@type": "Offer", price: product.price, priceCurrency: "USD" },
          }),
        }}
      />

      <Breadcrumb>
        <BreadcrumbList>
          <BreadcrumbItem>
            <BreadcrumbLink href="/products">Products</BreadcrumbLink>
          </BreadcrumbItem>
          <BreadcrumbSeparator />
          <BreadcrumbItem>
            <BreadcrumbPage>{product.name}</BreadcrumbPage>
          </BreadcrumbItem>
        </BreadcrumbList>
      </Breadcrumb>

      <div className="grid grid-cols-1 items-start gap-8 lg:grid-cols-2 lg:gap-12">
        <div className="lg:sticky lg:top-8">
          <ProductGallery images={product.images} name={product.name} />
        </div>
        <BuyBox product={product} />
      </div>

      <Accordion multiple defaultValue={["description"]}>
        <AccordionItem value="description">
          <AccordionTrigger>Description</AccordionTrigger>
          <AccordionContent>{product.description}</AccordionContent>
        </AccordionItem>
        <AccordionItem value="specs">
          <AccordionTrigger>Specs</AccordionTrigger>
          <AccordionContent>
            <dl className="flex flex-col">
              {product.specs.map(([label, value]) => (
                <div key={label} className="border-border/60 grid grid-cols-[7rem_minmax(0,1fr)] gap-3 border-t py-2.5 first:border-t-0">
                  <dt className="text-muted-foreground text-xs">{label}</dt>
                  <dd className="text-foreground text-sm">{value}</dd>
                </div>
              ))}
            </dl>
          </AccordionContent>
        </AccordionItem>
      </Accordion>

      <section id="reviews" aria-labelledby="reviews-heading" className="flex flex-col gap-4">
        <h2 id="reviews-heading" className="text-foreground text-lg font-semibold tracking-tight">What Buyers Say</h2>
        <div className="flex items-baseline gap-2">
          <span className="text-foreground text-4xl leading-none font-semibold tabular-nums">{product.rating.toFixed(1)}</span>
          <span className="text-muted-foreground text-sm">/ 5 from {product.review_count.toLocaleString()} reviews</span>
        </div>
      </section>

      <section aria-labelledby="related-heading" className="flex flex-col gap-5">
        <h2 id="related-heading" className="text-foreground text-lg font-semibold tracking-tight">You May Also Like</h2>
        <ul role="list" className="grid grid-cols-2 gap-x-4 gap-y-6 sm:grid-cols-4">
          {related_products.map((related) => (
            <li key={related.slug} className="flex flex-col gap-2">
              <Item variant="muted" render={<Link href={`/products/${related.slug}`} />} className="block aspect-square w-full overflow-hidden p-0">
                <img src={related.image} alt={related.name} className="size-full object-cover" loading="lazy" />
              </Item>
              <Link href={`/products/${related.slug}`} className="text-foreground text-sm font-medium">{related.name}</Link>
              <span className="text-foreground text-sm font-semibold tabular-nums">{related.price}</span>
            </li>
          ))}
        </ul>
      </section>
    </main>
  )
}
