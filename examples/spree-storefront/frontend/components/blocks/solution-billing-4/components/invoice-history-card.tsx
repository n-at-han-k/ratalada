import { Badge } from "@/components/reui/badge"

import { Button } from "@/components/ui/button"
import { Card, CardContent } from "@/components/ui/card"
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuGroup,
  DropdownMenuItem,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu"
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table"
import { type InvoiceRecord } from "./data"
import { MoreHorizontalIcon, EyeIcon, DownloadIcon, SendIcon } from "lucide-react"

interface InvoiceHistoryCardProps {
  invoices: InvoiceRecord[]
  onDownloadInvoice: (invoice: InvoiceRecord) => void
  onOpenInvoice: (invoice: InvoiceRecord) => void
  onSendReminder: (invoice: InvoiceRecord) => void
}

export function InvoiceHistoryCard({
  invoices,
  onDownloadInvoice,
  onOpenInvoice,
  onSendReminder,
}: InvoiceHistoryCardProps) {
  return (
    <Card className="gap-0 p-0">
      {/* Content */}
      <CardContent className="p-0">
        <div className="overflow-x-auto">
          <Table className="min-w-[48rem] table-fixed">
            <TableHeader>
              <TableRow>
                <TableHead className="w-[20%]">Invoice</TableHead>
                <TableHead className="w-[24%]">Period</TableHead>
                <TableHead className="w-[17%]">Date</TableHead>
                <TableHead className="w-[15%]">Total</TableHead>
                <TableHead className="w-[14%] text-right">Status</TableHead>
                <TableHead className="w-[10%] text-right">
                  <span className="sr-only">Actions</span>
                </TableHead>
              </TableRow>
            </TableHeader>

            <TableBody>
              {invoices.map((invoice) => (
                <TableRow key={invoice.id}>
                  <TableCell className="font-medium whitespace-nowrap">
                    <a
                      href="#"
                      onClick={(event) => {
                        event.preventDefault()
                        onOpenInvoice(invoice)
                      }}
                      className="text-foreground hover:text-primary inline-flex underline-offset-4 transition-colors hover:underline"
                    >
                      {invoice.reference}
                    </a>
                  </TableCell>
                  <TableCell className="text-muted-foreground text-sm whitespace-nowrap">
                    {invoice.period}
                  </TableCell>
                  <TableCell className="text-muted-foreground text-sm whitespace-nowrap">
                    {invoice.issuedAt}
                  </TableCell>
                  <TableCell className="font-semibold tracking-tight whitespace-nowrap tabular-nums">
                    {invoice.total}
                  </TableCell>
                  <TableCell className="text-right">
                    <Badge variant={invoice.status.variant}>
                      {invoice.status.label}
                    </Badge>
                  </TableCell>
                  <TableCell className="text-right">
                    <InvoiceActionsMenu
                      invoice={invoice}
                      onDownloadInvoice={onDownloadInvoice}
                      onOpenInvoice={onOpenInvoice}
                      onSendReminder={onSendReminder}
                    />
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </div>
      </CardContent>
    </Card>
  )
}

function InvoiceActionsMenu({
  invoice,
  onDownloadInvoice,
  onOpenInvoice,
  onSendReminder,
}: {
  invoice: InvoiceRecord
  onDownloadInvoice: (invoice: InvoiceRecord) => void
  onOpenInvoice: (invoice: InvoiceRecord) => void
  onSendReminder: (invoice: InvoiceRecord) => void
}) {
  const canSendReminder = invoice.status.label !== "Paid"

  return (
    <DropdownMenu>
      <DropdownMenuTrigger
        render={
          <Button
            type="button"
            variant="ghost"
            size="icon-sm"
            aria-label={`Open actions for ${invoice.reference}`}
          >
            <MoreHorizontalIcon data-icon="icon" aria-hidden="true" />
          </Button>
        }
      />
      <DropdownMenuContent side="bottom" align="end" className="w-44">
        <DropdownMenuGroup>
          <DropdownMenuItem onClick={() => onOpenInvoice(invoice)}>
            <EyeIcon className="size-4" aria-hidden="true" />
            View
          </DropdownMenuItem>
          <DropdownMenuItem onClick={() => onDownloadInvoice(invoice)}>
            <DownloadIcon className="size-4" aria-hidden="true" />
            Download
          </DropdownMenuItem>
          <DropdownMenuSeparator />
          <DropdownMenuItem
            onClick={() => onSendReminder(invoice)}
            disabled={!canSendReminder}
          >
            <SendIcon className="size-4" aria-hidden="true" />
            Remind
          </DropdownMenuItem>
        </DropdownMenuGroup>
      </DropdownMenuContent>
    </DropdownMenu>
  )
}