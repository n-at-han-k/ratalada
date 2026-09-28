import { Badge } from "@/components/reui/badge"
import { cn } from "cn"

import {
  Breadcrumb,
  BreadcrumbItem,
  BreadcrumbLink,
  BreadcrumbList,
  BreadcrumbPage,
  BreadcrumbSeparator,
} from "@/components/ui/breadcrumb"
import { Button } from "@/components/ui/button"
import {
  ECOMMERCE_LINK_CLASS_NAME,
  seasonalCategories,
  type SeasonalCategory,
} from "./data"
import { ArrowRightIcon, TagIcon, PackageIcon } from "lucide-react"

function ArrowIcon({ className }: { className?: string }) {
  return (
    <ArrowRightIcon data-icon="inline-end" className={className} aria-hidden="true" />
  )
}

function CategoryIcon({ className }: { className?: string }) {
  return (
    <TagIcon className={className} aria-hidden="true" />
  )
}

function PackageGlyph({ className }: { className?: string }) {
  return (
    <PackageIcon className={className} aria-hidden="true" />
  )
}

function CollectionMeta({
  collection,
  className,
  linkClassName,
}: {
  collection: SeasonalCategory
  className?: string
  linkClassName?: string
}) {
  return (
    <div
      className={cn(
        "text-muted-foreground flex min-w-0 flex-wrap items-center gap-x-3 gap-y-1 text-xs leading-5 font-medium",
        className
      )}
    >
      <span className="inline-flex min-w-0 items-center gap-1.5">
        <PackageGlyph className="size-3.5 shrink-0" />
        <span className="truncate tabular-nums">{collection.itemCount}</span>
      </span>
      <span className="inline-flex min-w-0 items-center gap-1.5">
        <CategoryIcon className="size-3.5 shrink-0" />
        <a
          href={collection.href}
          className={linkClassName ?? ECOMMERCE_LINK_CLASS_NAME}
        >
          Seasonal Edit
        </a>
      </span>
    </div>
  )
}

