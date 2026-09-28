import { Checkout } from "./components/checkout"

export function Page() {
  return (
    <main className="min-h-svh w-full" aria-labelledby="page-heading">
      <h1 id="page-heading" className="sr-only">
        Ecommerce checkout
      </h1>
      <Checkout />
    </main>
  )
}