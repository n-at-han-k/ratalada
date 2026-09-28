import { useRef, useState, type FormEvent, type ReactNode } from "react"
import { Badge } from "@/components/reui/badge"
import { toast } from "sonner"

import { Button } from "@/components/ui/button"
import {
  Card,
  CardAction,
  CardContent,
  CardDescription,
  CardFooter,
  CardHeader,
  CardTitle,
} from "@/components/ui/card"
import {
  Combobox,
  ComboboxContent,
  ComboboxEmpty,
  ComboboxInput,
  ComboboxItem,
  ComboboxList,
} from "@/components/ui/combobox"
import {
  Field,
  FieldDescription,
  FieldGroup,
  FieldLabel,
  FieldLegend,
  FieldSet,
} from "@/components/ui/field"
import { Input } from "@/components/ui/input"
import {
  InputGroup,
  InputGroupAddon,
  InputGroupInput,
} from "@/components/ui/input-group"
import {
  Select,
  SelectContent,
  SelectGroup,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select"
import { Separator } from "@/components/ui/separator"
import { Textarea } from "@/components/ui/textarea"
import {
  Tooltip,
  TooltipContent,
  TooltipProvider,
  TooltipTrigger,
} from "@/components/ui/tooltip"
import {
  COLLECTION_METHOD_OPTIONS,
  createInvoiceLine,
  CURRENCY_OPTIONS,
  DEFAULT_INVOICE_FORM_VALUES,
  DEFAULT_INVOICE_LINES,
  INVOICE_CUSTOMERS,
  INVOICE_PRODUCTS,
  INVOICE_STATUS_BADGE,
  PAYMENT_TERMS_OPTIONS,
  PRODUCT_BY_ID,
  type InvoiceLineItem,
  type SelectOption,
} from "./data"
import { InvoiceDateField } from "./invoice-date-field"
import { InvoiceLineItems } from "./invoice-line-items"
import { InvoiceSection } from "./invoice-section"
import { InvoiceSummary } from "./invoice-summary"
import { InvoiceToolbar } from "./invoice-toolbar"
import { FileTextIcon, CircleCheckIcon, InfoIcon, ReceiptIcon, Building2Icon, HashIcon, PlusIcon } from "lucide-react"

const FORM_ID = "form-3-invoice-creator"

function getOptionLabel(options: SelectOption[], value: string) {
  return options.find((option) => option.value === value)?.label ?? value
}

function getLineSubtotal(line: InvoiceLineItem) {
  return line.quantity * line.unitPrice
}

function getLineTax(line: InvoiceLineItem) {
  return getLineSubtotal(line) * (Number(line.taxRate) / 100)
}

function clampPercent(value: number) {
  if (!Number.isFinite(value)) {
    return 0
  }

  return Math.min(Math.max(value, 0), 100)
}

type InvoiceToastKind = "success" | "info"

function getToastIcon(kind: InvoiceToastKind) {
  if (kind === "info") {
    return (
      <FileTextIcon className="text-info-foreground size-4 shrink-0" aria-hidden="true" />
    )
  }

  return (
    <CircleCheckIcon className="text-success size-4 shrink-0" aria-hidden="true" />
  )
}

function ToastTitle({ icon, children }: { icon: ReactNode; children: string }) {
  return (
    <span className="flex items-center gap-2">
      {icon}
      <span className="min-w-0">{children}</span>
    </span>
  )
}

function ToastDescription({ children }: { children: string }) {
  return (
    <span className="grid grid-cols-[1rem_1fr] gap-2">
      <span aria-hidden="true" />
      <span>{children}</span>
    </span>
  )
}

function showInvoiceToast(
  title: string,
  description: string,
  kind: InvoiceToastKind = "success"
) {
  const toastTitle = <ToastTitle icon={getToastIcon(kind)}>{title}</ToastTitle>
  const options = {
    description: <ToastDescription>{description}</ToastDescription>,
    icon: null,
  }

  if (kind === "info") {
    toast.message(toastTitle, options)
    return
  }

  toast.success(toastTitle, options)
}

function InvoiceSelectField({
  id,
  label,
  value,
  options,
  onValueChange,
}: {
  id: string
  label: string
  value: string
  options: SelectOption[]
  onValueChange: (value: string) => void
}) {
  return (
    <Field>
      <FieldLabel htmlFor={id}>{label}</FieldLabel>
      <Select
        value={value}
        onValueChange={(nextValue) => nextValue && onValueChange(nextValue)}
      >
        <SelectTrigger id={id} className="w-full">
          <SelectValue>{getOptionLabel(options, value)}</SelectValue>
        </SelectTrigger>
        <SelectContent className="w-(--anchor-width)">
          <SelectGroup>
            {options.map((option) => (
              <SelectItem key={option.value} value={option.value}>
                {option.label}
              </SelectItem>
            ))}
          </SelectGroup>
        </SelectContent>
      </Select>
    </Field>
  )
}

function InvoiceFieldHint({
  label,
  children,
}: {
  label: string
  children: string
}) {
  return (
    <Tooltip>
      <TooltipTrigger
        render={
          <Button
            type="button"
            variant="ghost"
            size="icon-xs"
            className="text-muted-foreground hover:text-foreground -my-1"
            aria-label={label}
          />
        }
      >
        <InfoIcon aria-hidden="true" />
      </TooltipTrigger>
      <TooltipContent side="top" className="max-w-64 text-xs leading-relaxed">
        {children}
      </TooltipContent>
    </Tooltip>
  )
}

function InvoiceFieldLabel({
  htmlFor,
  children,
  hint,
}: {
  htmlFor: string
  children: string
  hint?: string
}) {
  return (
    <div className="flex items-center gap-1.5">
      <FieldLabel htmlFor={htmlFor}>{children}</FieldLabel>
      {hint ? (
        <InvoiceFieldHint label={`${children} info`}>{hint}</InvoiceFieldHint>
      ) : null}
    </div>
  )
}

export function InvoiceCreator() {
  const nextLineId = useRef(DEFAULT_INVOICE_LINES.length + 1)
  const [lineItems, setLineItems] = useState(() => DEFAULT_INVOICE_LINES)
  const [issueDate, setIssueDate] = useState(
    () => new Date(DEFAULT_INVOICE_FORM_VALUES.issueDate)
  )
  const [dueDate, setDueDate] = useState(
    () => new Date(DEFAULT_INVOICE_FORM_VALUES.dueDate)
  )
  const [currency, setCurrency] = useState<string>(
    DEFAULT_INVOICE_FORM_VALUES.currency
  )
  const [paymentTerms, setPaymentTerms] = useState<string>(
    DEFAULT_INVOICE_FORM_VALUES.paymentTerms
  )
  const [collectionMethod, setCollectionMethod] = useState<string>(
    DEFAULT_INVOICE_FORM_VALUES.collectionMethod
  )
  const [discountPercent, setDiscountPercent] = useState<number>(
    DEFAULT_INVOICE_FORM_VALUES.discountPercent
  )

  const subtotal = lineItems.reduce(
    (total, line) => total + getLineSubtotal(line),
    0
  )
  const discountAmount = subtotal * (discountPercent / 100)
  const taxAmount = lineItems.reduce(
    (total, line) => total + getLineTax(line),
    0
  )
  const total = Math.max(subtotal - discountAmount + taxAmount, 0)

  const handleSubmit = (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault()

    showInvoiceToast(
      "Invoice ready to send",
      "The PDF, payment link, and customer email are queued."
    )
  }

  const handleAddLineItem = () => {
    const id = `line-${nextLineId.current}`
    nextLineId.current += 1

    setLineItems((items) => [...items, createInvoiceLine(id)])
  }

  const handleRemoveLineItem = (id: string) => {
    setLineItems((items) =>
      items.length === 1 ? items : items.filter((item) => item.id !== id)
    )
  }

  const handleProductChange = (id: string, productId: string) => {
    const product = PRODUCT_BY_ID.get(productId) ?? INVOICE_PRODUCTS[0]

    setLineItems((items) =>
      items.map((item) =>
        item.id === id
          ? {
              ...item,
              productId,
              unitPrice: product.unitPrice,
              taxRate: product.taxRate,
            }
          : item
      )
    )
  }

  const updateLineItem = (
    id: string,
    updates: Partial<
      Pick<InvoiceLineItem, "quantity" | "unitPrice" | "taxRate">
    >
  ) => {
    setLineItems((items) =>
      items.map((item) => (item.id === id ? { ...item, ...updates } : item))
    )
  }

  return (
    <TooltipProvider delay={200}>
      <div className="bg-background flex min-h-svh w-full flex-col">
        <InvoiceToolbar
          formId={FORM_ID}
          onFeedback={() =>
            showInvoiceToast(
              "Feedback panel opened",
              "Share invoice flow notes before this draft is sent.",
              "info"
            )
          }
          onSaveDraft={() =>
            showInvoiceToast(
              "Invoice draft saved",
              "Line items and payment terms were stored locally."
            )
          }
        />

        {/* Content */}
        <main className="flex flex-1 justify-center px-4 py-7 sm:px-8 sm:py-9 lg:px-10">
          <form
            id={FORM_ID}
            onSubmit={handleSubmit}
            className="w-full max-w-5xl"
          >
            <Card className="gap-0 p-0">
              {/* Header */}
              <CardHeader className="gap-1 px-5 py-5 sm:px-6">
                <CardTitle>Invoice Details</CardTitle>
                <CardDescription>
                  Customer, terms, items, and payment notes.
                </CardDescription>
                <CardAction className="flex items-center gap-1.5 self-center">
                  <Badge variant={INVOICE_STATUS_BADGE.variant}>
                    <ReceiptIcon aria-hidden="true" />
                    {INVOICE_STATUS_BADGE.label}
                  </Badge>
                  <Badge
                    variant="primary-outline"
                    className="hidden sm:inline-flex"
                  >
                    {getOptionLabel(CURRENCY_OPTIONS, currency)}
                  </Badge>
                </CardAction>
              </CardHeader>

              <Separator />

              {/* Form */}
              <CardContent className="flex flex-col gap-7 px-5 py-5 sm:px-6 sm:py-6">
                <FieldSet className="gap-0">
                  <FieldLegend className="sr-only">
                    Invoice creation form
                  </FieldLegend>
                  <FieldDescription className="sr-only">
                    Create a customer invoice with billing terms, line items,
                    and payment notes.
                  </FieldDescription>

                  <FieldGroup className="gap-7">
                    <InvoiceSection
                      title="Customer"
                      description="Billable account and invoice reference."
                      badge="Required"
                      badgeVariant="success-light"
                    >
                      <FieldGroup className="grid gap-4 md:grid-cols-2">
                        <Field>
                          <InvoiceFieldLabel
                            htmlFor="form-3-customer"
                            hint="This customer becomes the bill-to record on the PDF, email, and payment link."
                          >
                            Customer
                          </InvoiceFieldLabel>
                          <Combobox
                            items={INVOICE_CUSTOMERS}
                            defaultValue={
                              INVOICE_CUSTOMERS.find(
                                (customer) =>
                                  customer.id ===
                                  DEFAULT_INVOICE_FORM_VALUES.customerId
                              ) ?? INVOICE_CUSTOMERS[0]
                            }
                            itemToStringLabel={(customer) => customer.name}
                            itemToStringValue={(customer) => customer.name}
                          >
                            <ComboboxInput
                              id="form-3-customer"
                              placeholder="Find or add customer..."
                              className="w-full"
                              showClear
                            />
                            <ComboboxContent className="w-(--anchor-width) min-w-(--anchor-width)">
                              <ComboboxEmpty>No customers found.</ComboboxEmpty>
                              <ComboboxList>
                                {(customer) => (
                                  <ComboboxItem
                                    key={customer.id}
                                    value={customer}
                                  >
                                    <span className="flex min-w-0 flex-col">
                                      <span className="truncate">
                                        {customer.name}
                                      </span>
                                      <span className="text-muted-foreground truncate text-xs">
                                        {customer.email}
                                      </span>
                                    </span>
                                  </ComboboxItem>
                                )}
                              </ComboboxList>
                            </ComboboxContent>
                          </Combobox>
                        </Field>

                        <Field>
                          <InvoiceFieldLabel
                            htmlFor="form-3-tax-id"
                            hint="Shown for finance teams that match invoices against vendor records."
                          >
                            Tax ID
                          </InvoiceFieldLabel>
                          <InputGroup>
                            <InputGroupAddon>
                              <Building2Icon aria-hidden="true" />
                            </InputGroupAddon>
                            <InputGroupInput
                              id="form-3-tax-id"
                              defaultValue={INVOICE_CUSTOMERS[0].taxId}
                            />
                          </InputGroup>
                        </Field>

                        <Field>
                          <InvoiceFieldLabel
                            htmlFor="form-3-invoice-number"
                            hint="Keep this unique so payment, reconciliation, and customer replies map back cleanly."
                          >
                            Invoice Number
                          </InvoiceFieldLabel>
                          <InputGroup>
                            <InputGroupAddon>
                              <HashIcon aria-hidden="true" />
                            </InputGroupAddon>
                            <InputGroupInput
                              id="form-3-invoice-number"
                              defaultValue={
                                DEFAULT_INVOICE_FORM_VALUES.invoiceNumber
                              }
                            />
                          </InputGroup>
                        </Field>

                        <Field>
                          <FieldLabel htmlFor="form-3-po-number">
                            PO Reference
                          </FieldLabel>
                          <Input
                            id="form-3-po-number"
                            defaultValue={DEFAULT_INVOICE_FORM_VALUES.poNumber}
                          />
                        </Field>
                      </FieldGroup>
                    </InvoiceSection>

                    <Separator />

                    <InvoiceSection
                      title="Terms"
                      description="Dates, currency, and collection method."
                      badge={getOptionLabel(
                        PAYMENT_TERMS_OPTIONS,
                        paymentTerms
                      )}
                      badgeVariant="info-light"
                    >
                      <FieldGroup className="grid gap-4 md:grid-cols-3">
                        <Field>
                          <FieldLabel htmlFor="form-3-issue-date">
                            Issue Date
                          </FieldLabel>
                          <InvoiceDateField
                            id="form-3-issue-date"
                            label="Choose issue date"
                            date={issueDate}
                            onSelect={setIssueDate}
                          />
                        </Field>

                        <Field>
                          <FieldLabel htmlFor="form-3-due-date">
                            Due Date
                          </FieldLabel>
                          <InvoiceDateField
                            id="form-3-due-date"
                            label="Choose due date"
                            date={dueDate}
                            onSelect={setDueDate}
                          />
                        </Field>

                        <InvoiceSelectField
                          id="form-3-currency"
                          label="Currency"
                          value={currency}
                          options={CURRENCY_OPTIONS}
                          onValueChange={setCurrency}
                        />

                        <InvoiceSelectField
                          id="form-3-payment-terms"
                          label="Payment Terms"
                          value={paymentTerms}
                          options={PAYMENT_TERMS_OPTIONS}
                          onValueChange={setPaymentTerms}
                        />

                        <InvoiceSelectField
                          id="form-3-collection-method"
                          label="Collection"
                          value={collectionMethod}
                          options={COLLECTION_METHOD_OPTIONS}
                          onValueChange={setCollectionMethod}
                        />

                        <Field>
                          <FieldLabel htmlFor="form-3-billing-address">
                            Billing Address
                          </FieldLabel>
                          <Input
                            id="form-3-billing-address"
                            defaultValue={INVOICE_CUSTOMERS[0].billingAddress}
                          />
                        </Field>
                      </FieldGroup>
                    </InvoiceSection>

                    <Separator />

                    <InvoiceSection
                      title="Line Items"
                      description="Products, services, quantity, tax, and amount."
                      badge={`${lineItems.length} item${lineItems.length === 1 ? "" : "s"}`}
                      badgeVariant="secondary"
                      action={
                        <Button
                          type="button"
                          variant="outline"
                          onClick={handleAddLineItem}
                        >
                          <PlusIcon data-icon="inline-start" aria-hidden="true" />
                          Add item
                        </Button>
                      }
                    >
                      <InvoiceLineItems
                        items={lineItems}
                        currency={currency}
                        onProductChange={handleProductChange}
                        onQuantityChange={(id, quantity) =>
                          updateLineItem(id, {
                            quantity: Math.max(quantity, 1),
                          })
                        }
                        onUnitPriceChange={(id, unitPrice) =>
                          updateLineItem(id, {
                            unitPrice: Math.max(unitPrice, 0),
                          })
                        }
                        onTaxRateChange={(id, taxRate) =>
                          updateLineItem(id, { taxRate })
                        }
                        onRemoveItem={handleRemoveLineItem}
                      />
                    </InvoiceSection>

                    <Separator />

                    <InvoiceSection
                      title="Notes"
                      description="Customer-facing memo and payment footer."
                      badge="Optional"
                      badgeVariant="secondary"
                    >
                      <FieldGroup className="grid gap-4 md:grid-cols-2">
                        <Field>
                          <FieldLabel htmlFor="form-3-memo">Memo</FieldLabel>
                          <Textarea
                            id="form-3-memo"
                            defaultValue={DEFAULT_INVOICE_FORM_VALUES.memo}
                          />
                        </Field>
                        <Field>
                          <FieldLabel htmlFor="form-3-footer-note">
                            Footer Note
                          </FieldLabel>
                          <Textarea
                            id="form-3-footer-note"
                            defaultValue={
                              DEFAULT_INVOICE_FORM_VALUES.footerNote
                            }
                          />
                        </Field>
                      </FieldGroup>
                    </InvoiceSection>
                  </FieldGroup>
                </FieldSet>
              </CardContent>

              {/* Summary */}
              <CardFooter className="flex-col items-stretch gap-4 px-5 py-5 sm:px-6">
                <InvoiceSummary
                  subtotal={subtotal}
                  discountPercent={discountPercent}
                  discountAmount={discountAmount}
                  taxAmount={taxAmount}
                  total={total}
                  currency={currency}
                  onDiscountChange={(value) =>
                    setDiscountPercent(clampPercent(value))
                  }
                />
              </CardFooter>
            </Card>
          </form>
        </main>
      </div>
    </TooltipProvider>
  )
}