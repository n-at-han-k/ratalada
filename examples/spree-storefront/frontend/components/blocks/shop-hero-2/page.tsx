import { Hero } from "./components/hero"

export function Page() {
  return (
    <main className="min-h-svh w-full" aria-labelledby="page-heading">
      <h1 id="page-heading" className="sr-only">
        Ecommerce shop hero
      </h1>
      <Hero />
    </main>
  )
}