export const ECOMMERCE_LINK_CLASS_NAME =
  "underline-offset-4 transition-colors hover:text-primary hover:underline"

// ─────────────────────────────────────────────────────────────────────────
// Product
// ─────────────────────────────────────────────────────────────────────────

export const PRODUCT = {
  name: "Drift Pour-Over Kit",
  sku: "DRIFT-PO",
  brand: { label: "Atlas Goods", href: "/brand/atlas-goods" },
  href: "/p/drift-pour-over-kit",
  category: { label: "Coffee", href: "/shop/coffee" },
  price: 89,
  compareAtPrice: 112,
  discountLabel: "Save $23",
  rating: 4.7,
  reviewCount: 1842,
  stockLeft: 4,
  shippingFreeOver: 75,
  description:
    "Drift pairs a hand-thrown ceramic dripper with a double-wall borosilicate carafe so a pour-over brews evenly and stays hot through the second cup. The 60-degree cone shape and tapered ribs guide water to the bed corners for full extraction without bypass channels.",
  shortDescription:
    "A hand-thrown ceramic dripper and double-wall carafe tuned for even extraction.",
}

// ─────────────────────────────────────────────────────────────────────────
// Gallery
// ─────────────────────────────────────────────────────────────────────────

// Demo gallery uses curated Unsplash pour-over photography. Swap to your
// own product shots in production while keeping the square crop.
export const GALLERY: { src: string; alt: string }[] = [
  {
    src: "https://images.unsplash.com/photo-1495862433577-132cf20d7902?auto=format&fit=crop&w=900&h=900&q=80",
    alt: "Drift Pour-Over Kit, dripper on the carafe, three-quarter view",
  },
  {
    src: "https://images.unsplash.com/photo-1442512595331-e89e73853f31?auto=format&fit=crop&w=900&h=900&q=80",
    alt: "Drift Pour-Over Kit mid-brew with a slow kettle pour",
  },
  {
    src: "https://images.unsplash.com/photo-1522012188892-24beb302783d?auto=format&fit=crop&w=900&h=900&q=80",
    alt: "Drift Pour-Over Kit, ceramic cone interior with tapered ribs",
  },
  {
    src: "https://images.unsplash.com/photo-1522992319-0365e5f11656?auto=format&fit=crop&w=900&h=900&q=80",
    alt: "Drift Pour-Over Kit, double-wall borosilicate carafe close-up",
  },
  {
    src: "https://images.unsplash.com/photo-1522726336270-3a0053210f06?auto=format&fit=crop&w=900&h=900&q=80",
    alt: "Drift Pour-Over Kit on a wooden counter with mugs",
  },
]

// ─────────────────────────────────────────────────────────────────────────
// Variants - colors and sizes
// ─────────────────────────────────────────────────────────────────────────

export type ColorOption = {
  id: string
  name: string
  swatchClassName: string
}

export const COLORS: ColorOption[] = [
  { id: "cream", name: "Cream", swatchClassName: "bg-stone-100" },
  { id: "charcoal", name: "Charcoal", swatchClassName: "bg-neutral-800" },
  { id: "sage", name: "Sage", swatchClassName: "bg-emerald-700" },
  { id: "cobalt", name: "Cobalt", swatchClassName: "bg-blue-700" },
]

export type SizeOption = {
  id: string
  label: string
  caption: string
}

export const SIZES: SizeOption[] = [
  { id: "350ml", label: "350 ml", caption: "1 cup" },
  { id: "500ml", label: "500 ml", caption: "2 cups" },
  { id: "700ml", label: "700 ml", caption: "3 cups" },
]

// ─────────────────────────────────────────────────────────────────────────
// Highlights - quick value bullets above the variant pickers
// ─────────────────────────────────────────────────────────────────────────

export const HIGHLIGHTS: string[] = [
  "Hand-thrown ceramic with 60-degree cone for even extraction",
  "Double-wall borosilicate carafe keeps coffee hot through the second cup",
  "Dishwasher-safe carafe and lid, hand-wash dripper",
]

// ─────────────────────────────────────────────────────────────────────────
// Specs - compact key/value rows shown next to the description
// ─────────────────────────────────────────────────────────────────────────

export type SpecRow = { label: string; value: string }

export const SPECS: SpecRow[] = [
  { label: "Capacity", value: "350 ml · 500 ml · 700 ml" },
  { label: "Dripper", value: "Hand-thrown stoneware · 60-degree cone" },
  { label: "Carafe", value: "Double-wall borosilicate glass" },
  { label: "Includes", value: "Dripper · carafe · 50 paper filters" },
  { label: "Brew time", value: "3 to 4 minutes per cup" },
  { label: "Care", value: "Carafe dishwasher-safe, hand-wash dripper" },
]

