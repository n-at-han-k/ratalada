# frozen_string_literal: true

# reui: none — ui/card + prose
#
# <h1>
# <div>                                       # policy body

# ponytail: fixture props, swap for the Spree Store API call when it is wired
FIXTURE_POLICIES = {
  "privacy" => { name: "Privacy Policy", body: "We collect only what we need to run your order, and we never sell it." },
  "returns" => { name: "Returns Policy", body: "Unused items can be returned within 30 days of delivery for a full refund." },
}.freeze

get "/" do
  policy = FIXTURE_POLICIES[params["slug"]]
  halt 404 unless policy

  inertia("[country]/[locale]/(storefront)/policies/[slug]", props: { policy: policy })
end

__END__

import { Head } from "@inertiajs/react"

export default function Policy({ policy }: { policy: { name: string; body: string } }) {
  return (
    <main className="mx-auto max-w-3xl px-4 py-12 md:px-6">
      <Head title={policy.name} />
      <h1 className="text-3xl font-semibold text-foreground">{policy.name}</h1>
      <div className="prose prose-neutral mt-8 max-w-none whitespace-pre-wrap text-foreground">{policy.body}</div>
    </main>
  )
}
