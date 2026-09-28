# frozen_string_literal: true

# reui: none
#
# <Link>                                      # back to list
# <strong>                                    # fixture label
# <Link>                                      # view source
# <iframe>                                    # rendered email
# <pre>                                       # source view

get "/" do
  inertia("dev/emails/[template]")
end

__END__

import { Head } from "@inertiajs/react"

export default function EmailPreview() {
  return (
    <main className="p-6">
      <Head title="Email preview" />
      <h1 className="text-2xl font-semibold">Email preview</h1>
    </main>
  )
}
