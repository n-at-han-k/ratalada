# frozen_string_literal: true

# reui: none
#
# {children}                                  # dev-only email preview shell

__END__

import type { PropsWithChildren } from "react"

export default function DevLayout({ children }: PropsWithChildren) {
  return <>{children}</>
}
