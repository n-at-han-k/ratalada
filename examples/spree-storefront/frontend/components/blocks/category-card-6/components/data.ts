export const ECOMMERCE_LINK_CLASS_NAME =
  "underline-offset-4 transition-colors hover:text-primary hover:underline"

export type SeasonalCategory = {
  name: string
  description: string
  href: string
  image: string
  imageAlt: string
  itemCount: string
  badge?: {
    label: string
  }
}

export const seasonalCategories: SeasonalCategory[] = [
  {
    name: "Warm Lighting",
    description:
      "Low-glare lamps, shaded pendants, warmer bulbs, and dimmable accents for softer evening rooms.",
    href: "#",
    image:
      "https://images.unsplash.com/photo-1540932239986-30128078f3c5?auto=format&fit=crop&w=1200&h=900&q=90",
    imageAlt: "Warm pendant lights in a composed interior",
    itemCount: "58 items",
    badge: { label: "Seasonal" },
  },
  {
    name: "Layered Textiles",
    description:
      "Throws, cushions, rugs, cotton bedding, and tactile layers that make seating and bedrooms feel finished.",
    href: "#",
    image:
      "https://images.unsplash.com/photo-1524758631624-e2822e304c36?auto=format&fit=crop&w=1200&h=900&q=90",
    imageAlt: "Living room with soft textiles, seating, and wall art",
    itemCount: "86 items",
  },
  {
    name: "Hosting Table",
    description:
      "Serveware, trays, glasses, napkins, candles, and dining accents for casual dinners and planned gatherings.",
    href: "#",
    image:
      "https://images.unsplash.com/photo-1513519245088-0e12902e5a38?auto=format&fit=crop&w=1200&h=900&q=90",
    imageAlt: "Curated home decor objects and table accessories in warm light",
    itemCount: "73 items",
    badge: { label: "Restocked" },
  },
  {
    name: "Entryway Reset",
    description:
      "Benches, hooks, trays, mirrors, baskets, and catchall storage for cleaner arrivals and faster exits.",
    href: "#",
    image:
      "https://images.unsplash.com/photo-1595428774223-ef52624120d2?auto=format&fit=crop&w=1200&h=900&q=90",
    imageAlt: "Entry storage and shelving with baskets and home accessories",
    itemCount: "49 items",
  },
]