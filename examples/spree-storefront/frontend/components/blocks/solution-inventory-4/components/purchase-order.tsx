"use client"

import { useRef, useState, type ReactNode } from "react"
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
  Field,
  FieldDescription,
  FieldGroup,
  FieldLabel,
  FieldLegend,
  FieldSet,
} from "@/components/ui/field"
import { Input } from "@/components/ui/input"
import {
  Select,
  SelectContent,
  SelectGroup,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select"
import { Separator } from "@/components/ui/separator"
import { TooltipProvider } from "@/components/ui/tooltip"
import {
  COSTING_OPTIONS,
  createPoLine,
  DEFAULT_PO_FORM_VALUES,
  DEFAULT_PO_LINES,
  PO_ACTIVITY_EVENTS,
  PO_PRODUCTS,
  PO_STATUS_BADGE,
  PO_SUPPLIERS,
  PRODUCT_BY_ID,
  TAX_RATE,
  WAREHOUSE_OPTIONS,
  type IPoActivityEvent,
  type PoLineItem,
  type PoStatus,
  type SelectOption,
} from "./data"
import { PoActivity } from "./po-activity"
import { PoDateField } from "./po-date-field"
import { PoLineItems } from "./po-line-items"
import { PoSection } from "./po-section"
import { PoSummary } from "./po-summary"
import { PoToolbar } from "./po-toolbar"
import { FileTextIcon, CircleCheckIcon, ReceiptTextIcon, PlusIcon } from "lucide-react"

function getOptionLabel(options: SelectOption[], value: string) {
  return options.find((option) => option.value === value)?.label ?? value
}

function getLineSubtotal(line: PoLineItem) {
  return line.received * line.unitCost
}

function deriveStatus(lines: PoLineItem[], submitted: boolean): PoStatus {
  if (!submitted) {
    return "Draft"
  }

  const received = lines.reduce((sum, line) => sum + line.received, 0)
  const ordered = lines.reduce((sum, line) => sum + line.ordered, 0)

  if (received === 0) {
    return "Submitted"
  }

  return received >= ordered ? "Received" : "Partially received"
}

type PoToastKind = "success" | "info"

function getToastIcon(kind: PoToastKind) {
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

function showPoToast(
  title: string,
  description: string,
  kind: PoToastKind = "success"
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

function PoSelectField({
  id,
  label,
  value,
  options,
  disabled,
  onValueChange,
}: {
  id: string
  label: string
  value: string
  options: SelectOption[]
  disabled?: boolean
  onValueChange: (value: string) => void
}) {
  return (
    <Field>
      <FieldLabel htmlFor={id}>{label}</FieldLabel>
      <Select
        value={value}
        disabled={disabled}
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

export function PurchaseOrder() {
  const nextLineId = useRef(DEFAULT_PO_LINES.length + 1)
  const nextActivityId = useRef(PO_ACTIVITY_EVENTS.length + 1)
  const [submitted, setSubmitted] = useState(false)
  const [lineItems, setLineItems] = useState(() => DEFAULT_PO_LINES)
  const [orderDate, setOrderDate] = useState(
    () => new Date(DEFAULT_PO_FORM_VALUES.orderDate)
  )
  const [expectedDate, setExpectedDate] = useState(
    () => new Date(DEFAULT_PO_FORM_VALUES.expectedDate)
  )
  const [warehouse, setWarehouse] = useState<string>(
    DEFAULT_PO_FORM_VALUES.warehouse
  )
  const [costing, setCosting] = useState<string>(DEFAULT_PO_FORM_VALUES.costing)
  const [freight, setFreight] = useState<number>(DEFAULT_PO_FORM_VALUES.freight)
  const [activity, setActivity] = useState<IPoActivityEvent[]>(
    () => PO_ACTIVITY_EVENTS
  )
  const [note, setNote] = useState("Check pallet seal before close.")

  const supplier = PO_SUPPLIERS[0]
  const editable = !submitted
  const status = deriveStatus(lineItems, submitted)

  const subtotal = lineItems.reduce(
    (total, line) => total + getLineSubtotal(line),
    0
  )
  const taxAmount = (subtotal + freight) * TAX_RATE
  const total = subtotal + freight + taxAmount
  const orderedUnits = lineItems.reduce((sum, line) => sum + line.ordered, 0)
  const receivedUnits = lineItems.reduce((sum, line) => sum + line.received, 0)

  const handleToolbarAction = () => {
    if (editable) {
      setSubmitted(true)
      showPoToast(
        "Order submitted",
        `PO-2041 sent to ${supplier.name} for ${orderedUnits} units. Expected Jun 19.`
      )
      return
    }

    setLineItems((items) =>
      items.map((item) => ({ ...item, received: item.ordered }))
    )
    showPoToast(
      "Receipt posted",
      `All ${orderedUnits} units received into Main Warehouse. PO-2041 closed.`
    )
  }

  const handleAddLineItem = () => {
    const id = `line-${nextLineId.current}`
    nextLineId.current += 1

    setLineItems((items) => [...items, createPoLine(id)])
  }

  const handleRemoveLineItem = (id: string) => {
    setLineItems((items) =>
      items.length === 1 ? items : items.filter((item) => item.id !== id)
    )
  }

  const handleProductChange = (id: string, productId: string) => {
    const product = PRODUCT_BY_ID.get(productId) ?? PO_PRODUCTS[0]

    setLineItems((items) =>
      items.map((item) =>
        item.id === id
          ? { ...item, productId, unitCost: product.unitCost }
          : item
      )
    )
  }

  const handleReceivedChange = (id: string, received: number) => {
    setLineItems((items) =>
      items.map((item) =>
        item.id === id
          ? {
              ...item,
              received: Math.min(Math.max(received, 0), item.ordered),
            }
          : item
      )
    )
  }

  const updateLineItem = (
    id: string,
    updates: Partial<Pick<PoLineItem, "unitCost">>
  ) => {
    setLineItems((items) =>
      items.map((item) => (item.id === id ? { ...item, ...updates } : item))
    )
  }

  const handleAddNote = () => {
    const text = note.trim()
    if (text.length === 0) {
      return
    }

    const id = nextActivityId.current
    nextActivityId.current += 1

    setActivity((events) => [
      {
        id,
        title: "Note Added",
        actor: "Mira Stone",
        time: "Just now",
        description: text,
        status: "completed",
        tone: "Note",
      },
      ...events,
    ])
    setNote("")
    showPoToast("Note added", "Saved to the PO-2041 activity log for the team.")
  }

  return (
    <TooltipProvider delay={200}>
      <div className="bg-background flex min-h-svh w-full flex-col">
        <PoToolbar
          poNumber={DEFAULT_PO_FORM_VALUES.poNumber}
          status={status}
          editable={editable}
          onPrint={() =>
            showPoToast(
              "Print queued",
              "PO-2041 packing sheet sent to the warehouse printer.",
              "info"
            )
          }
          onExport={() =>
            showPoToast(
              "Export ready",
              "PO-2041 line detail exported as CSV with received quantities."
            )
          }
          onSubmit={handleToolbarAction}
        />

        {/* Content */}
        <main className="flex flex-1 justify-center px-4 py-7 sm:px-8 sm:py-9 lg:px-10">
          <div className="grid w-full max-w-6xl gap-6 lg:grid-cols-[1fr_22rem] lg:items-start">
            <Card className="gap-0 p-0">
              {/* Header */}
              <CardHeader className="gap-1 px-5 py-5 sm:px-6">
                <CardTitle className="tabular-nums">
                  {DEFAULT_PO_FORM_VALUES.poNumber}
                </CardTitle>
                <CardDescription className="flex flex-col gap-0.5 sm:flex-row sm:items-center sm:gap-1.5">
                  <span>{supplier.name}</span>
                  <span
                    aria-hidden="true"
                    className="bg-muted-foreground/40 hidden size-1 shrink-0 rounded-full sm:block"
                  />
                  <span className="tabular-nums">
                    {receivedUnits} of {orderedUnits} units received
                  </span>
                </CardDescription>
                <CardAction className="flex items-center gap-1.5 self-center">
                  <Badge variant={PO_STATUS_BADGE[status]}>
                    <ReceiptTextIcon aria-hidden="true" />
                    {status}
                  </Badge>
                </CardAction>
              </CardHeader>

              <Separator />

              {/* Form */}
              <CardContent className="flex flex-col gap-7 px-5 py-5 sm:px-6 sm:py-6">
                <FieldSet className="gap-0">
                  <FieldLegend className="sr-only">
                    Purchase order detail
                  </FieldLegend>
                  <FieldDescription className="sr-only">
                    Review the supplier, line items, and receiving status for
                    this purchase order.
                  </FieldDescription>

                  <FieldGroup className="gap-7">
                    <PoSection
                      title="Supplier"
                      description={`${supplier.contact}, active supplier.`}
                      badge={status === "Draft" ? "Editable" : "Locked"}
                      badgeVariant={
                        status === "Draft" ? "success-light" : "secondary"
                      }
                    >
                      <FieldGroup className="grid gap-4 md:grid-cols-2">
                        <Field>
                          <FieldLabel htmlFor="po-supplier">
                            Supplier
                          </FieldLabel>
                          <Input
                            id="po-supplier"
                            defaultValue={supplier.name}
                            disabled={!editable}
                          />
                        </Field>

                        <Field>
                          <FieldLabel htmlFor="po-reference">
                            Reference
                          </FieldLabel>
                          <Input
                            id="po-reference"
                            defaultValue={DEFAULT_PO_FORM_VALUES.reference}
                            disabled={!editable}
                          />
                        </Field>

                        <Field className="md:col-span-2">
                          <FieldLabel htmlFor="po-ship-to">Ship to</FieldLabel>
                          <Input
                            id="po-ship-to"
                            defaultValue={DEFAULT_PO_FORM_VALUES.shipTo}
                            disabled={!editable}
                          />
                        </Field>
                      </FieldGroup>
                    </PoSection>

                    <PoSection
                      title="Terms"
                      description="Dates, dock, and costing."
                      badge={getOptionLabel(WAREHOUSE_OPTIONS, warehouse)}
                      badgeVariant="info-light"
                    >
                      <FieldGroup className="grid gap-4 md:grid-cols-2">
                        <Field>
                          <FieldLabel htmlFor="po-order-date">
                            Order Date
                          </FieldLabel>
                          <PoDateField
                            id="po-order-date"
                            label="Choose order date"
                            date={orderDate}
                            onSelect={setOrderDate}
                          />
                        </Field>

                        <Field>
                          <FieldLabel htmlFor="po-expected-date">
                            Expected Date
                          </FieldLabel>
                          <PoDateField
                            id="po-expected-date"
                            label="Choose expected date"
                            date={expectedDate}
                            onSelect={setExpectedDate}
                          />
                        </Field>

                        <PoSelectField
                          id="po-warehouse"
                          label="Destination"
                          value={warehouse}
                          options={WAREHOUSE_OPTIONS}
                          disabled={!editable}
                          onValueChange={setWarehouse}
                        />

                        <PoSelectField
                          id="po-costing"
                          label="Costing"
                          value={costing}
                          options={COSTING_OPTIONS}
                          disabled={!editable}
                          onValueChange={setCosting}
                        />
                      </FieldGroup>
                    </PoSection>

                    <Separator />

                    <PoSection
                      title="Line Items"
                      description="Received counts and landed cost."
                      badge={`${lineItems.length} line${lineItems.length === 1 ? "" : "s"}`}
                      badgeVariant="secondary"
                      action={
                        editable ? (
                          <Button
                            type="button"
                            variant="outline"
                            onClick={handleAddLineItem}
                          >
                            <PlusIcon data-icon="inline-start" aria-hidden="true" />
                            Add line
                          </Button>
                        ) : undefined
                      }
                    >
                      <PoLineItems
                        items={lineItems}
                        editable={editable}
                        onProductChange={handleProductChange}
                        onReceivedChange={handleReceivedChange}
                        onUnitCostChange={(id, unitCost) =>
                          updateLineItem(id, {
                            unitCost: Math.max(unitCost, 0),
                          })
                        }
                        onRemoveItem={handleRemoveLineItem}
                      />
                    </PoSection>
                  </FieldGroup>
                </FieldSet>
              </CardContent>

              {/* Summary */}
              <CardFooter className="flex-col items-stretch gap-4 px-5 py-5 sm:px-6">
                <PoSummary
                  subtotal={subtotal}
                  freight={freight}
                  taxAmount={taxAmount}
                  total={total}
                  receivedValue={subtotal}
                  editable={editable}
                  onFreightChange={(value) => setFreight(Math.max(value, 0))}
                />
              </CardFooter>
            </Card>

            <PoActivity
              events={activity}
              note={note}
              onNoteChange={setNote}
              onAddNote={handleAddNote}
            />
          </div>
        </main>
      </div>
    </TooltipProvider>
  )
}