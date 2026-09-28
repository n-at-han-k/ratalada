# frozen_string_literal: true

# reui: none — ui/item
#
# <h1>
# <p>
# <ItemGroup>
#   <Item>
#     <Link>                                  # per email template fixture

get "/" do
  inertia("dev/emails")
end

__END__

import { Head } from "@inertiajs/react"

export default function EmailPreviews() {
  return (
    <main className="p-6">
      <Head title="Email previews" />
      <h1 className="text-2xl font-semibold">Email previews</h1>
    </main>
  )
}
