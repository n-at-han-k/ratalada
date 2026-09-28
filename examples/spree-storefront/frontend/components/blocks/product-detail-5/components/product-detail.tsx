import { Separator } from "@/components/ui/separator"

import { BuyBox } from "./buy-box"
import { ProductGallery } from "./product-gallery"
import { ProductInfo } from "./product-info"
import { RelatedProducts } from "./related-products"
import { ReviewsSnippet } from "./reviews-snippet"

export function ProductDetail() {
  return (
    <section
      aria-label="Product detail"
      className="mx-auto flex w-full max-w-6xl flex-col gap-10 px-4 py-8 md:px-6 md:py-12 md:gap-14"
    >
      {/* Hero - gallery + dense buy column */}
      <div className="grid grid-cols-1 items-start gap-8 lg:grid-cols-2 lg:gap-12">
        <div className="lg:sticky lg:top-8">
          <ProductGallery />
        </div>
        <BuyBox />
      </div>

      <Separator />

      {/* Details - description + specs */}
      <ProductInfo />

      <Separator />

      {/* Reviews snippet - summary + featured quote */}
      <ReviewsSnippet />

      <Separator />

      {/* Related - compact 4-up grid */}
      <RelatedProducts />
    </section>
  )
}