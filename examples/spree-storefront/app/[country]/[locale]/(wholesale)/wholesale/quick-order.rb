# frozen_string_literal: true

# reui: form-3, autocomplete
#
# <WholesaleHeader>                           # blocks/navbar-12/navbar, trimmed
# <InvoiceCreator>                            # blocks/form-3/invoice-creator — row-entry shell
#   <InvoiceToolbar>                          # blocks/form-3/invoice-toolbar
#   <InvoiceLineItems>                        # blocks/form-3/invoice-line-items
#     <Autocomplete>                          # reui/autocomplete — SKU lookup
#     <NumberField>                           # reui/number-field — quantity
#     <Button>                                # remove row
#     <Alert>                                 # reui/alert — per-row resolve error
#   <Button>                                  # add row
#   <InvoiceSummary>                          # blocks/form-3/invoice-summary — live totals
#   <Button>                                  # add all to cart

get "/" do
  gate = wholesale_status

  inertia("[country]/[locale]/(wholesale)/wholesale/quick-order", props: {
    gate:     gate,
    customer: gate == "guest" ? nil : wholesale_customer,
    products: gate == "approved" ? wholesale_products : [],
  })
end

# ponytail: nothing to resolve server-side (there's no Store API SKU search
# wired), so this just bounces to the cart -- swap for a real bulk
# add-to-cart call, keyed off the row SKUs the client posts.
post "/" do
  redirect("/wholesale/cart", 303)
end

__END__

import { Form, Head } from "@inertiajs/react"
import { PlusIcon, Trash2Icon } from "lucide-react"
import { useId, useState } from "react"

import {
  WholesaleApplicationPending,
  WholesaleHeader,
  WholesaleSignInWall,
} from "@/components/wholesale"
import {
  Autocomplete,
  AutocompleteContent,
  AutocompleteEmpty,
  AutocompleteInput,
  AutocompleteItem,
  AutocompleteList,
} from "@/components/reui/autocomplete"
import { Alert, AlertDescription } from "@/components/reui/alert"
import {
  NumberField,
  NumberFieldDecrement,
  NumberFieldGroup,
  NumberFieldIncrement,
  NumberFieldInput,
} from "@/components/reui/number-field"
import { Button } from "@/components/ui/button"

interface Product {
  slug: string
  name: string
  sku: string
  case_pack: number
  trade_price: number
}

interface Row {
  id: string
  product: Product | null
  cases: number
}

const money = (value: number) => `$${value.toFixed(2)}`

let rowSeq = 0
const newRow = (): Row => ({id: `row-${(rowSeq += 1)}`, product: null, cases: 1})

function InvoiceLineItems({
  rows,
  products,
  onResolve,
  onQuantityChange,
  onRemove,
}: {
  rows: Row[]
  products: Product[]
  onResolve: (id: string, product: Product) => void
  onQuantityChange: (id: string, cases: number) => void
  onRemove: (id: string) => void
}) {
  return (
    <div className="flex flex-col gap-3">
      {rows.map((row) => {
        const lineTotal = row.product ? row.cases * row.product.case_pack * row.product.trade_price : 0

        return (
          <div key={row.id} className="flex flex-wrap items-start gap-3 rounded-lg border border-slate-200 bg-white p-4">
            <div className="min-w-64 flex-1">
              <Autocomplete
                items={products}
                itemToStringValue={(p: Product) => p?.name ?? ""}
                onValueChange={(value, details) => {
                  // Cleared or free-typed: only a real pick (item click / enter
                  // on a highlighted row) resolves the row.
                  if (details.reason === "item-press" || details.reason === "none") {
                    const match = products.find((p) => p.name === value || p.sku === value)
                    if (match) onResolve(row.id, match)
                  }
                }}
              >
                <AutocompleteInput
                  placeholder="Search by name or SKU…"
                  aria-label={`Product for row ${row.id}`}
                  defaultValue={row.product?.name ?? ""}
                />
                <AutocompleteContent>
                  <AutocompleteEmpty>No matching SKUs</AutocompleteEmpty>
                  <AutocompleteList>
                    {(product: Product) => (
                      <AutocompleteItem key={product.slug} value={product}>
                        {product.name} <span className="text-muted-foreground">· {product.sku}</span>
                      </AutocompleteItem>
                    )}
                  </AutocompleteList>
                </AutocompleteContent>
              </Autocomplete>
              {!row.product && (
                <Alert variant="warning" className="mt-2">
                  <AlertDescription>Pick a product from the list to resolve this row.</AlertDescription>
                </Alert>
              )}
            </div>

            <NumberField
              value={row.cases}
              min={1}
              size="sm"
              onValueChange={(value) => onQuantityChange(row.id, value ?? 1)}
              className="w-32"
            >
              <NumberFieldGroup>
                <NumberFieldDecrement />
                <NumberFieldInput aria-label="Cases" />
                <NumberFieldIncrement />
              </NumberFieldGroup>
            </NumberField>

            <p className="w-24 self-center text-right text-sm font-semibold tabular-nums">
              {row.product ? money(lineTotal) : "—"}
            </p>

            <Button
              type="button"
              variant="ghost"
              size="icon-sm"
              disabled={rows.length === 1}
              onClick={() => onRemove(row.id)}
              aria-label="Remove row"
            >
              <Trash2Icon />
            </Button>
          </div>
        )
      })}
    </div>
  )
}

