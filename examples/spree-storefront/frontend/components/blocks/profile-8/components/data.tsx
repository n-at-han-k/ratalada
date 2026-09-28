import { type ReactNode } from "react"
import { type BadgeProps } from "@/components/reui/badge"
import { CreditCardIcon, UsersIcon, FileTextIcon, CircleDollarSignIcon, DownloadIcon, PencilIcon } from "lucide-react"

export interface TrialNotice {
  message: string
  actionLabel: string
}

export interface PlanSummary {
  name: string
  icon: ReactNode
  status: {
    label: string
    variant: BadgeProps["variant"]
  }
  price: string
  cadence: string
  summary: string
  facts: {
    id: string
    label: string
    value: string
  }[]
  footerNote: string
  actionLabel: string
}

export interface PlanMetric {
  id: string
  title: string
  description: string
  value: string
  icon: ReactNode
}

export interface BillingDetail {
  id: string
  title: string
  description: string
  hint?: ReactNode
  value: string
  valueMuted?: boolean
  badge?: {
    label: string
    variant: BadgeProps["variant"]
  }
}

export interface InvoiceRecord {
  id: string
  reference: string
  period: string
  total: string
  issuedAt: string
  status: {
    label: string
    variant: BadgeProps["variant"]
  }
}

export const TRIAL_NOTICE: TrialNotice = {
  message:
    "No company card is saved. Add one before May 3, 2026 so renewal, seat changes, and receipt delivery can continue normally.",
  actionLabel: "Add company card",
}

export const PLAN_SUMMARY: PlanSummary = {
  name: "Growth",
  icon: (
    <CreditCardIcon aria-hidden="true" />
  ),
  status: {
    label: "Trial",
    variant: "warning-light",
  },
  price: "$24.00",
  cadence: "per editor / month",
  summary:
    "Growth keeps audit history, automations, and workspace permissions on one monthly plan.",
  facts: [
    {
      id: "renewal-date",
      label: "Renewal date",
      value: "May 3, 2026",
    },
    {
      id: "renewal-status",
      label: "Renewal status",
      value: "Card required",
    },
    {
      id: "billing-owner",
      label: "Billing owner",
      value: "Mina Ortega",
    },
  ],
  footerNote: "Renewal stays paused until a company card is added.",
  actionLabel: "Manage plan",
}

export const PLAN_METRICS: PlanMetric[] = [
  {
    id: "seats",
    title: "Seats",
    description: "Active editors",
    value: "3 of 5",
    icon: (
      <UsersIcon aria-hidden="true" />
    ),
  },
  {
    id: "records",
    title: "Tracked records",
    description: "Used this month",
    value: "218,430",
    icon: (
      <FileTextIcon aria-hidden="true" />
    ),
  },
  {
    id: "credits",
    title: "Automation credits",
    description: "Used this month",
    value: "1,280",
    icon: (
      <CircleDollarSignIcon aria-hidden="true" />
    ),
  },
]

export const USAGE_FOOTER_NOTE =
  "Usage counters reset on May 3, 2026 with the next billing cycle."

export const USAGE_ACTION_LABEL = "View usage"

export const BILLING_DETAILS: BillingDetail[] = [
  {
    id: "billing-contact",
    title: "Billing contact",
    description: "Receives invoices and renewal notices.",
    hint: "Use a shared finance inbox so billing messages do not depend on one person.",
    value: "billing@northstarstudio.co",
  },
  {
    id: "entity-name",
    title: "Legal entity",
    description: "Shown on invoices and receipts.",
    value: "Northstar Studio GmbH",
  },
  {
    id: "billing-region",
    title: "Region",
    description: "Used for tax and invoice formatting.",
    hint: "Region drives tax treatment, receipt language, and billing portal defaults.",
    value: "Berlin, Germany",
  },
  {
    id: "payment-method",
    title: "Payment method",
    description: "Required before the trial renews.",
    hint: "A company card is required before renewal, seat changes, or usage upgrades can process.",
    value: "No company card added",
    valueMuted: true,
    badge: {
      label: "Action required",
      variant: "warning-light",
    },
  },
]

export const INVOICES: InvoiceRecord[] = [
  {
    id: "invoice-apr",
    reference: "INV-4208",
    period: "Apr 2026",
    total: "$0.00",
    issuedAt: "Apr 2, 2026",
    status: {
      label: "Credited",
      variant: "warning-light",
    },
  },
  {
    id: "invoice-mar",
    reference: "INV-4079",
    period: "Mar 2026",
    total: "$96.00",
    issuedAt: "Mar 2, 2026",
    status: {
      label: "Paid",
      variant: "success-light",
    },
  },
  {
    id: "invoice-feb",
    reference: "INV-3912",
    period: "Feb 2026",
    total: "$72.00",
    issuedAt: "Feb 2, 2026",
    status: {
      label: "Paid",
      variant: "success-light",
    },
  },
  {
    id: "invoice-jan",
    reference: "INV-3784",
    period: "Jan 2026",
    total: "$72.00",
    issuedAt: "Jan 2, 2026",
    status: {
      label: "Paid",
      variant: "success-light",
    },
  },
  {
    id: "invoice-dec",
    reference: "INV-3642",
    period: "Dec 2025",
    total: "$72.00",
    issuedAt: "Dec 2, 2025",
    status: {
      label: "Paid",
      variant: "success-light",
    },
  },
  {
    id: "invoice-nov",
    reference: "INV-3501",
    period: "Nov 2025",
    total: "$48.00",
    issuedAt: "Nov 2, 2025",
    status: {
      label: "Paid",
      variant: "success-light",
    },
  },
]

export const DOWNLOAD_ALL_ACTION = (
  <DownloadIcon data-icon="inline-start" aria-hidden="true" />
)

export const EDIT_DETAILS_ACTION = (
  <PencilIcon aria-hidden="true" />
)