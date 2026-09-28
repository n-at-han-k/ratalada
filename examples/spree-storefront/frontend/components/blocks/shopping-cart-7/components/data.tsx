export const ECOMMERCE_LINK_CLASS_NAME =
  "underline-offset-4 transition-colors hover:text-primary hover:underline"

export interface CartLine {
  id: string
  name: string
  category: string
  variant: string
  unitPrice: number
  quantity: number
  image: {
    src: string
    alt: string
  }
}

export const FREE_SHIPPING_THRESHOLD = 600

export const JUST_ADDED_TIMESTAMP = "12 seconds ago"

export const CART_LINES: CartLine[] = [
  {
    id: "linen-fold-tote",
    name: "Linen Fold Carryall Tote",
    category: "Bags",
    variant: "Sand",
    unitPrice: 98,
    quantity: 1,
    image: {
      src: "https://images.unsplash.com/photo-1591561954557-26941169b49e?auto=format&fit=crop&w=200&h=200&q=80",
      alt: "Linen Fold Carryall Tote in Sand",
    },
  },
  {
    id: "studio-cotton-tee",
    name: "Studio Cotton Pocket Tee",
    category: "Tops",
    variant: "Ivory",
    unitPrice: 42,
    quantity: 2,
    image: {
      src: "https://images.unsplash.com/photo-1581655353564-df123a1eb820?auto=format&fit=crop&w=200&h=200&q=80",
      alt: "Studio Cotton Pocket Tee in Ivory",
    },
  },
  {
    id: "atelier-linen-pants",
    name: "Atelier Wide-Leg Linen Pants",
    category: "Bottoms",
    variant: "Stone",
    unitPrice: 148,
    quantity: 1,
    image: {
      src: "https://images.unsplash.com/photo-1594633312681-425c7b97ccd1?auto=format&fit=crop&w=200&h=200&q=80",
      alt: "Atelier Wide-Leg Linen Pants in Stone",
    },
  },
  {
    id: "heritage-suede-loafers",
    name: "Heritage Suede Loafers",
    category: "Footwear",
    variant: "Tan",
    unitPrice: 185,
    quantity: 1,
    image: {
      src: "https://images.unsplash.com/photo-1543163521-1bf539c55dd2?auto=format&fit=crop&w=200&h=200&q=80",
      alt: "Heritage Suede Loafers in Tan",
    },
  },
  {
    id: "maris-wool-scarf",
    name: "Maris Felted Wool Scarf",
    category: "Accessories",
    variant: "Camel",
    unitPrice: 58,
    quantity: 1,
    image: {
      src: "https://images.unsplash.com/photo-1601762603339-fd61e28b698a?auto=format&fit=crop&w=200&h=200&q=80",
      alt: "Maris Felted Wool Scarf in Camel",
    },
  },
]