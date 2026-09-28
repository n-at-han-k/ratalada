# frozen_string_literal: true

# reui: none — ui/spinner
#
# <Spinner>
# <p>

get "/" do
  inertia("[country]/[locale]/(checkout)/confirm-payment/[id]", props: {
    country: params["country"],
    locale:  params["locale"],
    id:      params["id"],
  })
end

__END__

import { Head, router } from "@inertiajs/react"
import { useEffect } from "react"

import { Spinner } from "@/components/ui/spinner"

// Where an offsite gateway (Stripe 3DS, PayPal, ...) redirects back to once
// the customer approves the charge on the provider's own page. Real flow
// would ask the Store API whether the payment session actually completed;
// there's no gateway wired up here, so this just simulates the round trip
// and always lands on order-placed.
// ponytail: swap the timeout for the Store API payment-session confirmation call.
export default function ConfirmPayment({ country, locale, id }: { country: string; locale: string; id: string }) {
  useEffect(() => {
    const timeout = window.setTimeout(() => {
      router.visit(`/${country}/${locale}/order-placed/${id}`)
    }, 800)
    return () => window.clearTimeout(timeout)
  }, [country, locale, id])

  return (
    <main className="flex flex-col items-center justify-center gap-4 py-20">
      <Head title="Confirming payment" />
      <Spinner className="text-muted-foreground size-8" aria-hidden="true" />
      <p className="text-muted-foreground text-sm">Confirming your payment…</p>
    </main>
  )
}