function CollectionCard({
  collection,
  priority,
}: {
  collection: SeasonalCategory
  priority?: boolean
}) {
  const titleId = `${collection.name.toLowerCase().replaceAll(" ", "-")}-title`

  return (
    <article
      aria-labelledby={titleId}
      className="group/card focus-within:ring-ring focus-within:ring-offset-background bg-muted relative aspect-square min-w-0 overflow-hidden rounded-md focus-within:ring-2 focus-within:ring-offset-2 md:aspect-[16/9]"
    >
      <a
        href={collection.href}
        aria-label={`Browse ${collection.name}`}
        className="focus-visible:ring-ring absolute inset-0 z-10 outline-none focus-visible:ring-2 focus-visible:ring-inset"
      >
        <img
          src={collection.image}
          alt={collection.imageAlt}
          loading={priority ? "eager" : "lazy"}
          fetchPriority={priority ? "high" : "auto"}
          className="absolute inset-0 h-full w-full object-cover transition-transform duration-500 ease-out will-change-transform group-focus-within/card:scale-[1.025] group-hover/card:scale-[1.025] motion-reduce:transition-none"
        />
      </a>

      <div
        aria-hidden="true"
        className="pointer-events-none absolute inset-x-0 bottom-0 z-[12] hidden h-36 bg-gradient-to-t from-zinc-950/65 via-zinc-950/20 to-transparent transition-opacity duration-200 ease-out md:block md:group-focus-within/card:opacity-0 md:group-hover/card:opacity-0"
      />

      <div className="pointer-events-none absolute inset-x-4 bottom-4 z-20 hidden items-end justify-between gap-3 transition-opacity duration-200 ease-out md:flex md:group-focus-within/card:opacity-0 md:group-hover/card:opacity-0">
        <div className="min-w-0">
          <p className="text-xs leading-5 font-medium text-zinc-50/80">
            Collection
          </p>
          <h3
            id={titleId}
            className="max-w-[16rem] text-xl leading-7 font-semibold text-balance text-zinc-50"
          >
            <a
              href={collection.href}
              className="pointer-events-auto relative z-30 underline-offset-4 hover:underline"
            >
              {collection.name}
            </a>
          </h3>
        </div>

        {collection.badge ? (
          <Badge
            variant="outline"
            radius="full"
            className="pointer-events-none shrink-0 border-white/30 bg-zinc-950/25 text-white"
          >
            {collection.badge.label}
          </Badge>
        ) : null}
      </div>

      <div className="absolute inset-0 z-30 bg-zinc-950/68 p-4 text-white transition-opacity duration-500 ease-[cubic-bezier(0.22,1,0.36,1)] group-focus-within/card:opacity-100 motion-reduce:transition-none md:pointer-events-none md:opacity-0 md:group-focus-within/card:pointer-events-auto md:group-hover/card:pointer-events-auto md:group-hover/card:opacity-100">
        <div className="flex h-full min-w-0 flex-col">
          <div className="flex min-w-0 flex-col gap-3 transition-[opacity,translate] duration-500 ease-[cubic-bezier(0.22,1,0.36,1)] will-change-transform motion-reduce:transition-none md:-translate-y-4 md:opacity-0 md:group-focus-within/card:translate-y-0 md:group-focus-within/card:opacity-100 md:group-hover/card:translate-y-0 md:group-hover/card:opacity-100">
            <div className="min-w-0">
              <CollectionMeta
                collection={collection}
                className="text-white/80"
                linkClassName="underline-offset-4 transition-colors hover:text-white hover:underline"
              />
              <h3 className="mt-3 min-w-0 text-xl leading-6 font-semibold text-white">
                <a
                  href={collection.href}
                  className="line-clamp-1 underline-offset-4 hover:underline focus-visible:ring-2 focus-visible:ring-zinc-50 focus-visible:ring-offset-2 focus-visible:ring-offset-zinc-950 focus-visible:outline-none"
                >
                  {collection.name}
                </a>
              </h3>
            </div>

            <p className="line-clamp-3 max-w-md text-sm leading-5 text-pretty text-white/85">
              {collection.description}
            </p>
          </div>

          <div className="mt-auto flex min-w-0 translate-y-0 items-center justify-between gap-4 border-t border-white/25 pt-4 opacity-100 transition-[opacity,translate] duration-500 ease-[cubic-bezier(0.22,1,0.36,1)] will-change-transform motion-reduce:transition-none md:translate-y-4 md:opacity-0 md:group-focus-within/card:translate-y-0 md:group-focus-within/card:opacity-100 md:group-hover/card:translate-y-0 md:group-hover/card:opacity-100">
            <span className="text-xs leading-5 font-medium text-white/80">
              Curated seasonal shopping
            </span>
            <Button
              nativeButton={false}
              variant="secondary"
              className="shrink-0"
              render={
                <a
                  href={collection.href}
                  aria-label={`Browse ${collection.name} collection`}
                />
              }
            >
              Shop Collection
              <ArrowIcon />
            </Button>
          </div>
        </div>
      </div>
    </article>
  )
}

export function CategoryCard() {
  return (
    <section
      aria-labelledby="seasonal-heading"
      className="mx-auto flex w-full max-w-5xl flex-col gap-7"
    >
      <div className="flex flex-col gap-4 border-b border-dashed pb-5">
        <Breadcrumb>
          <BreadcrumbList>
            <BreadcrumbItem>
              <BreadcrumbLink href="#" className={ECOMMERCE_LINK_CLASS_NAME}>
                Shop
              </BreadcrumbLink>
            </BreadcrumbItem>
            <BreadcrumbSeparator />
            <BreadcrumbItem>
              <BreadcrumbPage>Seasonal Categories</BreadcrumbPage>
            </BreadcrumbItem>
          </BreadcrumbList>
        </Breadcrumb>

        <div className="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
          <div className="flex min-w-0 flex-col gap-1.5">
            <h2
              id="seasonal-heading"
              className="text-2xl leading-tight font-semibold tracking-tight text-balance md:text-3xl"
            >
              Seasonal Category Cards
            </h2>
            <p className="text-muted-foreground max-w-2xl text-sm leading-6 text-pretty">
              Four focused shopping edits with image-first browsing and
              collection details revealed at the bottom of each card.
            </p>
          </div>

          <Button
            nativeButton={false}
            variant="outline"
            className="w-full sm:w-auto"
            render={<a href="#" aria-label="Browse all seasonal categories" />}
          >
            Browse All
            <ArrowIcon />
          </Button>
        </div>
      </div>

      <div className="grid gap-4 md:grid-cols-2">
        {seasonalCategories.map((collection, index) => (
          <CollectionCard
            key={collection.name}
            collection={collection}
            priority={index < 2}
          />
        ))}
      </div>
    </section>
  )
}