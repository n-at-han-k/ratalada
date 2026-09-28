"use client"

import { useEffect, useMemo, useState } from "react"
import { Badge } from "@/components/reui/badge"
import { Rating } from "@/components/reui/rating"
import { cn } from "cn"
import Autoplay from "embla-carousel-autoplay"

import {
  Avatar,
  AvatarFallback,
  AvatarImage,
} from "@/components/ui/avatar"
import {
  Carousel,
  CarouselContent,
  CarouselItem,
  type CarouselApi,
} from "@/components/ui/carousel"

import { ECOMMERCE_LINK_CLASS_NAME, FEATURED_REVIEWS } from "./data"

function initials(name: string) {
  return name
    .split(/\s+/)
    .map((part) => part[0])
    .filter(Boolean)
    .slice(0, 2)
    .join("")
    .toUpperCase()
}

export function ReviewsCarousel() {
  const [api, setApi] = useState<CarouselApi>()
  const [selectedSnap, setSelectedSnap] = useState(0)

  const plugins = useMemo(
    () => [
      Autoplay({
        delay: 7000,
        stopOnInteraction: false,
        stopOnMouseEnter: true,
      }),
    ],
    []
  )

  useEffect(() => {
    if (!api) return

    function updateSnap(carouselApi: CarouselApi) {
      if (!carouselApi) return
      setSelectedSnap(carouselApi.selectedScrollSnap())
    }

    updateSnap(api)
    api.on("select", updateSnap)
    api.on("reInit", updateSnap)

    return () => {
      api.off("select", updateSnap)
      api.off("reInit", updateSnap)
    }
  }, [api])

  return (
    <Carousel
      setApi={setApi}
      plugins={plugins}
      opts={{ align: "start", loop: true }}
      className="flex flex-col gap-4"
      aria-label="Featured customer reviews"
    >
      <CarouselContent>
        {FEATURED_REVIEWS.map((review) => (
          <CarouselItem key={review.id} className="basis-full">
            <figure className="flex flex-col gap-4">
              <div className="flex flex-wrap items-center gap-2">
                <Rating rating={review.rating} size="sm" />
                {review.verified ? (
                  <Badge variant="success-light" radius="full">
                    Verified
                  </Badge>
                ) : null}
              </div>

              <h3 className="text-foreground text-base leading-snug font-semibold">
                {review.title}
              </h3>

              <blockquote className="text-foreground/90 border-border/70 border-l-2 pl-4 text-sm leading-relaxed text-pretty">
                {review.body}
              </blockquote>

              <figcaption className="flex flex-wrap items-center gap-x-2 gap-y-1 text-xs">
                <Avatar size="sm">
                  <AvatarImage src={review.authorAvatar} alt={review.author} />
                  <AvatarFallback className="bg-muted text-foreground text-xs font-medium">
                    {initials(review.author)}
                  </AvatarFallback>
                </Avatar>
                <a
                  href={review.authorHref}
                  className={cn(
                    "text-foreground font-medium",
                    ECOMMERCE_LINK_CLASS_NAME
                  )}
                >
                  {review.author}
                </a>
                <span
                  aria-hidden="true"
                  className="bg-muted-foreground/40 size-1 shrink-0 rounded-full"
                />
                <span className="text-muted-foreground">{review.postedAt}</span>
              </figcaption>
            </figure>
          </CarouselItem>
        ))}
      </CarouselContent>

      {/* Pagination dots - active grows to a pill */}
      <div className="flex items-center gap-1.5">
        {FEATURED_REVIEWS.map((review, index) => {
          const isActive = index === selectedSnap
          return (
            <button
              key={review.id}
              type="button"
              aria-label={`Go to review ${index + 1} of ${FEATURED_REVIEWS.length}`}
              aria-current={isActive ? "true" : undefined}
              onClick={() => api?.scrollTo(index)}
              data-active={isActive}
              className="bg-muted-foreground/30 focus-visible:ring-ring hover:bg-muted-foreground/60 data-[active=true]:bg-foreground size-1.5 rounded-full transition-all duration-300 ease-out focus-visible:ring-2 focus-visible:ring-offset-2 focus-visible:outline-none data-[active=true]:w-6"
            />
          )
        })}
      </div>
    </Carousel>
  )
}