import { useCallback, useState } from "react"
import { toast } from "sonner"

import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader } from "@/components/ui/card"
import { ScrollArea } from "@/components/ui/scroll-area"
import {
  Tabs,
  TabsContent,
  TabsList,
  TabsTrigger,
} from "@/components/ui/tabs"
import { AccountActivityRail } from "./account-activity-rail"
import { AccountHeader } from "./account-header"
import {
  ACCOUNT_ACTIVITY,
  CUSTOMER,
  INVOICE_HISTORY,
  PAYMENT_METHODS,
  SUBSCRIPTION,
  type InvoiceRecord,
  type PaymentMethod,
} from "./data"
import { InvoiceHistoryCard } from "./invoice-history-card"
import { OpenInvoicesCard } from "./open-invoices-card"
import { PaymentMethodsCard } from "./payment-methods-card"
import { SettingsHeading } from "./settings-heading"
import { SubscriptionCard } from "./subscription-card"
import { DownloadIcon, SendIcon } from "lucide-react"

export function CustomerBillingDetail() {
  const latestInvoice = INVOICE_HISTORY[0]
  const [defaultMethodId, setDefaultMethodId] = useState(
    PAYMENT_METHODS.find((method) => method.isDefault)?.id ??
      PAYMENT_METHODS[0].id
  )

  const handleSendReminder = useCallback(() => {
    toast.success("Reminder sent", {
      description: `Payment reminder emailed to ${CUSTOMER.billingEmail} for ${CUSTOMER.balance}.`,
    })
  }, [])

  const handleSendInvoiceReminder = useCallback((invoice: InvoiceRecord) => {
    toast.success("Reminder sent", {
      description: `${invoice.reference} reminder emailed to ${CUSTOMER.billingEmail}.`,
    })
  }, [])

  const handleDownloadInvoice = useCallback((invoice: InvoiceRecord) => {
    toast.success("Invoice download queued", {
      description: `${invoice.reference} PDF is ready for ${CUSTOMER.name}.`,
    })
  }, [])

  const handleNewInvoice = useCallback(() => {
    toast.info("Invoice draft started", {
      description: `New invoice opened for ${CUSTOMER.name} on ${CUSTOMER.subscriptionId}.`,
    })
  }, [])

  const handleChangePlan = useCallback(() => {
    toast.info("Plan change opened", {
      description: `${CUSTOMER.name} is on Scale, $18,000 per year. Choose a new tier to preview proration.`,
    })
  }, [])

  const handleOpenInvoice = useCallback((invoice: InvoiceRecord) => {
    toast.info(`Opened ${invoice.reference}`, {
      description: `${invoice.total} for ${invoice.period}, marked ${invoice.status.label}.`,
    })
  }, [])

  const handleUpdateDefault = useCallback((methodId: string) => {
    setDefaultMethodId(methodId)
    const method = PAYMENT_METHODS.find((entry) => entry.id === methodId)
    toast.success("Default method updated", {
      description: `${method?.title ?? methodId} now charges Scale renewals on ${CUSTOMER.subscriptionId}.`,
    })
  }, [])

  const handleEditPaymentMethod = useCallback((method: PaymentMethod) => {
    toast.info("Payment method opened", {
      description: `${method.title} is ready to edit for ${CUSTOMER.name}.`,
    })
  }, [])

  const handleDeletePaymentMethod = useCallback((method: PaymentMethod) => {
    toast.warning("Removal queued", {
      description: `${method.title} will be reviewed before deletion.`,
    })
  }, [])

  return (
    <div className="bg-background flex min-h-svh w-full flex-col">
      <div className="mx-auto w-full max-w-[1320px] p-3">
        {/* Content-level identity header */}
        <AccountHeader
          customer={CUSTOMER}
          onSendReminder={handleSendReminder}
          onNewInvoice={handleNewInvoice}
        />

        <div className="mt-4 grid gap-4 lg:grid-cols-[minmax(0,1fr)_minmax(20rem,24rem)] lg:gap-5">
          <Tabs defaultValue="invoices" className="min-w-0 gap-3">
            <TabsList
              aria-label="Billing detail sections"
              className="grid w-full grid-cols-3 sm:w-fit"
            >
              <TabsTrigger value="invoices" type="button">
                Invoices
              </TabsTrigger>
              <TabsTrigger value="subscription" type="button">
                Subscription
              </TabsTrigger>
              <TabsTrigger value="payments" type="button">
                Payments
              </TabsTrigger>
            </TabsList>

            <TabsContent value="subscription" className="mt-0 min-w-0">
              <section className="flex flex-col gap-3">
                <SettingsHeading
                  title="Subscription"
                  description="Plan, renewal, and seat allocation."
                />
                <SubscriptionCard
                  plan={SUBSCRIPTION}
                  onChangePlan={handleChangePlan}
                />
              </section>
            </TabsContent>

            <TabsContent value="payments" className="mt-0 min-w-0">
              <section className="flex flex-col gap-3">
                <SettingsHeading
                  title="Payment Methods"
                  description="Default and backup collection methods."
                />
                <PaymentMethodsCard
                  methods={PAYMENT_METHODS}
                  defaultMethodId={defaultMethodId}
                  onUpdateDefault={handleUpdateDefault}
                  onEditMethod={handleEditPaymentMethod}
                  onDeleteMethod={handleDeletePaymentMethod}
                />
              </section>
            </TabsContent>

            <TabsContent
              value="invoices"
              className="mt-0 flex min-w-0 flex-col gap-3"
            >
              <section className="flex flex-col gap-3">
                <SettingsHeading
                  title="Invoices"
                  description="History and current collection state."
                  action={
                    latestInvoice ? (
                      <div className="flex items-center gap-2">
                        <Button
                          type="button"
                          variant="secondary"
                          size="sm"
                          onClick={() => handleDownloadInvoice(latestInvoice)}
                        >
                          <DownloadIcon data-icon="inline-start" aria-hidden="true" />
                          Download
                        </Button>
                        <Button
                          type="button"
                          size="sm"
                          onClick={() =>
                            handleSendInvoiceReminder(latestInvoice)
                          }
                        >
                          <SendIcon data-icon="inline-start" aria-hidden="true" />
                          Remind
                        </Button>
                      </div>
                    ) : null
                  }
                />

                <InvoiceHistoryCard
                  invoices={INVOICE_HISTORY}
                  onDownloadInvoice={handleDownloadInvoice}
                  onOpenInvoice={handleOpenInvoice}
                  onSendReminder={handleSendInvoiceReminder}
                />

                <OpenInvoicesCard onNewInvoice={handleNewInvoice} />
              </section>
            </TabsContent>
          </Tabs>

          <Card className="h-[34rem] min-h-0 lg:sticky lg:top-3 lg:h-[41rem]">
            <CardHeader className="shrink-0">
              <SettingsHeading
                title="Account Activity"
                description="Recent billing events on ACC-3092."
                className="gap-2"
              />
            </CardHeader>
            <CardContent className="min-h-0 flex-1">
              <ScrollArea className="-mr-2 h-full pr-2">
                <AccountActivityRail events={ACCOUNT_ACTIVITY} />
              </ScrollArea>
            </CardContent>
          </Card>
        </div>
      </div>
    </div>
  )
}