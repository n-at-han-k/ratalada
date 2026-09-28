import { type ReactNode } from "react"

import { Apple } from "@/components/ui/svgs/apple"
import { PaypalWordmark } from "@/components/ui/svgs/paypalWordmark"
import { CreditCardIcon } from "lucide-react"

export type CheckoutStepId = "contact" | "delivery" | "payment" | "review"
export type DeliveryOptionId = "standard" | "express" | "pickup"
export type PaymentMethodId = "card" | "paypal" | "apple-pay"
export type AddressId = "home" | "studio"

export type CheckoutStep = {
  id: CheckoutStepId
  step: number
  title: string
  description: string
}

export type CheckoutItem = {
  id: string
  name: string
  category: string
  description: string
  color: string
  size: string
  price: number
  compareAtPrice?: number
  quantity: number
  delivery: string
  image: {
    src: string
    alt: string
  }
  badge?: string
}

export type SavedAddress = {
  id: AddressId
  label: string
  recipient: string
  line1: string
  line2: string
  note: string
  isDefault?: boolean
}

export type DeliveryOption = {
  id: DeliveryOptionId
  label: string
  description: string
  price: number
  eta: string
}

export type PaymentMethod = {
  id: PaymentMethodId
  label: string
  description: string
  mark: ReactNode
}

export type CountryOption = {
  value: string
  code: string
  label: string
}

export type CheckoutValues = {
  email: string
  firstName: string
  lastName: string
  phone: string
  country: string
  addressId: AddressId
  deliveryId: DeliveryOptionId
  paymentMethodId: PaymentMethodId
  cardName: string
  cardNumber: string
  expiry: string
  cvc: string
  loginEmail: string
  loginPassword: string
  createAccount: boolean
  createPassword: string
  emailOffers: boolean
  promoCode: string
  savePayment: boolean
  acceptTerms: boolean
}

export const CHECKOUT_STEPS: CheckoutStep[] = [
  {
    id: "contact",
    step: 1,
    title: "Customer",
    description: "Order updates",
  },
  {
    id: "delivery",
    step: 2,
    title: "Delivery",
    description: "Address and speed",
  },
  {
    id: "payment",
    step: 3,
    title: "Payment",
    description: "Payment method",
  },
  {
    id: "review",
    step: 4,
    title: "Review",
    description: "Final check",
  },
]

export const DEFAULT_CHECKOUT_VALUES: CheckoutValues = {
  email: "morgan.lee@example.com",
  firstName: "Morgan",
  lastName: "Lee",
  phone: "(415) 555-0148",
  country: "US",
  addressId: "home",
  deliveryId: "express",
  paymentMethodId: "card",
  cardName: "Morgan Lee",
  cardNumber: "4242 4242 4242 4242",
  expiry: "08/28",
  cvc: "123",
  loginEmail: "morgan.lee@example.com",
  loginPassword: "",
  createAccount: false,
  createPassword: "",
  emailOffers: false,
  promoCode: "SPRING15",
  savePayment: true,
  acceptTerms: false,
}

export const COUNTRY_OPTIONS: CountryOption[] = [
  { value: "US", code: "us", label: "United States" },
  { value: "CA", code: "ca", label: "Canada" },
  { value: "GB", code: "gb", label: "United Kingdom" },
  { value: "AU", code: "au", label: "Australia" },
  { value: "NZ", code: "nz", label: "New Zealand" },
  { value: "IE", code: "ie", label: "Ireland" },
  { value: "DE", code: "de", label: "Germany" },
  { value: "FR", code: "fr", label: "France" },
  { value: "IT", code: "it", label: "Italy" },
  { value: "ES", code: "es", label: "Spain" },
  { value: "NL", code: "nl", label: "Netherlands" },
  { value: "BE", code: "be", label: "Belgium" },
  { value: "CH", code: "ch", label: "Switzerland" },
  { value: "AT", code: "at", label: "Austria" },
  { value: "SE", code: "se", label: "Sweden" },
  { value: "NO", code: "no", label: "Norway" },
  { value: "DK", code: "dk", label: "Denmark" },
  { value: "FI", code: "fi", label: "Finland" },
  { value: "PT", code: "pt", label: "Portugal" },
]

export const CHECKOUT_ITEMS: CheckoutItem[] = [
  {
    id: "leather-biker-jacket",
    name: "Leather Biker Jacket",
    category: "Studio Outerwear",
    description: "Polished leather with a sharp stance.",
    color: "Black",
    size: "M",
    price: 248,
    quantity: 1,
    delivery: "Ships from Los Angeles",
    image: {
      src: "https://images.unsplash.com/photo-1762160766742-90dbea704e70?auto=format&fit=crop&w=320&h=400&q=80",
      alt: "Black leather biker jacket studio view",
    },
    badge: "New",
  },
  {
    id: "ribbed-tank-set",
    name: "Ribbed Tank Set",
    category: "Travel Essentials",
    description: "Soft tank with tapered pull-on pants.",
    color: "Chalk",
    size: "S",
    price: 86,
    compareAtPrice: 118,
    quantity: 1,
    delivery: "Low stock, reserved in bag",
    image: {
      src: "https://images.unsplash.com/photo-1763499390053-c7067878efd6?auto=format&fit=crop&w=320&h=400&q=80",
      alt: "Ribbed tank set side studio view",
    },
    badge: "Sale",
  },
]

export const SAVED_ADDRESSES: SavedAddress[] = [
  {
    id: "home",
    label: "Home",
    recipient: "Morgan Lee",
    line1: "1428 Valencia Street",
    line2: "San Francisco, CA 94110",
    note: "Leave with front desk after 6 PM.",
    isDefault: true,
  },
  {
    id: "studio",
    label: "Studio",
    recipient: "Morgan Lee",
    line1: "88 Bryant Street, Suite 4B",
    line2: "San Francisco, CA 94105",
    note: "Weekday delivery only.",
  },
]

export const DELIVERY_OPTIONS: DeliveryOption[] = [
  {
    id: "standard",
    label: "Standard",
    description: "Carbon-neutral delivery",
    price: 0,
    eta: "Arrives May 17-19",
  },
  {
    id: "express",
    label: "Express",
    description: "Priority packed today",
    price: 12,
    eta: "Arrives May 14",
  },
  {
    id: "pickup",
    label: "Pickup",
    description: "Hold at partner counter",
    price: 0,
    eta: "Ready tomorrow",
  },
]

export const PAYMENT_METHODS: PaymentMethod[] = [
  {
    id: "card",
    label: "Card",
    description: "Visa, Mastercard, Amex",
    mark: (
      <CreditCardIcon className="size-4" aria-hidden="true" />
    ),
  },
  {
    id: "paypal",
    label: "PayPal",
    description: "Redirect after review",
    mark: <PaypalWordmark className="h-4 w-14" aria-hidden="true" />,
  },
  {
    id: "apple-pay",
    label: "Apple Pay",
    description: "Confirm on this device",
    mark: (
      <span className="flex items-center gap-1 text-sm font-semibold">
        <Apple className="size-3.5" aria-hidden="true" />
        Pay
      </span>
    ),
  },
]

export const PROMO_CODE = "SPRING15"
export const PROMO_DISCOUNT = 18
export const TAX_RATE = 0.0875