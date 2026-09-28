import { Badge } from "@/components/reui/badge"

import { Button } from "@/components/ui/button"
import {
  Card,
  CardFooter,
  CardHeader,
  CardTitle,
} from "@/components/ui/card"

import { BillingIconTile } from "./billing-icon-tile"
import { type PlanSummary } from "./data"

interface SubscriptionCardProps {
  plan: PlanSummary
  onChangePlan: () => void
}

export function SubscriptionCard({
  plan,
  onChangePlan,
}: SubscriptionCardProps) {
  const planDetails = [...plan.facts, ...plan.details]

  return (
    <Card className="gap-0 p-0">
      {/* Header */}
      <CardHeader className="px-4 py-4">
        <div className="grid items-start gap-5 md:grid-cols-[minmax(0,1fr)_minmax(16rem,20rem)]">
          <div className="flex min-w-0 gap-3">
            <BillingIconTile>{plan.icon}</BillingIconTile>

            <div className="min-w-0 space-y-1.5">
              <div className="flex flex-wrap items-center gap-2">
                <CardTitle>{plan.name}</CardTitle>
                <Badge variant={plan.status.variant}>{plan.status.label}</Badge>
              </div>

              <p className="text-sm">
                <span className="font-medium">{plan.price}</span>{" "}
                <span className="text-muted-foreground">{plan.cadence}</span>
              </p>

              <p className="text-muted-foreground max-w-xl text-sm leading-6">
                {plan.summary}
              </p>
            </div>
          </div>

          <dl className="grid grid-cols-2 gap-x-5 gap-y-3 md:pl-3">
            {planDetails.map((fact) => (
              <div key={fact.id} className="space-y-0.5">
                <dt className="text-muted-foreground text-xs font-medium tracking-wide uppercase">
                  {fact.label}
                </dt>
                <dd className="text-sm font-medium">{fact.value}</dd>
              </div>
            ))}
          </dl>
        </div>
      </CardHeader>

      {/* Footer */}
      <CardFooter className="flex-col items-start justify-between gap-2 border-t px-4 py-3 sm:flex-row sm:items-center">
        <p className="text-muted-foreground max-w-xl text-sm">
          {plan.footerNote}
        </p>

        <Button type="button" variant="outline" onClick={onChangePlan}>
          {plan.actionLabel}
        </Button>
      </CardFooter>
    </Card>
  )
}