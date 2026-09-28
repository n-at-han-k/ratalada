import { Badge } from "@/components/reui/badge"

import { Button } from "@/components/ui/button"
import { BillingIconTile } from "./billing-icon-tile"
import { type CustomerAccount } from "./data"
import { MailIcon, PlusIcon } from "lucide-react"

// Content-level identity header for one customer billing account (not a sticky
// layout navbar). Left: company identity, account id, plan, and balance state.
// Right: send reminder + open new invoice.

interface AccountHeaderProps {
  customer: CustomerAccount
  onSendReminder: () => void
  onNewInvoice: () => void
}

export function AccountHeader({
  customer,
  onSendReminder,
  onNewInvoice,
}: AccountHeaderProps) {
  return (
    <div className="flex flex-col gap-3 border-b pb-3 lg:flex-row lg:items-center lg:justify-between">
      <div className="flex min-w-0 items-center gap-2">
        <BillingIconTile className="size-10 [&_svg]:size-5">
          {customer.logo}
        </BillingIconTile>

        <div className="flex min-w-0 flex-col gap-0">
          <div className="flex flex-wrap items-center gap-2">
            <h1 className="text-foreground truncate text-lg font-semibold tracking-tight">
              {customer.name}
            </h1>
            <Badge variant="secondary">{customer.accountId}</Badge>
            <Badge variant="outline">{customer.plan}</Badge>
            <Badge variant={customer.status.variant}>
              {customer.status.label}
            </Badge>
          </div>
          <p className="text-muted-foreground truncate text-sm leading-5">
            {customer.meta}
          </p>
        </div>
      </div>

      <div className="flex shrink-0 flex-col gap-3 sm:flex-row sm:items-center sm:justify-end">
        <div className="flex items-center gap-2 sm:border-r sm:pr-3">
          <span className="text-muted-foreground text-xs font-medium tracking-wide uppercase">
            {customer.balanceLabel}
          </span>
          <span className="text-foreground text-lg font-semibold tracking-tight tabular-nums">
            {customer.balance}
          </span>
        </div>

        <div className="flex flex-wrap items-center gap-2">
          <Button type="button" variant="secondary" onClick={onSendReminder}>
            <MailIcon aria-hidden="true" />
            Send reminder
          </Button>
          <Button type="button" onClick={onNewInvoice}>
            <PlusIcon aria-hidden="true" />
            New invoice
          </Button>
        </div>
      </div>
    </div>
  )
}