export default function WholesaleQuickOrder({
  gate,
  customer,
  products,
}: {
  gate: "guest" | "pending" | "approved"
  customer: { name: string; email: string; company: string } | null
  products: Product[]
}) {
  const [rows, setRows] = useState<Row[]>([newRow()])
  const formId = useId()

  if (gate === "guest") {
    return (
      <>
        <Head title="Quick order" />
        <WholesaleSignInWall />
      </>
    )
  }

  if (gate === "pending" && customer) {
    return (
      <>
        <Head title="Quick order" />
        <WholesaleApplicationPending customer={customer} />
      </>
    )
  }

  const total = rows.reduce(
    (sum, row) => sum + (row.product ? row.cases * row.product.case_pack * row.product.trade_price : 0),
    0
  )
  const resolvedCount = rows.filter((row) => row.product).length

  return (
    <div className="min-h-screen bg-slate-50">
      <Head title="Quick order" />
      <WholesaleHeader customerName={customer?.name} />
      <div className="mx-auto max-w-4xl px-4 py-8 sm:px-6 lg:px-8">
        <h1 className="text-3xl font-bold text-slate-900">Quick order</h1>
        <p className="mt-2 text-slate-500">
          Search by product name or SKU and set the case quantity for each row.
        </p>

        <div className="mt-8">
          <InvoiceLineItems
            rows={rows}
            products={products}
            onResolve={(id, product) =>
              setRows((prev) => prev.map((row) => (row.id === id ? {...row, product} : row)))
            }
            onQuantityChange={(id, cases) =>
              setRows((prev) => prev.map((row) => (row.id === id ? {...row, cases} : row)))
            }
            onRemove={(id) => setRows((prev) => (prev.length === 1 ? prev : prev.filter((row) => row.id !== id)))}
          />
        </div>

        <Button
          type="button"
          variant="outline"
          className="mt-3"
          onClick={() => setRows((prev) => [...prev, newRow()])}
        >
          <PlusIcon /> Add row
        </Button>

        <div className="mt-8 rounded-lg border border-slate-200 bg-white p-5">
          <div className="flex justify-between text-sm text-slate-500">
            <span>{resolvedCount} of {rows.length} rows resolved</span>
            <span className="text-base font-semibold text-slate-900 tabular-nums">{money(total)}</span>
          </div>

          <Form id={formId} action="/wholesale/quick-order" method="post" className="mt-4">
            <Button type="submit" size="lg" disabled={resolvedCount === 0} className="w-full bg-slate-900 hover:bg-slate-800">
              Add all to cart
            </Button>
          </Form>
        </div>
      </div>
    </div>
  )
}
