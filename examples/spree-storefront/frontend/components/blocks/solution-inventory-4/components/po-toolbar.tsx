import { Badge } from "@/components/reui/badge"

import { Button } from "@/components/ui/button"
import { Separator } from "@/components/ui/separator"
import { PO_STATUS_BADGE, type PoStatus } from "./data"
import { XIcon, PrinterIcon, DownloadIcon, SendIcon, PackageIcon } from "lucide-react"

export function PoToolbar({
  poNumber,
  status,
  editable,
  onPrint,
  onExport,
  onSubmit,
}: {
  poNumber: string
  status: PoStatus
  editable: boolean
  onPrint: () => void
  onExport: () => void
  onSubmit: () => void
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
          aria-label="Back to purchase orders"
        >
          <XIcon aria-hidden="true" />
        </Button>

        <Separator
          orientation="vertical"
          className="my-auto mr-4 ml-2 h-4 shrink-0"
        />

        <div className="flex min-w-0 items-center gap-2">
          <h1 className="text-foreground truncate text-base leading-5 font-medium tabular-nums">
            {poNumber}
          </h1>
          <Badge
            variant={PO_STATUS_BADGE[status]}
            className="hidden translate-y-px self-center sm:inline-flex"
          >
            {status}
          </Badge>
        </div>
      </div>

      {/* Actions */}
      <div className="flex shrink-0 items-center gap-2">
        <Button
          type="button"
          variant="ghost"
          className="hidden md:inline-flex"
          onClick={onPrint}
        >
          <PrinterIcon data-icon="inline-start" aria-hidden="true" />
          Print
        </Button>
        <Button
          type="button"
          variant="outline"
          className="hidden sm:inline-flex"
          onClick={onExport}
        >
          <DownloadIcon data-icon="inline-start" aria-hidden="true" />
          Export
        </Button>
        <Button type="button" onClick={onSubmit}>
          {editable ? (
            <>
              <SendIcon data-icon="inline-start" aria-hidden="true" />
              Submit order
            </>
          ) : (
            <>
              <PackageIcon data-icon="inline-start" aria-hidden="true" />
              Receive all
            </>
          )}
        </Button>
      </div>
    </header>
  )
}