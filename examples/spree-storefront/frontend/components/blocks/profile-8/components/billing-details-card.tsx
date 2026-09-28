import { Badge } from "@/components/reui/badge"

import { Card, CardContent } from "@/components/ui/card"

import { BillingDetail } from "./data"
import { SettingRow, SettingRowGroup } from "./setting-row"

interface BillingDetailsCardProps {
  details: BillingDetail[]
}

export function BillingDetailsCard({ details }: BillingDetailsCardProps) {
  return (
    <Card className="gap-0 p-0">
      {/* Content */}
      <CardContent className="p-0">
        <SettingRowGroup>
          {details.map((detail, index) => (
            <SettingRow
              key={detail.id}
              title={detail.title}
              description={detail.description}
              hint={detail.hint}
              titleAddon={
                detail.badge ? (
                  <Badge variant={detail.badge.variant}>
                    {detail.badge.label}
                  </Badge>
                ) : null
              }
              last={index === details.length - 1}
            >
              <span
                className={
                  detail.valueMuted
                    ? "text-muted-foreground block max-w-full truncate text-right text-sm"
                    : "block max-w-full truncate text-right text-sm font-medium"
                }
                title={detail.value}
              >
                {detail.value}
              </span>
            </SettingRow>
          ))}
        </SettingRowGroup>
      </CardContent>
    </Card>
  )
}