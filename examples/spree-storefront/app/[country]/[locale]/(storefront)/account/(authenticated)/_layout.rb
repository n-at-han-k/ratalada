# frozen_string_literal: true

# reui: profile-1
#
# <Profile>                                   # blocks/profile-1/profile — sidebar-tab shell
#   <aside>
#     <p>                                     # name
#     <p>                                     # email
#     <Tabs>                                  # vertical tabs: orders / addresses / cards / profile
#       <Link>
#     <Button>                                # sign out
#   <main>
#     {children}

# ponytail: fixture session — there is no Spree Store API/customer login
# wired up yet, so every visitor here is auto-signed-in as the same fixture
# customer. The guard is real (a guest with session[:signed_in] = false does
# get bounced to the sign-in page); swap the "unless session.key?" line for a
# real current_customer check once auth lands.
before do
  session[:signed_in] = true unless session.key?(:signed_in)
  unless session[:signed_in]
    redirect("/#{params['country']}/#{params['locale']}/account", 303)
  end
end

# ponytail: a _layout.rb is class_eval'd into each leaf route file's own
# class with THAT leaf's route_prefix (e.g. .../account/orders), not a
# shared one -- so this ends up mounted once per page, at "<page>/sign-out"
# rather than one canonical URL. Fine: the client always deletes relative to
# wherever it currently is (see `${url}/sign-out` below).
delete "/sign-out" do
  session[:signed_in] = false
  redirect("/#{params['country']}/#{params['locale']}/account", 303)
end

helpers do
  # ponytail: fixture props, swap for the Spree Store API call when it is wired
  def fixture_customer
    { first_name: "Jordan", last_name: "Avery", email: "jordan.avery@example.com" }
  end
end

__END__

import type { PropsWithChildren } from "react"
import { Link, router, usePage } from "@inertiajs/react"
import { cn } from "cn"

import { Button } from "@/components/ui/button"

type Customer = { first_name: string; last_name: string; email: string }

const NAV = [
  { slug: "orders", label: "Orders" },
  { slug: "addresses", label: "Addresses" },
  { slug: "credit-cards", label: "Credit cards" },
  { slug: "gift-cards", label: "Gift cards" },
  { slug: "profile", label: "Profile" },
]

export default function AuthenticatedLayout({ children }: PropsWithChildren) {
  // Every page under this layout passes `customer` in its props, so it is
  // always on the shared Inertia page object even though only the layout
  // (not the route that rendered it) reads it here.
  const { url, props } = usePage<{ customer: Customer }>()
  const basePath = url.split("/account")[0]

  return (
    <div className="mx-auto flex w-full max-w-5xl flex-col gap-8 p-6 lg:flex-row">
      <aside className="w-full shrink-0 lg:w-56">
        <p className="text-sm font-medium">
          {props.customer.first_name} {props.customer.last_name}
        </p>
        <p className="text-muted-foreground text-sm">{props.customer.email}</p>

        <nav className="mt-6 flex gap-1 overflow-x-auto lg:flex-col lg:overflow-visible">
          {NAV.map((item) => {
            const href = `${basePath}/account/${item.slug}`
            const active = url.startsWith(href)

            return (
              <Link
                key={item.slug}
                href={href}
                className={cn(
                  "rounded-md px-3 py-1.5 text-sm whitespace-nowrap",
                  active
                    ? "bg-muted font-medium"
                    : "text-muted-foreground hover:bg-muted/50"
                )}
              >
                {item.label}
              </Link>
            )
          })}
        </nav>

        <Button
          type="button"
          variant="outline"
          size="sm"
          className="mt-6 w-full lg:w-auto"
          onClick={() => router.delete(`${url}/sign-out`)}
        >
          Sign out
        </Button>
      </aside>

      <main className="min-w-0 flex-1">{children}</main>
    </div>
  )
}
