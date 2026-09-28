import { EmptyState } from "./components/empty-state"

export function Page() {
  return (
    <main
      className="flex min-h-svh w-full items-start justify-center p-4 sm:p-8 md:p-10"
      aria-labelledby="organizations-heading"
    >
      <EmptyState />
    </main>
  )
}