// ─────────────────────────────────────────────────────────────────────────
// Reviews - compact summary + one featured quote
// ─────────────────────────────────────────────────────────────────────────

export type ReviewBreakdownRow = {
  stars: 5 | 4 | 3 | 2 | 1
  count: number
}

export const REVIEW_BREAKDOWN: ReviewBreakdownRow[] = [
  { stars: 5, count: 1390 },
  { stars: 4, count: 312 },
  { stars: 3, count: 87 },
  { stars: 2, count: 34 },
  { stars: 1, count: 19 },
]

export type FeaturedReview = {
  id: string
  author: string
  authorHref: string
  authorAvatar: string
  rating: number
  postedAt: string
  title: string
  body: string
  verified: boolean
}

export const FEATURED_REVIEWS: FeaturedReview[] = [
  {
    id: "noor",
    author: "Noor Haidari",
    authorHref: "/u/noor-haidari",
    authorAvatar:
      "https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=facearea&facepad=2&w=160&h=160&q=80",
    rating: 5,
    postedAt: "4 days ago",
    title: "Replaced my $200 setup and tastes better.",
    body: "The cone shape is the real story. Water hits the bed evenly, no channeling, no bypass. Carafe still warm after a 25-minute breakfast and the dripper rinses clean in seconds.",
    verified: true,
  },
  {
    id: "daniel",
    author: "Daniel Park",
    authorHref: "/u/daniel-park",
    authorAvatar:
      "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=facearea&facepad=2&w=160&h=160&q=80",
    rating: 5,
    postedAt: "1 week ago",
    title: "Even extraction across three different roasts.",
    body: "I tested a Yirgacheffe, a Brazil natural, and a Sumatra back to back. Each tasted clean and balanced. The 60-degree cone really does pull a uniform brew without bypass.",
    verified: true,
  },
  {
    id: "priya",
    author: "Priya Sharma",
    authorHref: "/u/priya-sharma",
    authorAvatar:
      "https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?auto=format&fit=facearea&facepad=2&w=160&h=160&q=80",
    rating: 4,
    postedAt: "2 weeks ago",
    title: "Carafe stays hot through the second cup.",
    body: "Double-wall glass keeps the brew warm long enough for a slow breakfast. Lid threads in cleanly and the dripper sits flush without sliding.",
    verified: true,
  },
  {
    id: "jules",
    author: "Jules Akinyemi",
    authorHref: "/u/jules-akinyemi",
    authorAvatar:
      "https://images.unsplash.com/photo-1531123897727-8f129e1688ce?auto=format&fit=facearea&facepad=2&w=160&h=160&q=80",
    rating: 5,
    postedAt: "3 weeks ago",
    title: "Worth replacing my old plastic dripper.",
    body: "The ceramic body holds heat much better than the plastic V60 I had before. Brews land sweeter and the rinse-out is much faster too.",
    verified: true,
  },
]

// ─────────────────────────────────────────────────────────────────────────
// Related products - compact 4-up grid below the hero
// ─────────────────────────────────────────────────────────────────────────

export type RelatedProduct = {
  id: string
  name: string
  href: string
  category: string
  image: string
  imageAlt: string
  price: number
}

export const RELATED_PRODUCTS: RelatedProduct[] = [
  {
    id: "drift-kettle",
    name: "Drift Gooseneck Kettle",
    href: "/p/drift-gooseneck-kettle",
    category: "Coffee",
    image:
      "https://images.unsplash.com/photo-1594213114663-d94db9b17125?auto=format&fit=crop&w=900&h=900&q=80",
    imageAlt:
      "Drift Gooseneck Kettle, 1L stainless steel with temperature dial",
    price: 119,
  },
  {
    id: "drift-grinder",
    name: "Drift Hand Grinder",
    href: "/p/drift-hand-grinder",
    category: "Coffee",
    image:
      "https://images.unsplash.com/photo-1537130508299-46ab547b4be3?auto=format&fit=crop&w=900&h=900&q=80",
    imageAlt: "Drift Hand Grinder with 38 mm conical burr",
    price: 79,
  },
  {
    id: "drift-filters",
    name: "Drift Paper Filters",
    href: "/p/drift-paper-filters",
    category: "Accessories",
    image:
      "https://images.unsplash.com/photo-1521677446241-d182a96ec49f?auto=format&fit=crop&w=900&h=900&q=80",
    imageAlt: "Drift Paper Filters, 100-pack of bleached cone filters",
    price: 12,
  },
  {
    id: "drift-scale",
    name: "Drift Brew Scale",
    href: "/p/drift-brew-scale",
    category: "Accessories",
    image:
      "https://images.unsplash.com/photo-1612012060851-20f943c02d3d?auto=format&fit=crop&w=900&h=900&q=80",
    imageAlt: "Drift Brew Scale, glass-top with built-in timer",
    price: 59,
  },
]