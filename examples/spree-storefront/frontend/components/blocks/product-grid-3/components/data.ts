export const ECOMMERCE_LINK_CLASS_NAME =
  "underline-offset-4 transition-colors hover:text-primary hover:underline"

// ─────────────────────────────────────────────────────────────────────────
// Types. Each product carries 1 or 2 categories (rendered as eyebrow
// links with a ReUI dot separator between them when both are present),
// plus an optional badge that uses a semantic ReUI Badge variant so the
// signal (sale, fresh, bestseller, trending) is conveyed by color, not
// by copy alone.
// ─────────────────────────────────────────────────────────────────────────

export type ProductCategory = {
  label: string
  href: string
}

export type ProductBadge = {
  label: string
  variant: "destructive" | "default" | "success" | "warning"
}

export type Product = {
  id: string
  name: string
  href: string
  categories: ProductCategory[]
  rating: number
  reviewCount: number
  price: string
  compareAtPrice?: string
  badge?: ProductBadge
  image: { src: string; alt: string }
}

// ─────────────────────────────────────────────────────────────────────────
// Demo data. Six curated travel bags. Categories per product range
// from one to two so the eyebrow shape varies across the grid. Four of
// the six carry a badge, each mapped to a different semantic variant:
// destructive for sale urgency, default for freshness, success for
// bestseller social proof, warning for trending heat.
// ─────────────────────────────────────────────────────────────────────────

export const PRODUCTS: Product[] = [
  {
    id: "wayfarer-daypack",
    name: "Wayfarer Daypack",
    href: "#",
    categories: [
      { label: "Daypacks", href: "#" },
      { label: "Everyday", href: "#" },
    ],
    rating: 4.8,
    reviewCount: 412,
    price: "$148",
    compareAtPrice: "$185",
    badge: { label: "20% Off", variant: "destructive" },
    image: {
      src: "https://images.unsplash.com/photo-1553062407-98eeb64c6a62?auto=format&fit=crop&w=900&h=900&q=80",
      alt: "Wayfarer Daypack, three-quarter studio shot",
    },
  },
  {
    id: "sundown-weekender",
    name: "Sundown Weekender",
    href: "#",
    categories: [{ label: "Weekenders", href: "#" }],
    rating: 4.7,
    reviewCount: 218,
    price: "$224",
    badge: { label: "New", variant: "default" },
    image: {
      src: "https://images.unsplash.com/photo-1547949003-9792a18a2601?auto=format&fit=crop&w=900&h=900&q=80",
      alt: "Sundown Weekender duffel on a marble surface",
    },
  },
  {
    id: "saddle-tote",
    name: "Saddle Tote",
    href: "#",
    categories: [
      { label: "Totes", href: "#" },
      { label: "Canvas", href: "#" },
    ],
    rating: 4.9,
    reviewCount: 564,
    price: "$98",
    compareAtPrice: "$128",
    badge: { label: "Bestseller", variant: "success" },
    image: {
      src: "https://images.unsplash.com/photo-1597633425046-08f5110420b5?auto=format&fit=crop&w=900&h=900&q=80",
      alt: "Saddle Tote in stone canvas, packed for the day",
    },
  },
  {
    id: "outpost-45l-pack",
    name: "Outpost 45L Pack",
    href: "#",
    categories: [{ label: "Travel Packs", href: "#" }],
    rating: 4.9,
    reviewCount: 1124,
    price: "$268",
    image: {
      src: "https://images.unsplash.com/photo-1581605405669-fcdf81165afa?auto=format&fit=crop&w=900&h=900&q=80",
      alt: "Outpost 45L Pack, hero studio shot",
    },
  },
  {
    id: "compass-sling",
    name: "Compass Sling 6L",
    href: "#",
    categories: [{ label: "Slings", href: "#" }],
    rating: 4.6,
    reviewCount: 89,
    price: "$58",
    image: {
      src: "https://images.unsplash.com/photo-1622560480605-d83c853bc5c3?auto=format&fit=crop&w=900&h=900&q=80",
      alt: "Compass Sling 6L on a wooden bench",
    },
  },
  {
    id: "field-crossbody",
    name: "Field Crossbody",
    href: "#",
    categories: [
      { label: "Crossbody", href: "#" },
      { label: "Field", href: "#" },
    ],
    rating: 4.8,
    reviewCount: 312,
    price: "$128",
    badge: { label: "Hot", variant: "warning" },
    image: {
      src: "https://images.unsplash.com/photo-1591769225440-811ad7d6eab3?auto=format&fit=crop&w=900&h=900&q=80",
      alt: "Field Crossbody styled on a stone bench",
    },
  },
]

// Initial state. Pre-like one product to demonstrate the wishlist state
// without forcing the user to click before seeing it.
export const DEFAULT_LIKED_PRODUCT_IDS: readonly string[] = ["saddle-tote"]