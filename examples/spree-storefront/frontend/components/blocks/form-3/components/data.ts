import { type BadgeProps } from "@/components/reui/badge"

export type SelectOption = {
  value: string
  label: string
}

export type InvoiceCustomer = {
  id: string
  name: string
  email: string
  taxId: string
  billingAddress: string
}

export type InvoiceProduct = {
  id: string
  name: string
  description: string
  unitPrice: number
  taxRate: string
}

export type InvoiceLineItem = {
  id: string
  productId: string
  quantity: number
  unitPrice: number
  taxRate: string
}

export const INVOICE_STATUS_BADGE: {
  label: string
  variant: BadgeProps["variant"]
} = {
  label: "Draft",
  variant: "warning-light",
}

export const DEFAULT_INVOICE_FORM_VALUES = {
  customerId: "orchid-ledger",
  invoiceNumber: "INV-2048",
  poNumber: "PO-7418",
  issueDate: "2026-04-24",
  dueDate: "2026-05-08",
  currency: "usd",
  paymentTerms: "net-14",
  collectionMethod: "ach",
  discountPercent: 3,
  memo: "Thanks for partnering with us. Please include the invoice number with payment.",
  footerNote: "Bank transfer and card payment are both supported.",
} as const

export const INVOICE_CUSTOMERS: InvoiceCustomer[] = [
  {
    id: "orchid-ledger",
    name: "Orchid Ledger Group",
    email: "billing@orchidledger.example",
    taxId: "US-88-2947135",
    billingAddress: "14 Warren Street, Suite 620, New York, NY",
  },
  {
    id: "lumenfield",
    name: "Lumenfield Advisory",
    email: "finance@lumenfield.example",
    taxId: "US-31-6084291",
    billingAddress: "221 Mission Row, Chicago, IL",
  },
  {
    id: "kestrel-works",
    name: "Kestrel Works Studio",
    email: "ops@kestrelworks.example",
    taxId: "GB-904-1742-23",
    billingAddress: "7 Brewer Lane, London, UK",
  },
]

export const INVOICE_PRODUCTS: InvoiceProduct[] = [
  {
    id: "implementation-retainer",
    name: "Implementation retainer",
    description: "Onboarding, data mapping, and launch support",
    unitPrice: 4800,
    taxRate: "8.25",
  },
  {
    id: "analytics-migration",
    name: "Analytics migration sprint",
    description: "Warehouse audit and dashboard migration",
    unitPrice: 3200,
    taxRate: "8.25",
  },
  {
    id: "priority-support",
    name: "Priority support block",
    description: "Ten prepaid support hours with 1-day SLA",
    unitPrice: 950,
    taxRate: "0",
  },
  {
    id: "systems-audit",
    name: "Design systems audit",
    description: "Component inventory and implementation report",
    unitPrice: 1800,
    taxRate: "8.25",
  },
]

export const PRODUCT_BY_ID = new Map(
  INVOICE_PRODUCTS.map((product) => [product.id, product])
)

export const DEFAULT_INVOICE_LINES: InvoiceLineItem[] = [
  {
    id: "line-1",
    productId: "implementation-retainer",
    quantity: 1,
    unitPrice: 4800,
    taxRate: "8.25",
  },
  {
    id: "line-2",
    productId: "priority-support",
    quantity: 2,
    unitPrice: 950,
    taxRate: "0",
  },
]

export const CURRENCY_OPTIONS: SelectOption[] = [
  { value: "usd", label: "USD" },
  { value: "eur", label: "EUR" },
  { value: "gbp", label: "GBP" },
]

export const PAYMENT_TERMS_OPTIONS: SelectOption[] = [
  { value: "due-receipt", label: "Due on receipt" },
  { value: "net-7", label: "Net 7" },
  { value: "net-14", label: "Net 14" },
  { value: "net-30", label: "Net 30" },
]

export const COLLECTION_METHOD_OPTIONS: SelectOption[] = [
  { value: "ach", label: "ACH transfer" },
  { value: "card", label: "Card payment" },
  { value: "wire", label: "Wire transfer" },
  { value: "manual", label: "Manual collection" },
]

export const TAX_RATE_OPTIONS: SelectOption[] = [
  { value: "0", label: "No tax" },
  { value: "5", label: "5%" },
  { value: "8.25", label: "8.25%" },
  { value: "10", label: "10%" },
]

export function createInvoiceLine(id: string): InvoiceLineItem {
  const product = INVOICE_PRODUCTS[0]

  return {
    id,
    productId: product.id,
    quantity: 1,
    unitPrice: product.unitPrice,
    taxRate: product.taxRate,
  }
}