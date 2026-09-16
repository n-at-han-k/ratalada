import { type ComponentType, type PropsWithChildren, useEffect, useState } from "react"
import { router, usePage } from "@inertiajs/react"
import pages from "virtual:pages"

import { AppShell } from "@/components/app-shell"
import { Dialog, DialogContent } from "@/components/ui/dialog"

type ModalData = {
  component: string
  props: Record<string, unknown>
  url: string
}

// A modal route renders its page *under* the dialog: the server sends the
// background page plus a `modal` prop naming the component to put on top of
// it, which is loaded from the same virtual:pages map the resolver uses.
function ModalHost() {
  const modal = usePage<{ modal?: ModalData }>().props.modal
  const [current, setCurrent] = useState<{ name: string; component: ComponentType } | null>(null)

  useEffect(() => {
    const name = modal?.component
    if (!name || current?.name === name) return
    let alive = true
    pages[name]?.().then((module) => {
      if (alive) setCurrent({ name, component: module.default })
    })
    return () => {
      alive = false
    }
  }, [modal?.component, current?.name])

  if (!modal || current?.name !== modal.component) return null

  return (
    <Dialog
      open
      onOpenChange={(open) => {
        if (!open) router.visit(modal.url, { preserveScroll: true })
      }}
    >
      <DialogContent>
        <current.component {...modal.props} />
      </DialogContent>
    </Dialog>
  )
}

export default function AppLayout({ children }: PropsWithChildren) {
  return (
    <AppShell>
      {children}
      <ModalHost />
    </AppShell>
  )
}
