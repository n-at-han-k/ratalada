import { Badge } from "@/components/reui/badge"

import { Button } from "@/components/ui/button"
import {
  Card,
  CardFooter,
  CardHeader,
  CardTitle,
} from "@/components/ui/card"

import { BillingIconTile } from "./billing-icon-tile"
import type { PlanSummary } from "./data"

interface PlanSummaryCardProps {
  plan: PlanSummary
}

export function PlanSummaryCard({ plan }: PlanSummaryCardProps) {
  return (
    <Card className="gap-0 p-0">
      {/* Header */}
      <CardHeader className="gap-6 px-5 py-5 sm:px-6">
        <div className="grid items-start gap-6 md:grid-cols-[minmax(0,1fr)_minmax(10rem,13rem)]">
          <div className="flex min-w-0 gap-4">
            <BillingIconTile>{plan.icon}</BillingIconTile>

            <div className="min-w-0 space-y-2">
              <div className="flex flex-wrap items-center gap-2">
                <CardTitle>{plan.name}</CardTitle>
                <Badge variant={plan.status.variant} size="sm">
                  {plan.status.label}
                </Badge>
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

          <dl className="grid gap-4 md:pl-4">
            {plan.facts.map((fact) => (
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
      <CardFooter className="flex-col items-start justify-between gap-2 border-t px-5 py-3 sm:flex-row sm:items-center sm:px-6">
        <p className="text-muted-foreground max-w-xl text-sm">
          {plan.footerNote}
        </p>

        <Button type="button" variant="outline" size="sm">
          {plan.actionLabel}
        </Button>
      </CardFooter>
    </Card>
  )
}