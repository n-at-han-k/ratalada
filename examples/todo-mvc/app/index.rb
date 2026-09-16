# frozen_string_literal: true

get "/" do
  # no-op
end

__END__

import { Head } from "@inertiajs/react"

export default function Index() {
  return (
    <h1>Hello, world!</h1>
  )
}
