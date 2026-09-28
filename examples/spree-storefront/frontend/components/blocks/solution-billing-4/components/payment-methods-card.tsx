import { Badge } from "@/components/reui/badge"

import { Button } from "@/components/ui/button"
import { Card, CardContent } from "@/components/ui/card"
import { type PaymentMethod } from "./data"
import { SettingRow, SettingRowGroup } from "./payment-methods-row"
import { PencilIcon, Trash2Icon } from "lucide-react"

interface PaymentMethodsCardProps {
  methods: PaymentMethod[]
  defaultMethodId: string
  onUpdateDefault: (methodId: string) => void
  onEditMethod: (method: PaymentMethod) => void
  onDeleteMethod: (method: PaymentMethod) => void
}

export function PaymentMethodsCard({
  methods,
  defaultMethodId,
  onUpdateDefault,
  onEditMethod,
  onDeleteMethod,
}: PaymentMethodsCardProps) {
  return (
    <Card className="gap-0 p-0">
      {/* Content */}
      <CardContent className="p-0">
        <SettingRowGroup>
          {methods.map((method, index) => {
            const isDefault = method.id === defaultMethodId

            return (
              <SettingRow
                key={method.id}
                title={method.title}
                description={method.description}
                titleAddon={
                  <div className="flex items-center gap-1.5">
                    {isDefault ? (
                      <Badge variant="primary-light">Default</Badge>
                    ) : null}
                    {method.badge ? (
                      <Badge variant={method.badge.variant}>
                        {method.badge.label}
                      </Badge>
                    ) : null}
                  </div>
                }
                last={index === methods.length - 1}
              >
                <div className="flex w-full flex-wrap items-center justify-start gap-2 @md/field-group:justify-end">
                  <span className="text-muted-foreground block max-w-full truncate text-sm">
                    {method.reference}
                  </span>

                  <div className="flex flex-wrap items-center justify-start gap-1.5 @md/field-group:justify-end">
                    {!isDefault ? (
                      <Button
                        type="button"
                        variant="secondary"
                        size="xs"
                        onClick={() => onUpdateDefault(method.id)}
                      >
                        Set default
                      </Button>
                    ) : null}

                    <Button
                      type="button"
                      variant="ghost"
                      size="icon-sm"
                      aria-label={`Edit ${method.title}`}
                      onClick={() => onEditMethod(method)}
                    >
                      <PencilIcon data-icon="icon" aria-hidden="true" />
                    </Button>

                    <Button
                      type="button"
                      variant="ghost"
                      size="icon-sm"
                      className="text-destructive hover:text-destructive"
                      aria-label={
                        isDefault
                          ? `${method.title} cannot be removed while default`
                          : `Delete ${method.title}`
                      }
                      disabled={isDefault}
                      onClick={() => onDeleteMethod(method)}
                    >
                      <Trash2Icon data-icon="icon" aria-hidden="true" />
                    </Button>
                  </div>
                </div>
              </SettingRow>
            )
          })}
        </SettingRowGroup>
      </CardContent>
    </Card>
  )
}