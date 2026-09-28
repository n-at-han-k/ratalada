import { MiniCartSheet } from "./components/mini-cart-sheet"

export function Page() {
  return (
    <main
      className="flex min-h-svh w-full items-center justify-center p-6 sm:p-10"
      aria-labelledby="page-heading"
    >
      <h1 id="page-heading" className="sr-only">
        Mini cart sheet
      </h1>
      <MiniCartSheet />
    </main>
  )
}