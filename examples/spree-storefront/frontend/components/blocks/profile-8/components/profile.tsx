import { Button } from "@/components/ui/button"
import { BillingDetailsCard } from "./billing-details-card"
import {
  BILLING_DETAILS,
  DOWNLOAD_ALL_ACTION,
  EDIT_DETAILS_ACTION,
  INVOICES,
  PLAN_METRICS,
  PLAN_SUMMARY,
  TRIAL_NOTICE,
  USAGE_ACTION_LABEL,
  USAGE_FOOTER_NOTE,
} from "./data"
import { InvoiceHistoryCard } from "./invoice-history-card"
import { PlanSummaryCard } from "./plan-summary-card"
import { SettingsSection } from "./settings-section"
import { TrialAlert } from "./trial-alert"
import { UsageMetricsCard } from "./usage-metrics-card"
import { ArrowLeftIcon } from "lucide-react"

export function Profile() {
  return (
    <div className="flex w-full max-w-3xl flex-col gap-10">
      {/* Heading */}
      <div className="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
        <div className="flex max-w-2xl flex-col gap-0.5">
          <h1 className="text-xl font-semibold">Billing</h1>
          <p className="text-muted-foreground text-sm">
            Review the current plan, billing contact, and recent invoices.
          </p>
        </div>

        <Button
          type="button"
          variant="outline"
          className="shrink-0 self-start sm:self-auto"
        >
          <ArrowLeftIcon aria-hidden="true" />
          Back to profile
        </Button>
      </div>

      <TrialAlert notice={TRIAL_NOTICE} />

      <SettingsSection
        title="Plan"
        description="Current subscription and core usage."
      >
        <div className="grid gap-4">
          <PlanSummaryCard plan={PLAN_SUMMARY} />
          <UsageMetricsCard
            metrics={PLAN_METRICS}
            footerNote={USAGE_FOOTER_NOTE}
            actionLabel={USAGE_ACTION_LABEL}
          />
        </div>
      </SettingsSection>

      <SettingsSection
        title="Billing Details"
        description="Invoice contact and payment readiness."
        action={
          <Button type="button" variant="outline" size="sm">
            {EDIT_DETAILS_ACTION}
            Edit details
          </Button>
        }
      >
        <BillingDetailsCard details={BILLING_DETAILS} />
      </SettingsSection>

      <SettingsSection
        title="Invoice History"
        description="Recent invoices."
        action={
          <Button type="button" variant="outline" size="sm">
            {DOWNLOAD_ALL_ACTION}
            Download all
          </Button>
        }
      >
        <InvoiceHistoryCard invoices={INVOICES} />
      </SettingsSection>
    </div>
  )
}