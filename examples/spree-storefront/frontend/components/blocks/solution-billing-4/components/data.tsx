import { type ReactNode } from "react"
import { type BadgeProps } from "@/components/reui/badge"

import { Slack } from "@/components/ui/svgs/slack"
import { ReceiptIcon } from "lucide-react"

export type PlanTier = "Starter" | "Growth" | "Scale" | "Enterprise"

export type InvoiceStatus = "Paid" | "Open" | "Past due" | "Draft"

export type ActivityStatus = "completed" | "active" | "pending" | "issue"

export interface BadgeMark {
  label: string
  variant: BadgeProps["variant"]
}

// One Beacon customer, read in depth. Slack (ACC-3092) carries one overdue
// invoice, so the header balance and the past due history row tell the same
// story. There are no current-cycle open invoices, which is why the Open
// invoices region renders its empty state.
export interface CustomerAccount {
  name: string
  logo: ReactNode
  accountId: string
  subscriptionId: string
  plan: PlanTier
  status: BadgeMark
  balanceLabel: string
  balance: string
  meta: string
  billingEmail: string
}

export interface PlanFact {
  id: string
  label: string
  value: string
}

export interface PlanSummary {
  name: string
  icon: ReactNode
  status: BadgeMark
  price: string
  cadence: string
  summary: string
  facts: PlanFact[]
  details: PlanFact[]
  footerNote: string
  actionLabel: string
}

export interface PaymentMethod {
  id: string
  title: string
  description: string
  reference: string
  isDefault: boolean
  badge?: BadgeMark
}

export interface InvoiceRecord {
  id: string
  reference: string
  period: string
  total: string
  issuedAt: string
  status: BadgeMark
}

export interface ActivityLabel {
  id: string
  label: string
  hint?: string
  variant: BadgeProps["variant"]
}

export interface ActivityEvent {
  id: number
  title: string
  at: string
  status: ActivityStatus
  summary: string
  labels: ActivityLabel[]
}

// Beacon account data uses one company logo from the shared SVG set and a
// compact activity trail with summary-first event copy.
export const CUSTOMER: CustomerAccount = {
  name: "Slack",
  logo: <Slack className="size-6" aria-hidden="true" />,
  accountId: "ACC-3092",
  subscriptionId: "SUB-4821",
  plan: "Scale",
  status: { label: "Past due", variant: "destructive-light" },
  balanceLabel: "Balance due",
  balance: "$890.00",
  meta: "Customer since Mar 2024, owner Andre Costa",
  billingEmail: "billing@slack.example",
}

export const SUBSCRIPTION: PlanSummary = {
  name: "Scale plan",
  icon: (
    <ReceiptIcon aria-hidden="true" />
  ),
  status: { label: "Active", variant: "success-light" },
  price: "$18,000.00",
  cadence: "per year",
  summary:
    "Scale covers 40 seats, usage metering, and priority support on SUB-4821, billed annually.",
  facts: [
    { id: "renewal", label: "Renews", value: "Mar 1, 2027" },
    { id: "seats", label: "Seats", value: "36 of 40" },
    { id: "mrr", label: "MRR", value: "$1,500" },
    { id: "collection", label: "Collection", value: "Auto" },
  ],
  details: [
    { id: "terms", label: "Terms", value: "Net 14" },
    { id: "usage", label: "Usage", value: "92K events" },
    { id: "support", label: "Support", value: "Priority" },
  ],
  footerNote: "Auto-collection runs on Mar 1, 2027.",
  actionLabel: "Change plan",
}

export const PAYMENT_METHODS: PaymentMethod[] = [
  {
    id: "pm-7741",
    title: "Visa ending 4242",
    description: "Default method · charged on the 1st each cycle.",
    reference: "PM-7741",
    isDefault: true,
    badge: { label: "Expires 07/26", variant: "warning-light" },
  },
  {
    id: "pm-7610",
    title: "ACH · Mercury Bank",
    description: "Backup method · used if the card declines.",
    reference: "PM-7610",
    isDefault: false,
  },
  {
    id: "pm-7308",
    title: "Mastercard ending 6204",
    description: "Finance-owned card for manual collections.",
    reference: "PM-7308",
    isDefault: false,
    badge: { label: "Backup", variant: "secondary" },
  },
  {
    id: "pm-7195",
    title: "Wire transfer",
    description: "Available for annual renewal invoices.",
    reference: "PM-7195",
    isDefault: false,
  },
]

