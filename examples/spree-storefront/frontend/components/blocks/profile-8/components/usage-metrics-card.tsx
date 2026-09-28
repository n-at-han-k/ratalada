import { Button } from "@/components/ui/button"
import { Card, CardContent, CardFooter } from "@/components/ui/card"

import { BillingIconTile } from "./billing-icon-tile"
import type { PlanMetric } from "./data"

interface UsageMetricsCardProps {
  metrics: PlanMetric[]
  footerNote: string
  actionLabel: string
}

export function UsageMetricsCard({
  metrics,
  footerNote,
  actionLabel,
}: UsageMetricsCardProps) {
  return (
    <Card className="gap-0 p-0">
      {/* Content */}
      <CardContent className="grid gap-0 p-0 sm:grid-cols-3 sm:divide-x">
        {metrics.map((metric) => (
          <div
            key={metric.id}
            className="flex min-h-[7.75rem] flex-col justify-between gap-4 px-5 py-5 sm:px-6"
          >
            <div className="flex items-center gap-3">
              <BillingIconTile className="size-9 [&_svg]:size-4">
                {metric.icon}
              </BillingIconTile>

              <div className="min-w-0">
                <p className="text-sm font-medium">{metric.title}</p>
                <p className="text-muted-foreground text-sm">
                  {metric.description}
                </p>
              </div>
            </div>

            <p className="text-lg font-semibold tracking-tight tabular-nums">
              {metric.value}
            </p>
          </div>
        ))}
      </CardContent>

      {/* Footer */}
      <CardFooter className="flex-col items-start justify-between gap-2 border-t px-5 py-3 sm:flex-row sm:items-center sm:px-6">
        <p className="text-muted-foreground max-w-xl text-sm">{footerNote}</p>

        <Button type="button" variant="outline" size="sm">
          {actionLabel}
        </Button>
      </CardFooter>
    </Card>
  )
}