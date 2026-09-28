# frozen_string_literal: true

# reui: shop-hero-2, product-grid-3
#
# <HeroSection>                               # blocks/shop-hero-2/hero
#   <h1>
#   <p>
#   <Button>                                  # shop now
#   <Button>
# <FeaturedProductsSection>
#   <h2>
#   <Button>                                  # view all
#   <ProductGrid>                             # blocks/product-grid-3/product-grid
#     <ProductCard>                           # blocks/product-grid-3/product-card
#       <Badge>                               # reui/badge — sale / new
#       <Rating>                              # reui/rating
#   <Skeleton>                                # ui/skeleton fallback
# <WholesaleSection>                          # hand-roll: ui/card + ui/button
#   <h2>
#   <p>
#   <Button>                                  # enter portal
#   <Button>                                  # apply
#   <ul>
#     <li>                                    # benefit

get "/" do
  inertia("[country]/[locale]/(storefront)/index")
end

__END__

import { Head } from "@inertiajs/react"

export default function Home() {
  return (
    <main className="p-6">
      <Head title="Home" />
      <h1 className="text-2xl font-semibold">Home</h1>
    </main>
  )
}
