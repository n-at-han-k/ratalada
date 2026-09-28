import { Link } from "@inertiajs/react"
import {
  ArrowLeftIcon,
  Building2Icon,
  ClockIcon,
  LogOutIcon,
  MailIcon,
  ShoppingCartIcon,
} from "lucide-react"

import { Badge } from "@/components/reui/badge"
import { Button } from "@/components/ui/button"
import {
  Card,
  CardContent,
  CardDescription,
  CardFooter,
  CardHeader,
  CardTitle,
} from "@/components/ui/card"

// Portal chrome and the two gate states, shared by every page in the
// wholesale route group. A page lives in the __END__ block of its own .rb
// file and cannot import another one, so anything more than one page needs
// belongs in a module like this.

/** Portal chrome (navbar-12, trimmed): trade badge, nav, cart, sign out. */
export function WholesaleHeader({
  customerName,
  cartCount = 0,
  authenticated = true,
  signInHref = "/wholesale/sign-in",
}: {
  customerName?: string
  cartCount?: number
  authenticated?: boolean
  signInHref?: string
}) {
  return (
    <header className="border-b border-slate-700 bg-slate-900 text-slate-100">
      <div className="mx-auto flex flex-wrap items-center gap-4 px-4 py-3 sm:px-6 lg:px-8">
        <Link href="/wholesale" className="flex items-center gap-2 font-semibold">
          Wholesale
          <Badge variant="secondary" className="uppercase tracking-wide">
            Trade
          </Badge>
        </Link>

        <nav className="hidden items-center gap-4 text-sm md:flex">
          <Link href="/wholesale" className="hover:text-white">
            Catalog
          </Link>
          {/* Quick Order is an ordering surface, hidden from a browsing guest. */}
          {authenticated && (
            <Link href="/wholesale/quick-order" className="hover:text-white">
              Quick order
            </Link>
          )}
        </nav>

        <div className="ml-auto flex items-center gap-2 text-sm">
          {authenticated && customerName && (
            <span className="hidden text-slate-300 sm:inline">{customerName}</span>
          )}

          <Link
            href="/"
            className="inline-flex h-8 items-center gap-1.5 rounded-md px-3 hover:bg-slate-800 hover:text-white"
          >
            <ArrowLeftIcon className="size-4" />
            <span className="hidden sm:inline">Back to store</span>
          </Link>

          {authenticated ? (
            <>
              <Link
                href="/wholesale/cart"
                aria-label="Cart"
                className="relative inline-flex h-8 items-center rounded-md px-3 hover:bg-slate-800 hover:text-white"
              >
                <ShoppingCartIcon className="size-5" />
                {cartCount > 0 && (
                  <span className="absolute -right-1 -top-1 flex size-5 items-center justify-center rounded-full bg-white text-xs font-semibold text-slate-900">
                    {cartCount}
                  </span>
                )}
              </Link>

              {/* Fixture sign-out: index.rb's `delete "/"` just drops the
                  fixture session flag, no real Spree session to destroy. */}
              <Link
                href="/wholesale"
                method="delete"
                as="button"
                className="inline-flex h-8 items-center gap-1.5 rounded-md px-3 hover:bg-slate-800 hover:text-white"
              >
                <LogOutIcon className="size-4" />
                <span className="hidden sm:inline">Sign out</span>
              </Link>
            </>
          ) : (
            <Link
              href={signInHref}
              className="inline-flex h-8 items-center rounded-md bg-white px-3 font-medium text-slate-900 hover:bg-slate-100"
            >
              Sign in
            </Link>
          )}
        </div>
      </div>
    </header>
  )
}

/**
 * Landing shown to a guest on an ordering surface (cart, quick order) and to
 * anyone hitting the dedicated /wholesale/sign-in page. The actual sign-in
 * form lives at sign-in.rb; this just gets a guest there without a redirect,
 * so the page they wanted still answers 200.
 */
export function WholesaleSignInWall() {
  return (
    <div className="mx-auto grid max-w-5xl gap-8 px-4 py-16 sm:px-6 lg:grid-cols-2 lg:px-8">
      <div className="flex flex-col justify-center">
        <div className="mb-4 inline-flex w-fit items-center gap-2 rounded-full bg-slate-900 px-3 py-1 text-xs font-semibold uppercase tracking-wide text-slate-100">
          <Building2Icon className="size-3.5" />
          Trade
        </div>
        <h1 className="text-3xl font-bold text-slate-900">Sign in to the trade portal</h1>
        <p className="mt-4 text-slate-600">
          Trade pricing, case-pack ordering and quick order are reserved for approved
          wholesale accounts.
        </p>
        <p className="mt-8 text-sm text-slate-600">
          Don&apos;t have an account?{" "}
          <Link href="/wholesale/apply" className="font-medium text-slate-900 underline underline-offset-4">
            Apply for one
          </Link>
        </p>
      </div>
      <Card>
        <CardHeader>
          <CardTitle>Sign in</CardTitle>
          <CardDescription>Use your wholesale account credentials.</CardDescription>
        </CardHeader>
        <CardContent>
          <Button asChild size="lg" className="w-full bg-slate-900 hover:bg-slate-800">
            <Link href="/wholesale/sign-in">Go to sign in</Link>
          </Button>
        </CardContent>
      </Card>
    </div>
  )
}

/** Shown to a signed-in customer who isn't in the Wholesale group yet. */
export function WholesaleApplicationPending({
  customer,
}: {
  customer: { name: string; email: string }
}) {
  return (
    <div className="mx-auto max-w-xl px-4 py-16 sm:px-6 lg:px-8">
      <Card>
        <CardHeader className="text-center">
          <div className="mx-auto mb-2 flex size-12 items-center justify-center rounded-full bg-slate-100">
            <ClockIcon className="size-6 text-slate-700" />
          </div>
          <CardTitle>Application under review</CardTitle>
          <CardDescription>
            We&apos;ll email you as soon as your trade account is approved.
          </CardDescription>
        </CardHeader>
        <CardContent className="space-y-6">
          <dl className="space-y-2 rounded-lg border border-slate-200 bg-slate-50 p-4 text-sm">
            <div className="flex justify-between gap-4">
              <dt className="text-slate-500">Name</dt>
              <dd className="font-medium text-slate-900">{customer.name}</dd>
            </div>
            <div className="flex justify-between gap-4">
              <dt className="text-slate-500">Email</dt>
              <dd className="font-medium text-slate-900">{customer.email}</dd>
            </div>
          </dl>
          <p className="flex items-center gap-2 text-sm text-slate-600">
            <MailIcon className="size-4 text-slate-400" />
            Questions? wholesale@store.example
          </p>
        </CardContent>
        <CardFooter className="flex-col gap-2 sm:flex-row">
          <Button asChild variant="outline" className="flex-1">
            <Link href="/">Back to store</Link>
          </Button>
          <Button asChild variant="ghost" className="flex-1">
            <Link href="/wholesale" method="delete" as="button">
              Sign out
            </Link>
          </Button>
        </CardFooter>
      </Card>
    </div>
  )
}