// Invoice history: one Past due (the $890 balance), recent Paid renewals, and
// the current open cycle invoice. The open row keeps the current state visible.
export const INVOICE_HISTORY: InvoiceRecord[] = [
  {
    id: "inv-20418",
    reference: "INV-20418",
    period: "May usage · seats",
    total: "$890.00",
    issuedAt: "May 12, 2026",
    status: { label: "Past due", variant: "destructive-light" },
  },
  {
    id: "inv-20290",
    reference: "INV-20290",
    period: "Apr usage · seats",
    total: "$840.00",
    issuedAt: "Apr 12, 2026",
    status: { label: "Paid", variant: "success-light" },
  },
  {
    id: "inv-19980",
    reference: "INV-19980",
    period: "Annual renewal · Scale",
    total: "$18,000.00",
    issuedAt: "Mar 1, 2026",
    status: { label: "Paid", variant: "success-light" },
  },
  {
    id: "inv-19844",
    reference: "INV-19844",
    period: "Feb usage · seats",
    total: "$760.00",
    issuedAt: "Feb 12, 2026",
    status: { label: "Paid", variant: "success-light" },
  },
]

// Newest first. The retry is the active step, while the pending card update and
// declined charge keep the past due balance grounded in recent activity.
export const ACCOUNT_ACTIVITY: ActivityEvent[] = [
  {
    id: 9,
    title: "Backup method added",
    at: "May 22, 2026",
    status: "completed",
    summary: "ACH Mercury Bank is available for fallback collection.",
    labels: [
      { id: "method", label: "Method", hint: "PM-7610", variant: "outline" },
      { id: "state", label: "Added", hint: "backup", variant: "outline" },
    ],
  },
  {
    id: 8,
    title: "Finance owner notified",
    at: "May 21, 2026",
    status: "completed",
    summary: "Andre Costa received the expiring-card notice.",
    labels: [
      { id: "owner", label: "Owner", hint: "Andre", variant: "outline" },
      { id: "channel", label: "Email", hint: "opened", variant: "outline" },
    ],
  },
  {
    id: 7,
    title: "Review queued",
    at: "May 20, 2026",
    status: "pending",
    summary: "Collections review waits for the retry result.",
    labels: [
      { id: "queue", label: "Queue", hint: "billing", variant: "outline" },
      { id: "sla", label: "SLA", hint: "24h", variant: "outline" },
    ],
  },
  {
    id: 6,
    title: "Card expiry flagged",
    at: "May 20, 2026",
    status: "completed",
    summary: "Visa ending 4242 expires 07/26 and needs a replacement.",
    labels: [
      {
        id: "state",
        label: "Checked",
        hint: "request sent",
        variant: "outline",
      },
      { id: "method", label: "Method", hint: "PM-7741", variant: "outline" },
    ],
  },
  {
    id: 5,
    title: "Smart retry scheduled",
    at: "May 18, 2026",
    status: "active",
    summary: "Retry runs against the saved Visa method.",
    labels: [
      {
        id: "state",
        label: "Scheduled",
        hint: "May 18",
        variant: "primary-light",
      },
      {
        id: "invoice",
        label: "Invoice",
        hint: "INV-20418",
        variant: "outline",
      },
    ],
  },
  {
    id: 4,
    title: "Payment reminder sent",
    at: "May 16, 2026",
    status: "completed",
    summary: "Reminder sent to billing@slack.example.",
    labels: [
      { id: "channel", label: "Email", hint: "delivered", variant: "outline" },
      { id: "balance", label: "Balance", hint: "$890", variant: "outline" },
    ],
  },
  {
    id: 3,
    title: "Renewal charge declined",
    at: "May 14, 2026",
    status: "issue",
    summary: "Visa ending 4242 failed collection on INV-20418.",
    labels: [
      {
        id: "issue",
        label: "Issue",
        hint: "insufficient funds",
        variant: "destructive-light",
      },
      { id: "amount", label: "Amount", hint: "$890", variant: "outline" },
    ],
  },
  {
    id: 2,
    title: "Invoice issued",
    at: "May 12, 2026",
    status: "completed",
    summary: "INV-20418 posted for May usage seats.",
    labels: [
      {
        id: "invoice",
        label: "Invoice",
        hint: "INV-20418",
        variant: "outline",
      },
      { id: "amount", label: "Amount", hint: "$890", variant: "outline" },
    ],
  },
  {
    id: 1,
    title: "Seat true-up posted",
    at: "May 10, 2026",
    status: "completed",
    summary: "Usage true-up added four seats to the cycle.",
    labels: [
      { id: "usage", label: "Usage", hint: "+4 seats", variant: "outline" },
      { id: "plan", label: "Plan", hint: "Scale", variant: "outline" },
    ],
  },
]