import { useMemo, useState } from "react"
import { Rating } from "@/components/reui/rating"
import { cn } from "cn"

import {
  Accordion,
  AccordionContent,
  AccordionItem,
  AccordionTrigger,
} from "@/components/ui/accordion"
import { Button } from "@/components/ui/button"
import { Card } from "@/components/ui/card"
import { Checkbox } from "@/components/ui/checkbox"
import { Label } from "@/components/ui/label"
import {
  RadioGroup,
  RadioGroupItem,
} from "@/components/ui/radio-group"
import { Separator } from "@/components/ui/separator"
import { Slider } from "@/components/ui/slider"
import { Switch } from "@/components/ui/switch"
import { XIcon, CheckIcon } from "lucide-react"

type FacetOption = {
  id: string
  label: string
  count: number
}

const DEPARTMENTS = [
  { id: "all", label: "All" },
  { id: "women", label: "Women" },
  { id: "men", label: "Men" },
  { id: "kids", label: "Kids" },
] as const

type DepartmentId = (typeof DEPARTMENTS)[number]["id"]

const CATEGORIES: FacetOption[] = [
  { id: "outerwear", label: "Outerwear", count: 128 },
  { id: "knitwear", label: "Knitwear", count: 84 },
  { id: "tops", label: "Tops", count: 156 },
  { id: "bottoms", label: "Bottoms", count: 92 },
  { id: "dresses", label: "Dresses", count: 74 },
  { id: "footwear", label: "Footwear", count: 67 },
]

const MATERIALS: FacetOption[] = [
  { id: "cotton", label: "Cotton", count: 184 },
  { id: "linen", label: "Linen", count: 56 },
  { id: "wool", label: "Wool", count: 48 },
  { id: "cashmere", label: "Cashmere", count: 22 },
  { id: "leather", label: "Leather", count: 31 },
  { id: "recycled", label: "Recycled fibers", count: 64 },
]

const BRANDS: FacetOption[] = [
  { id: "northline", label: "Northline", count: 38 },
  { id: "aster", label: "Aster Goods", count: 24 },
  { id: "field", label: "Field Supply", count: 19 },
  { id: "maven", label: "Maven & Co.", count: 31 },
]

const COLORS: { id: string; label: string; swatch: string }[] = [
  { id: "black", label: "Black", swatch: "oklch(0.205 0 0)" },
  { id: "ivory", label: "Ivory", swatch: "oklch(0.96 0.012 90)" },
  { id: "beige", label: "Beige", swatch: "oklch(0.83 0.04 80)" },
  { id: "olive", label: "Olive", swatch: "oklch(0.55 0.07 120)" },
  { id: "navy", label: "Navy", swatch: "oklch(0.32 0.06 250)" },
  { id: "rust", label: "Rust", swatch: "oklch(0.55 0.13 40)" },
]

const SIZES = ["XS", "S", "M", "L", "XL", "XXL"] as const

const RATINGS = [
  { id: "4", label: "4 & up", stars: 4 },
  { id: "3", label: "3 & up", stars: 3 },
  { id: "2", label: "2 & up", stars: 2 },
] as const

type RatingId = (typeof RATINGS)[number]["id"] | "any"

const PRICE_MIN = 0
const PRICE_MAX = 240

type Chip = {
  key: string
  label: string
  swatch?: string
  remove: () => void
}

function toggle<T>(arr: T[], value: T): T[] {
  return arr.includes(value) ? arr.filter((v) => v !== value) : [...arr, value]
}

function findLabel(options: FacetOption[], id: string) {
  return options.find((o) => o.id === id)?.label ?? id
}

function findDeptLabel(id: DepartmentId) {
  return DEPARTMENTS.find((d) => d.id === id)?.label ?? id
}

function SectionCount({ count }: { count: number }) {
  if (count === 0) return null
  return (
    <span className="bg-foreground text-background ml-1.5 inline-flex h-4 min-w-4 items-center justify-center rounded-full px-1 text-[0.625rem] font-semibold tabular-nums">
      {count}
    </span>
  )
}

