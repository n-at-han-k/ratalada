import { useEffect, useState } from "react"

// The cart is read and written from separate route files — the drawer in
// [country]/[locale]/_layout.rb, the count badge in (storefront)/_layout.rb,
// the cart page — and a page's __END__ block can't import another one, so the
// store lives here, in the one module graph they all share.
export type CartLine = {
  id: string
  name: string
  variant: string
  unitPrice: number
  quantity: number
  image: { src: string; alt: string }
}

// ponytail: fixture cart, swap for the Spree Store API cart when it is wired
const INITIAL_LINES: CartLine[] = [
  {
    id: "canvas-weekender",
    name: "Canvas Weekender",
    variant: "Sand",
    unitPrice: 128,
    quantity: 1,
    image: { src: "https://picsum.photos/seed/weekender/200/200", alt: "Canvas Weekender" },
  },
]

const state = { lines: INITIAL_LINES, isOpen: false }
const listeners = new Set<() => void>()

const notify = () => listeners.forEach((listener) => listener())

export function useCart() {
  const [, rerender] = useState(0)

  useEffect(() => {
    const listener = () => rerender((n) => n + 1)
    listeners.add(listener)
    return () => void listeners.delete(listener)
  }, [])

  return {
    lines: state.lines,
    isOpen: state.isOpen,
    count: state.lines.reduce((sum, line) => sum + line.quantity, 0),
    open: () => {
      state.isOpen = true
      notify()
    },
    close: () => {
      state.isOpen = false
      notify()
    },
    add: (line: CartLine) => {
      const existing = state.lines.find((l) => l.id === line.id)
      state.lines = existing
        ? state.lines.map((l) =>
            l.id === line.id ? { ...l, quantity: l.quantity + line.quantity } : l,
          )
        : [...state.lines, line]
      notify()
    },
    setQuantity: (id: string, quantity: number) => {
      state.lines =
        quantity <= 0
          ? state.lines.filter((line) => line.id !== id)
          : state.lines.map((line) => (line.id === id ? { ...line, quantity } : line))
      notify()
    },
  }
}
