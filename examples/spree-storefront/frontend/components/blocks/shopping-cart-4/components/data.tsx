export const ECOMMERCE_LINK_CLASS_NAME =
  "underline-offset-4 transition-colors hover:text-primary hover:underline"

export type FulfillmentMode = "delivery" | "pickup"

export interface FulfillmentOption {
  mode: FulfillmentMode
  date: string
  price: number
}

export interface CartItem {
  id: string
  name: string
  color: string
  unitPrice: number
  quantity: number
  mode: FulfillmentMode
  delivery: FulfillmentOption
  pickup: FulfillmentOption
  image: {
    src: string
    alt: string
  }
}

export const PROMO_CODE = "HAPPY2026"
export const PROMO_RATE = 0.15

export const TAX_RATE = 0.07

export const CART_ITEMS: CartItem[] = [
  {
    id: "lumen-compact-camera",
    name: "Lumen Compact Camera",
    color: "Red",
    unitPrice: 99.89,
    quantity: 1,
    mode: "delivery",
    delivery: {
      mode: "delivery",
      date: "Feb 1",
      price: 15,
    },
    pickup: {
      mode: "pickup",
      date: "Today",
      price: 0,
    },
    image: {
      src: "https://images.unsplash.com/photo-1495121605193-b116b5b9c5fe?auto=format&fit=crop&w=400&h=400&q=80",
      alt: "Lumen Compact Camera in red on a soft studio surface",
    },
  },
  {
    id: "helix-pro-controller",
    name: "Helix Pro Controller",
    color: "Yellow",
    unitPrice: 49.99,
    quantity: 1,
    mode: "pickup",
    delivery: {
      mode: "delivery",
      date: "Feb 1",
      price: 0,
    },
    pickup: {
      mode: "pickup",
      date: "Today",
      price: 0,
    },
    image: {
      src: "https://images.unsplash.com/photo-1592840496694-26d035b52b48?auto=format&fit=crop&w=400&h=400&q=80",
      alt: "Helix Pro Controller in yellow on a studio backdrop",
    },
  },
  {
    id: "velar-wireless-headphones",
    name: "Velar Wireless Headphones",
    color: "Dark Blue",
    unitPrice: 71.69,
    quantity: 1,
    mode: "delivery",
    delivery: {
      mode: "delivery",
      date: "Feb 1",
      price: 0,
    },
    pickup: {
      mode: "pickup",
      date: "Today",
      price: 0,
    },
    image: {
      src: "https://images.unsplash.com/photo-1583394838336-acd977736f90?auto=format&fit=crop&w=400&h=400&q=80",
      alt: "Velar Wireless Headphones in dark blue on a studio backdrop",
    },
  },
]