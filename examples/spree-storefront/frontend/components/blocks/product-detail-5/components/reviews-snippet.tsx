import { Rating } from "@/components/reui/rating"

import { Button } from "@/components/ui/button"
import { Progress } from "@/components/ui/progress"
import { PRODUCT, REVIEW_BREAKDOWN } from "./data"
import { ReviewsCarousel } from "./reviews-carousel"
import { ArrowRightIcon } from "lucide-react"

const TOTAL_REVIEWS = REVIEW_BREAKDOWN.reduce(
  (sum, row) => sum + row.count,
  0
)

export function ReviewsSnippet() {
  return (
    <section
      id="reviews"
      aria-labelledby="reviews-heading"
      className="flex flex-col gap-6"
    >
      <header className="flex items-baseline justify-between gap-3">
        <h2
          id="reviews-heading"
          className="text-foreground text-lg leading-tight font-semibold tracking-tight md:text-xl"
        >
          What Buyers Say
        </h2>
        <Button
          nativeButton={false}
          variant="ghost"
          size="sm"
          className="hover:text-primary gap-1.5 px-0 hover:bg-transparent"
          render={
            <a
              href={`/reviews/${PRODUCT.sku.toLowerCase()}`}
              aria-label={`Read all ${PRODUCT.reviewCount} reviews for ${PRODUCT.name}`}
            />
          }
        >
          See All {PRODUCT.reviewCount.toLocaleString()}
          <ArrowRightIcon className="size-4" aria-hidden="true" />
        </Button>
      </header>

      <div className="grid grid-cols-1 gap-8 lg:grid-cols-2 lg:gap-12">
        {/* Rating column - big number, stars, breakdown */}
        <div className="flex flex-col gap-4">
          <span className="text-muted-foreground text-xs font-medium tracking-[0.18em] uppercase">
            Rating
          </span>
          <div className="flex items-baseline gap-2">
            <span className="text-foreground text-4xl leading-none font-semibold tabular-nums">
              {PRODUCT.rating.toFixed(1)}
            </span>
            <span className="text-muted-foreground text-sm">/ 5</span>
          </div>
          <div className="flex flex-wrap items-center gap-x-3 gap-y-1">
            <Rating rating={PRODUCT.rating} size="sm" />
            <span className="text-muted-foreground text-xs">
              {PRODUCT.reviewCount.toLocaleString()} verified reviews
            </span>
          </div>
          <ul
            className="flex flex-col gap-1.5 pt-1"
            role="list"
            aria-label="Rating breakdown"
          >
            {REVIEW_BREAKDOWN.map((row) => {
              const pct =
                TOTAL_REVIEWS === 0
                  ? 0
                  : Math.round((row.count / TOTAL_REVIEWS) * 100)
              return (
                <li
                  key={row.stars}
                  className="grid grid-cols-[1.25rem_minmax(0,1fr)_2.5rem] items-center gap-3"
                >
                  <span className="text-muted-foreground text-xs font-medium tabular-nums">
                    {row.stars}★
                  </span>
                  <Progress
                    value={pct}
                    aria-label={`${row.stars}-star reviews: ${pct}%`}
                  />
                  <span className="text-muted-foreground text-right text-xs tabular-nums">
                    {row.count.toLocaleString()}
                  </span>
                </li>
              )
            })}
          </ul>
        </div>

        {/* Featured reviews column - paginated, autoplaying carousel */}
        <div className="flex flex-col gap-4">
          <span className="text-muted-foreground text-xs font-medium tracking-[0.18em] uppercase">
            Featured Reviews
          </span>
          <ReviewsCarousel />
        </div>
      </div>
    </section>
  )
}