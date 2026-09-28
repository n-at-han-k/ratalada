import { type BadgeProps } from "@/components/reui/badge"

export type SelectOption = {
  value: string
  label: string
}

export type PoStatus =
  | "Draft"
  | "Submitted"
  | "Partially received"
  | "Received"
  | "Closed"

export type PoSupplier = {
  id: string
  name: string
  contact: string
  email: string
  address: string
}

export type PoProduct = {
  id: string
  sku: string
  name: string
  image?: string
  unitCost: number
}

export type PoLineItem = {
  id: string
  productId: string
  ordered: number
  received: number
  unitCost: number
}

export const PO_STATUS_BADGE: Record<PoStatus, BadgeProps["variant"]> = {
  Draft: "secondary",
  Submitted: "warning-light",
  "Partially received": "warning-light",
  Received: "success-light",
  Closed: "secondary",
}

export const DEFAULT_PO_FORM_VALUES = {
  supplierId: "acme-components",
  poNumber: "PO-2041",
  reference: "REQ-0418",
  orderDate: "2026-06-02",
  expectedDate: "2026-06-19",
  warehouse: "main",
  costing: "average",
  shipTo: "Main Warehouse, Dock 4, Bin A-12-04",
  freight: 240,
  memo: "Receive against the dock scan. Flag short ships to Nora Vale before closing the PO.",
} as const

export const PO_SUPPLIERS: PoSupplier[] = [
  {
    id: "acme-components",
    name: "Acme Components",
    contact: "Net 30 terms",
    email: "orders@acme-components.example",
    address: "48 Foundry Road, Newark, NJ",
  },
  {
    id: "northwind-logistics",
    name: "Northwind Logistics",
    contact: "Net 45 terms",
    email: "supply@northwind-logistics.example",
    address: "1200 Harbor Way, Oakland, CA",
  },
  {
    id: "apex-manufacturing",
    name: "Apex Manufacturing",
    contact: "Net 30 terms",
    email: "po@apex-manufacturing.example",
    address: "7 Kiln Street, Austin, TX",
  },
]

export const PO_PRODUCTS: PoProduct[] = [
  {
    id: "auralite-studio-pro",
    sku: "SKU-00482",
    name: "Auralite Studio Pro",
    image:
      "https://images.unsplash.com/photo-1583394838336-acd977736f90?auto=format&fit=crop&w=900&q=80",
    unitCost: 64,
  },
  {
    id: "countertop-wireless-max",
    sku: "SKU-00518",
    name: "Countertop Wireless Max",
    image:
      "https://images.unsplash.com/photo-1693895592595-9171d91a0f22?auto=format&fit=crop&w=900&q=80",
    unitCost: 58,
  },
  {
    id: "graphite-rest-headphones",
    sku: "SKU-00574",
    name: "Graphite Rest Headphones",
    image:
      "https://images.unsplash.com/photo-1740960636034-4bd7003da439?auto=format&fit=crop&w=900&q=80",
    unitCost: 72,
  },
  {
    id: "matte-white-wireless",
    sku: "SKU-00604",
    name: "Matte White Wireless",
    image:
      "https://images.unsplash.com/photo-1625245488600-f03fef636a3c?auto=format&fit=crop&w=900&q=80",
    unitCost: 49,
  },
  {
    id: "soft-black-studio",
    sku: "SKU-00610",
    name: "Soft Black Studio",
    image:
      "https://images.unsplash.com/photo-1753557346714-5bbe6b416861?auto=format&fit=crop&w=900&q=80",
    unitCost: 88,
  },
  {
    id: "minimal-pair-headset",
    sku: "SKU-00618",
    name: "Minimal Pair Headset",
    image:
      "https://images.unsplash.com/photo-1655628143559-d6ab5a201c9c?auto=format&fit=crop&w=900&q=80",
    unitCost: 88,
  },
  {
    id: "noir-archive-headset",
    sku: "SKU-00622",
    name: "Noir Archive Headset",
    image:
      "https://images.unsplash.com/photo-1585298723682-7115561c51b7?auto=format&fit=crop&w=900&q=80",
    unitCost: 88,
  },
]

export const PRODUCT_BY_ID = new Map(
  PO_PRODUCTS.map((product) => [product.id, product])
)

export const DEFAULT_PO_LINES: PoLineItem[] = [
  {
    id: "line-1",
    productId: "auralite-studio-pro",
    ordered: 120,
    received: 120,
    unitCost: 64,
  },
  {
    id: "line-2",
    productId: "countertop-wireless-max",
    ordered: 80,
    received: 40,
    unitCost: 58,
  },
  {
    id: "line-3",
    productId: "soft-black-studio",
    ordered: 60,
    received: 0,
    unitCost: 88,
  },
  {
    id: "line-4",
    productId: "matte-white-wireless",
    ordered: 96,
    received: 96,
    unitCost: 49,
  },
]

export const WAREHOUSE_OPTIONS: SelectOption[] = [
  { value: "main", label: "Main Warehouse" },
  { value: "east-dc", label: "East DC" },
  { value: "store-brooklyn", label: "Store-Brooklyn" },
]

export const COSTING_OPTIONS: SelectOption[] = [
  { value: "average", label: "Average cost" },
  { value: "fifo", label: "FIFO" },
]

export const TAX_RATE = 0.0825

export function createPoLine(id: string): PoLineItem {
  const product = PO_PRODUCTS[0]

  return {
    id,
    productId: product.id,
    ordered: 1,
    received: 0,
    unitCost: product.unitCost,
  }
}

// ── Activity timeline (reused from application/timeline/timeline-1) ────────────

export type PoActivityStatus = "completed" | "active" | "pending"

export interface IPoActivityEvent {
  id: number
  title: string
  actor: string
  time: string
  description: string
  status: PoActivityStatus
  tone: "Received" | "Submitted" | "Note"
}

export const PO_ACTIVITY_EVENTS: IPoActivityEvent[] = [
  {
    id: 1,
    title: "Partial Receipt Logged",
    actor: "Alex Johnson",
    time: "Jun 16, 10:24",
    description: "256 units scanned. Soft Black remains backordered.",
    status: "active",
    tone: "Received",
  },
  {
    id: 2,
    title: "Order Submitted",
    actor: "Nora Vale",
    time: "Jun 02, 14:08",
    description: "356 units sent, due Jun 19.",
    status: "completed",
    tone: "Submitted",
  },
  {
    id: 3,
    title: "Draft Created",
    actor: "Mira Stone",
    time: "Jun 01, 09:15",
    description: "Four reorder alerts created the draft.",
    status: "completed",
    tone: "Note",
  },
]

export const poActivityToneDotClass: Record<IPoActivityEvent["tone"], string> =
  {
    Received: "bg-emerald-500",
    Submitted: "bg-amber-500",
    Note: "bg-sky-500",
  }

export const poActivityToneBadgeVariant: Record<
  IPoActivityEvent["tone"],
  BadgeProps["variant"]
> = {
  Received: "success-light",
  Submitted: "warning-light",
  Note: "info-light",
}

export const poActivityStatusDotClass: Record<PoActivityStatus, string> = {
  completed: "bg-success",
  active: "bg-info",
  pending: "bg-muted-foreground/50",
}