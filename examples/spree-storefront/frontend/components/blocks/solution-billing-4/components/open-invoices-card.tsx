import { IconStack } from "@/components/reui/icon-stack"

import { Button } from "@/components/ui/button"
import { Card, CardContent } from "@/components/ui/card"
import {
  Empty,
  EmptyContent,
  EmptyDescription,
  EmptyHeader,
  EmptyMedia,
  EmptyTitle,
} from "@/components/ui/empty"
import { InboxIcon, PlusIcon } from "lucide-react"

interface OpenInvoicesCardProps {
  onNewInvoice: () => void
}

export function OpenInvoicesCard({ onNewInvoice }: OpenInvoicesCardProps) {
  return (
    <Card>
      <CardContent>
        <div className="flex w-full justify-center py-4">
          <Empty className="text-foreground max-w-md flex-none gap-6 border-0 bg-transparent p-0">
            <EmptyHeader className="items-center gap-5 text-center">
              <EmptyMedia className="mb-0">
                <IconStack aria-hidden="true">
                  <InboxIcon strokeWidth="1.9" aria-hidden="true" />
                </IconStack>
              </EmptyMedia>

              <div className="flex flex-col items-center gap-1.5">
                <EmptyTitle>No Open Invoices</EmptyTitle>
                <EmptyDescription className="max-w-80">
                  The current cycle on SUB-4821 is fully collected. The next
                  invoice issues at renewal on Mar 1, 2027.
                </EmptyDescription>
              </div>
            </EmptyHeader>

            <EmptyContent className="max-w-none items-center gap-0">
              <Button type="button" variant="outline" onClick={onNewInvoice}>
                <PlusIcon data-icon="inline-start" aria-hidden="true" />
                New invoice
              </Button>
            </EmptyContent>
          </Empty>
        </div>
      </CardContent>
    </Card>
  )
}