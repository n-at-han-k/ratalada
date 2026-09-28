import { Badge } from "@/components/reui/badge"

import { Button } from "@/components/ui/button"
import { Separator } from "@/components/ui/separator"
import { INVOICE_STATUS_BADGE } from "./data"
import { XIcon, MegaphoneIcon, SaveIcon, SendIcon } from "lucide-react"

export function InvoiceToolbar({
  formId,
  onFeedback,
  onSaveDraft,
}: {
  formId: string
  onFeedback: () => void
  onSaveDraft: () => void
}) {
  return (
    <header className="border-border bg-background sticky top-0 z-20 flex min-h-14 w-full shrink-0 items-center justify-between gap-3 border-b px-4">
      {/* Title */}
      <div className="flex min-w-0 items-center">
        <Button
          type="button"
          variant="ghost"
          size="icon-sm"
          className="-ms-2 size-8 shrink-0"
          aria-label="Close invoice editor"
        >
          <XIcon aria-hidden="true" />
        </Button>

        <Separator
          orientation="vertical"
          className="my-auto mr-4 ml-2 h-4 shrink-0"
        />

        <div className="flex min-w-0 items-center gap-2">
          <h1 className="text-foreground truncate text-base leading-5 font-medium">
            Create invoice
          </h1>
          <Badge
            variant={INVOICE_STATUS_BADGE.variant}
            className="hidden translate-y-px self-center sm:inline-flex"
          >
            {INVOICE_STATUS_BADGE.label}
          </Badge>
        </div>
      </div>

      {/* Actions */}
      <div className="flex shrink-0 items-center gap-2">
        <Button
          type="button"
          variant="ghost"
          className="hidden md:inline-flex"
          onClick={onFeedback}
        >
          <MegaphoneIcon data-icon="inline-start" aria-hidden="true" />
          Feedback
        </Button>
        <Button
          type="button"
          variant="outline"
          className="hidden sm:inline-flex"
          onClick={onSaveDraft}
        >
          <SaveIcon data-icon="inline-start" aria-hidden="true" />
          Save draft
        </Button>
        <Button type="submit" form={formId}>
          <SendIcon data-icon="inline-start" aria-hidden="true" />
          Send invoice
        </Button>
      </div>
    </header>
  )
}