export function FilterSidebar() {
  const [department, setDepartment] = useState<DepartmentId>("women")
  const [categories, setCategories] = useState<string[]>(["outerwear"])
  const [materials, setMaterials] = useState<string[]>(["cotton"])
  const [brands, setBrands] = useState<string[]>(["northline"])
  const [colors, setColors] = useState<string[]>(["black"])
  const [sizes, setSizes] = useState<string[]>([])
  const [priceRange, setPriceRange] = useState<[number, number]>([40, 180])
  const [rating, setRating] = useState<RatingId>("4")
  const [inStockOnly, setInStockOnly] = useState(true)
  const [onSaleOnly, setOnSaleOnly] = useState(false)

  const priceChanged =
    priceRange[0] !== PRICE_MIN || priceRange[1] !== PRICE_MAX
  const quickFiltersCount = (inStockOnly ? 1 : 0) + (onSaleOnly ? 1 : 0)

  const chips: Chip[] = useMemo(() => {
    const items: Chip[] = []
    if (department !== "all") {
      items.push({
        key: "dept",
        label: findDeptLabel(department),
        remove: () => setDepartment("all"),
      })
    }
    categories.forEach((id) =>
      items.push({
        key: `cat:${id}`,
        label: findLabel(CATEGORIES, id),
        remove: () => setCategories((c) => c.filter((x) => x !== id)),
      })
    )
    materials.forEach((id) =>
      items.push({
        key: `mat:${id}`,
        label: findLabel(MATERIALS, id),
        remove: () => setMaterials((m) => m.filter((x) => x !== id)),
      })
    )
    colors.forEach((id) => {
      const color = COLORS.find((c) => c.id === id)
      items.push({
        key: `color:${id}`,
        label: color?.label ?? id,
        swatch: color?.swatch,
        remove: () => setColors((c) => c.filter((x) => x !== id)),
      })
    })
    sizes.forEach((s) =>
      items.push({
        key: `size:${s}`,
        label: `Size ${s}`,
        remove: () => setSizes((arr) => arr.filter((x) => x !== s)),
      })
    )
    brands.forEach((id) =>
      items.push({
        key: `brand:${id}`,
        label: findLabel(BRANDS, id),
        remove: () => setBrands((b) => b.filter((x) => x !== id)),
      })
    )
    if (rating !== "any") {
      items.push({
        key: "rating",
        label: `${rating}★ & up`,
        remove: () => setRating("any"),
      })
    }
    if (priceChanged) {
      items.push({
        key: "price",
        label: `$${priceRange[0]} − $${priceRange[1]}`,
        remove: () => setPriceRange([PRICE_MIN, PRICE_MAX]),
      })
    }
    if (inStockOnly) {
      items.push({
        key: "in-stock",
        label: "In stock",
        remove: () => setInStockOnly(false),
      })
    }
    if (onSaleOnly) {
      items.push({
        key: "sale",
        label: "On sale",
        remove: () => setOnSaleOnly(false),
      })
    }
    return items
  }, [
    department,
    categories,
    materials,
    brands,
    colors,
    sizes,
    priceRange,
    priceChanged,
    rating,
    inStockOnly,
    onSaleOnly,
  ])

  const activeCount = chips.length

  function handleClearAll() {
    setDepartment("all")
    setCategories([])
    setMaterials([])
    setBrands([])
    setColors([])
    setSizes([])
    setPriceRange([PRICE_MIN, PRICE_MAX])
    setRating("any")
    setInStockOnly(false)
    setOnSaleOnly(false)
  }

  return (
    <aside aria-label="Product filters" className="w-full max-w-xs">
      <Card className="gap-0 overflow-hidden p-0">
        {/* Header */}
        <div className="flex items-center justify-between gap-3 px-5 py-4">
          <h2 className="text-foreground text-sm font-semibold tracking-tight">
            Filters
          </h2>
          {activeCount > 0 ? (
            <Button
              type="button"
              variant="ghost"
              size="sm"
              onClick={handleClearAll}
              className="text-muted-foreground hover:text-foreground"
            >
              Clear all
            </Button>
          ) : null}
        </div>

        <Separator />

        {/* Active filter chips */}
        {chips.length > 0 ? (
          <>
            <div
              className="flex flex-wrap gap-1.5 px-5 py-4"
              aria-label="Active filters"
            >
              {chips.map((chip) => (
                <button
                  key={chip.key}
                  type="button"
                  onClick={chip.remove}
                  aria-label={`Remove filter ${chip.label}`}
                  className="border-border bg-muted/40 text-foreground hover:bg-muted inline-flex items-center gap-1.5 rounded-full border px-2 py-0.5 text-xs font-medium transition-colors"
                >
                  {chip.swatch ? (
                    <span
                      aria-hidden="true"
                      className="border-border/60 inline-block size-2.5 shrink-0 rounded-full border"
                      style={{ backgroundColor: chip.swatch }}
                    />
                  ) : null}
                  {chip.label}
                  <XIcon className="text-muted-foreground size-3" aria-hidden="true" />
                </button>
              ))}
            </div>
            <Separator />
          </>
        ) : null}

        {/* Collapsible filter sections */}
        <Accordion
          multiple
          defaultValue={["category", "price"]}
          className="gap-0"
        >
          {/* Department */}
          <AccordionItem
            value="department"
            className="border-border/70 border-b border-dashed last:border-b-0"
          >
            <AccordionTrigger className="items-center px-5 py-3.5 text-sm font-semibold tracking-tight hover:no-underline">
              <span className="inline-flex items-center">
                Department
                <SectionCount count={department !== "all" ? 1 : 0} />
              </span>
            </AccordionTrigger>
            <AccordionContent className="px-5 pb-4">
              <div
                role="group"
                aria-label="Department"
                className="-mx-0.5 flex flex-wrap gap-1.5 px-0.5"
              >
                {DEPARTMENTS.map((dept) => {
                  const isActive = department === dept.id
                  return (
                    <button
                      key={dept.id}
                      type="button"
                      onClick={() => setDepartment(dept.id)}
                      aria-pressed={isActive}
                      className={cn(
                        "rounded-full px-3 py-1 text-xs font-medium transition-colors",
                        isActive
                          ? "bg-foreground text-background"
                          : "border-border bg-background text-muted-foreground hover:text-foreground border"
                      )}
                    >
                      {dept.label}
                    </button>
                  )
                })}
              </div>
            </AccordionContent>
          </AccordionItem>

          {/* Category */}
          <AccordionItem
            value="category"
            className="border-border/70 border-b border-dashed last:border-b-0"
          >
            <AccordionTrigger className="items-center px-5 py-3.5 text-sm font-semibold tracking-tight hover:no-underline">
              <span className="inline-flex items-center">
                Category
                <SectionCount count={categories.length} />
              </span>
            </AccordionTrigger>
            <AccordionContent className="px-5 pb-4">
              <ul className="flex flex-col gap-2.5">
                {CATEGORIES.map((option) => {
                  const id = `filter-6-category-${option.id}`
                  const checked = categories.includes(option.id)
                  return (
                    <li key={option.id} className="flex items-center gap-2.5">
                      <Checkbox
                        id={id}
                        checked={checked}
                        onCheckedChange={() =>
                          setCategories((c) => toggle(c, option.id))
                        }
                      />
                      <Label
                        htmlFor={id}
                        className="text-foreground flex min-w-0 flex-1 justify-between gap-3 text-sm font-normal"
                      >
                        <span className="truncate">{option.label}</span>
                        <span className="text-muted-foreground tabular-nums">
                          {option.count}
                        </span>
                      </Label>
                    </li>
                  )
                })}
              </ul>
            </AccordionContent>
          </AccordionItem>

          {/* Price */}
          <AccordionItem
            value="price"
            className="border-border/70 border-b border-dashed last:border-b-0"
          >
            <AccordionTrigger className="items-center px-5 py-3.5 text-sm font-semibold tracking-tight hover:no-underline">
              <span className="inline-flex items-center">
                Price
                <SectionCount count={priceChanged ? 1 : 0} />
              </span>
            </AccordionTrigger>
            <AccordionContent className="flex flex-col gap-3 px-5 pb-4">
              <div className="flex items-baseline justify-between gap-3 text-xs font-medium tabular-nums">
                <span className="text-foreground font-semibold">
                  ${priceRange[0]}
                </span>
                <span className="text-foreground font-semibold">
                  ${priceRange[1]}
                </span>
              </div>
              <Slider
                value={priceRange}
                onValueChange={(value) =>
                  setPriceRange(value as [number, number])
                }
                min={PRICE_MIN}
                max={PRICE_MAX}
                step={5}
                aria-label="Price range"
              />
            </AccordionContent>
          </AccordionItem>

          {/* Color */}
          <AccordionItem
            value="color"
            className="border-border/70 border-b border-dashed last:border-b-0"
          >
            <AccordionTrigger className="items-center px-5 py-3.5 text-sm font-semibold tracking-tight hover:no-underline">
              <span className="inline-flex items-center">
                Color
                <SectionCount count={colors.length} />
              </span>
            </AccordionTrigger>
            <AccordionContent className="overflow-visible px-5 pt-1 pb-4">
              <ul className="flex flex-wrap gap-3" aria-label="Color swatches">
                {COLORS.map((color) => {
                  const isSelected = colors.includes(color.id)
                  const isLightSwatch =
                    color.id === "ivory" || color.id === "beige"
                  return (
                    <li key={color.id}>
                      <button
                        type="button"
                        onClick={() => setColors((c) => toggle(c, color.id))}
                        aria-pressed={isSelected}
                        aria-label={color.label}
                        title={color.label}
                        className={cn(
                          "border-border relative flex size-7 items-center justify-center rounded-full border transition-shadow outline-none",
                          "focus-visible:ring-ring/40 focus-visible:ring-2 focus-visible:ring-offset-2",
                          isSelected && "ring-foreground ring-2 ring-offset-2"
                        )}
                        style={{ backgroundColor: color.swatch }}
                      >
                        {isSelected ? (
                          <CheckIcon className={cn(
                                                                "size-3",
                                                                isLightSwatch
                                                                  ? "text-foreground"
                                                                  : "text-background"
                                                              )} aria-hidden="true" />
                        ) : null}
                      </button>
                    </li>
                  )
                })}
              </ul>
            </AccordionContent>
          </AccordionItem>

          {/* Size */}
          <AccordionItem
            value="size"
            className="border-border/70 border-b border-dashed last:border-b-0"
          >
            <AccordionTrigger className="items-center px-5 py-3.5 text-sm font-semibold tracking-tight hover:no-underline">
              <span className="inline-flex items-center">
                Size
                <SectionCount count={sizes.length} />
              </span>
            </AccordionTrigger>
            <AccordionContent className="px-5 pb-4">
              <div className="flex flex-wrap gap-1.5" aria-label="Sizes">
                {SIZES.map((size) => {
                  const isSelected = sizes.includes(size)
                  return (
                    <Button
                      key={size}
                      type="button"
                      variant={isSelected ? "default" : "outline"}
                      size="sm"
                      onClick={() => setSizes((s) => toggle(s, size))}
                      aria-pressed={isSelected}
                      className="min-w-12 tabular-nums"
                    >
                      {size}
                    </Button>
                  )
                })}
              </div>
            </AccordionContent>
          </AccordionItem>

          {/* Material */}
          <AccordionItem
            value="material"
            className="border-border/70 border-b border-dashed last:border-b-0"
          >
            <AccordionTrigger className="items-center px-5 py-3.5 text-sm font-semibold tracking-tight hover:no-underline">
              <span className="inline-flex items-center">
                Material
                <SectionCount count={materials.length} />
              </span>
            </AccordionTrigger>
            <AccordionContent className="px-5 pb-4">
              <ul className="flex flex-col gap-2.5">
                {MATERIALS.map((option) => {
                  const id = `filter-6-material-${option.id}`
                  const checked = materials.includes(option.id)
                  return (
                    <li key={option.id} className="flex items-center gap-2.5">
                      <Checkbox
                        id={id}
                        checked={checked}
                        onCheckedChange={() =>
                          setMaterials((m) => toggle(m, option.id))
                        }
                      />
                      <Label
                        htmlFor={id}
                        className="text-foreground flex min-w-0 flex-1 justify-between gap-3 text-sm font-normal"
                      >
                        <span className="truncate">{option.label}</span>
                        <span className="text-muted-foreground tabular-nums">
                          {option.count}
                        </span>
                      </Label>
                    </li>
                  )
                })}
              </ul>
            </AccordionContent>
          </AccordionItem>

          {/* Brand */}
          <AccordionItem
            value="brand"
            className="border-border/70 border-b border-dashed last:border-b-0"
          >
            <AccordionTrigger className="items-center px-5 py-3.5 text-sm font-semibold tracking-tight hover:no-underline">
              <span className="inline-flex items-center">
                Brand
                <SectionCount count={brands.length} />
              </span>
            </AccordionTrigger>
            <AccordionContent className="px-5 pb-4">
              <ul className="flex flex-col gap-2.5">
                {BRANDS.map((option) => {
                  const id = `filter-6-brand-${option.id}`
                  const checked = brands.includes(option.id)
                  return (
                    <li key={option.id} className="flex items-center gap-2.5">
                      <Checkbox
                        id={id}
                        checked={checked}
                        onCheckedChange={() =>
                          setBrands((b) => toggle(b, option.id))
                        }
                      />
                      <Label
                        htmlFor={id}
                        className="text-foreground flex min-w-0 flex-1 justify-between gap-3 text-sm font-normal"
                      >
                        <span className="truncate">{option.label}</span>
                        <span className="text-muted-foreground tabular-nums">
                          {option.count}
                        </span>
                      </Label>
                    </li>
                  )
                })}
              </ul>
            </AccordionContent>
          </AccordionItem>

          {/* Rating */}
          <AccordionItem
            value="rating"
            className="border-border/70 border-b border-dashed last:border-b-0"
          >
            <AccordionTrigger className="items-center px-5 py-3.5 text-sm font-semibold tracking-tight hover:no-underline">
              <span className="inline-flex items-center">
                Rating
                <SectionCount count={rating !== "any" ? 1 : 0} />
              </span>
            </AccordionTrigger>
            <AccordionContent className="px-5 pb-4">
              <RadioGroup
                value={rating}
                onValueChange={(value) => setRating(value as RatingId)}
                className="flex flex-col gap-2"
              >
                {RATINGS.map((option) => {
                  const id = `filter-6-rating-${option.id}`
                  return (
                    <div key={option.id} className="flex items-center gap-2.5">
                      <RadioGroupItem id={id} value={option.id} />
                      <Label
                        htmlFor={id}
                        className="text-foreground flex min-w-0 flex-1 items-center gap-2 text-sm font-normal"
                      >
                        <Rating
                          rating={option.stars}
                          size="sm"
                          aria-hidden="true"
                          className="gap-0.5"
                        />
                        <span className="text-muted-foreground text-xs">
                          {option.label}
                        </span>
                      </Label>
                    </div>
                  )
                })}
              </RadioGroup>
            </AccordionContent>
          </AccordionItem>

          {/* Quick filters */}
          <AccordionItem
            value="quick"
            className="border-border/70 border-b border-dashed last:border-b-0"
          >
            <AccordionTrigger className="items-center px-5 py-3.5 text-sm font-semibold tracking-tight hover:no-underline">
              <span className="inline-flex items-center">
                Quick filters
                <SectionCount count={quickFiltersCount} />
              </span>
            </AccordionTrigger>
            <AccordionContent className="flex flex-col gap-3 px-5 pb-4">
              <div className="flex items-center justify-between gap-3">
                <Label
                  htmlFor="filter-6-in-stock"
                  className="text-foreground text-sm font-normal"
                >
                  In stock only
                </Label>
                <Switch
                  id="filter-6-in-stock"
                  checked={inStockOnly}
                  onCheckedChange={setInStockOnly}
                  size="sm"
                />
              </div>
              <div className="flex items-center justify-between gap-3">
                <Label
                  htmlFor="filter-6-on-sale"
                  className="text-foreground text-sm font-normal"
                >
                  On sale
                </Label>
                <Switch
                  id="filter-6-on-sale"
                  checked={onSaleOnly}
                  onCheckedChange={setOnSaleOnly}
                  size="sm"
                />
              </div>
            </AccordionContent>
          </AccordionItem>
        </Accordion>

        <Separator />

        {/* Footer */}
        <div className="flex items-center gap-2 px-5 py-4">
          <Button type="button" size="sm" className="flex-1">
            Apply filters
          </Button>
          <Button
            type="button"
            variant="ghost"
            size="sm"
            onClick={handleClearAll}
            disabled={activeCount === 0}
            className="text-muted-foreground hover:text-foreground"
          >
            Reset
          </Button>
        </div>
      </Card>
    </aside>
  )
}