# frozen_string_literal: true

# The prefix this file is evaluated under is the catch-all its name spells, so
# it is the last route the router tries.
get "/" do
  status(404)
  inertia("+not-found")
end

__END__

import { Head, Link } from "@inertiajs/react"

export default function NotFound() {
  return (
    <main className="flex min-h-svh flex-col items-center justify-center gap-6 p-6">
      <Head title="Not found" />
      <h1 className="text-2xl font-semibold">Not found</h1>
      <Link href="/" className="underline">
        Back to the list
      </Link>
    </main>
  )
}
