# frozen_string_literal: true

# reui: checkout-5, form-6, shopping-cart-4
#
# <Checkout>                                  # blocks/checkout-5/checkout
#   <Alert>                                   # reui/alert
#   <Button>                                  # express: ui/svgs/apple, ui/svgs/paypalWordmark
#   <Field>
#     <Input>                                 # email
#   <RadioGroup>                              # saved addresses
#   <Field>                                   # address form rows, from the block
#     <Input>
#   <Select>                                  # country / state
#   <EditSectionDialog>                       # blocks/form-6/edit-section-dialog — edit address
#   <RadioGroup>                              # delivery method
#   <RadioGroup>                              # payment method
#     <StripePaymentForm>                     # mount point, no reui source
#     <PayPalPaymentForm>
#   <Checkbox>                                # billing same as shipping
#   <Checkbox>                                # policy consent
#   <Button>                                  # place order
# <OrderSummary>                              # blocks/shopping-cart-4/order-summary
#   <InputGroup>                              # coupon code

# ponytail: fixture props, swap for the Spree Store API call when it is wired.
# One order per demo, matching the reference storefront's checkout shape:
# a saved address, delivery options, and the totals the (checkout) layout's
# sidebar reads off `order`.
def fixture_order
  {
    id:               params["id"],
    email:            "jordan@example.com",
    saved_addresses:  [
      {
        id: "home", label: "Home", recipient: "Jordan Reeves",
        line1: "180 Bedford Avenue", line2: "Apt 4F",
        city: "Brooklyn", state: "NY", zip: "11211", country: "US",
      },
    ],
    delivery_options: [
      { id: "standard", label: "Standard", description: "3-5 business days", price_display: "Free" },
      { id: "express", label: "Express", description: "1-2 business days", price_display: "$12.00" },
    ],
    display_item_total:     "$243.27",
    display_delivery_total: "$0.00",
    display_tax_total:      "$17.03",
    display_total:          "$260.30",
  }
end

def fixture_countries
  [{ code: "US", label: "United States" }, { code: "CA", label: "Canada" }, { code: "GB", label: "United Kingdom" }]
end

get "/" do
  inertia("[country]/[locale]/(checkout)/checkout/[id]", props: {
    order:     fixture_order,
    countries: fixture_countries,
    # Picked up from the confirm-payment redirect when a gateway round-trip fails.
    payment_error: params["payment_error"],
  })
end

# Single mutating route for the whole flow (address save, delivery/payment
# pick, place order) — nothing here is persisted, there's no Spree backend
# wired up yet, so it just validates the required fields and moves on.
post "/" do
  if params["email"].to_s.strip.empty?
    page_errors(email: "Enter an email address")
    redirect(request.path, 303)
  elsif !params.key?("accept_policy")
    page_errors(accept_policy: "You must accept the policies to continue")
    redirect(request.path, 303)
  else
    # ponytail: swap for the Store API order-complete call. The card/PayPal
    # mount points below don't run a real charge, so this always "succeeds".
    redirect("/#{params['country']}/#{params['locale']}/order-placed/#{params['id']}", 303)
  end
end

__END__

import { Form, Head, usePage } from "@inertiajs/react"
import { useState } from "react"
import { Apple } from "@/components/ui/svgs/apple"
import { PaypalWordmark } from "@/components/ui/svgs/paypalWordmark"

import { Alert, AlertDescription, AlertTitle } from "@/components/reui/alert"
import { Button } from "@/components/ui/button"
import { Checkbox } from "@/components/ui/checkbox"
import {
  Dialog,
  DialogContent,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog"
import { Field, FieldError, FieldGroup, FieldLabel } from "@/components/ui/field"
import { Input } from "@/components/ui/input"
import { RadioGroup, RadioGroupItem } from "@/components/ui/radio-group"
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select"
import { CircleAlertIcon, CreditCardIcon, PencilIcon } from "lucide-react"

interface Address {
  id: string
  label: string
  recipient: string
  line1: string
  line2: string
  city: string
  state: string
  zip: string
  country: string
}

interface Order {
  id: string
  email: string
  saved_addresses: Address[]
  delivery_options: { id: string; label: string; description: string; price_display: string }[]
}

// Small standalone edit dialog, in the spirit of form-6's EditSectionDialog
// (that one edits business-verification fields, so it doesn't fit an
// address — this is a from-scratch address version of the same pattern).
function EditAddressDialog({ address }: { address: Address }) {
  return (
    <Dialog>
      <DialogTrigger
        render={
          <Button type="button" variant="ghost" size="icon-sm" aria-label="Edit address" />
        }
      >
        <PencilIcon aria-hidden="true" />
      </DialogTrigger>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Edit Address</DialogTitle>
        </DialogHeader>
        <FieldGroup>
          <Field>
            <FieldLabel>Address line 1</FieldLabel>
            <Input name="edit_line1" defaultValue={address.line1} />
          </Field>
          <Field>
            <FieldLabel>Address line 2</FieldLabel>
            <Input name="edit_line2" defaultValue={address.line2} />
          </Field>
        </FieldGroup>
        <DialogFooter>
          {/* ponytail: not wired to a save call — the checkout form below owns the real submit. */}
          <Button type="button">Save</Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  )
}

export default function Checkout({ order, countries, payment_error }: {
  order: Order
  countries: { code: string; label: string }[]
  payment_error?: string | null
}) {
  const { errors } = usePage().props as { errors?: Record<string, string> }
  const [paymentMethod, setPaymentMethod] = useState<"card" | "paypal">("card")
  const [billingSameAsShipping, setBillingSameAsShipping] = useState(true)
  const address = order.saved_addresses[0]

  return (
    <>
      <Head title="Checkout" />

      {payment_error ? (
        <Alert variant="destructive" className="mb-6">
          <CircleAlertIcon />
          <AlertTitle>Payment failed</AlertTitle>
          <AlertDescription>{payment_error}</AlertDescription>
        </Alert>
      ) : null}

      {/* ponytail: real Apple Pay / PayPal SDKs are not wired — icons only, mount point for later. */}
      <div className="mb-6 grid grid-cols-2 gap-3">
        <Button type="button" variant="outline" disabled>
          <Apple className="size-4" aria-hidden="true" />
          Pay
        </Button>
        <Button type="button" variant="outline" disabled>
          <PaypalWordmark className="h-4 w-14" aria-hidden="true" />
        </Button>
      </div>

      <Form action={`/checkout/${order.id}`} method="post" className="flex flex-col gap-8">
        <fieldset className="flex flex-col gap-4">
          <legend className="text-foreground mb-2 text-sm font-semibold">Contact</legend>
          <Field data-invalid={!!errors?.email}>
            <FieldLabel htmlFor="email">Email</FieldLabel>
            <Input id="email" name="email" type="email" defaultValue={order.email} required />
            {errors?.email ? <FieldError>{errors.email}</FieldError> : null}
          </Field>
        </fieldset>

        <fieldset className="flex flex-col gap-4">
          <legend className="text-foreground mb-2 text-sm font-semibold">Shipping address</legend>
          {address ? (
            <RadioGroup name="address_id" defaultValue={address.id}>
              <label className="flex items-start gap-3 rounded-md border p-4">
                <RadioGroupItem value={address.id} className="mt-0.5" />
                <span className="flex-1 text-sm">
                  <span className="text-foreground block font-medium">{address.label}</span>
                  <span className="text-muted-foreground block">
                    {address.recipient} · {address.line1}
                    {address.line2 ? `, ${address.line2}` : ""} · {address.city}, {address.state}{" "}
                    {address.zip}
                  </span>
                </span>
                <EditAddressDialog address={address} />
              </label>
            </RadioGroup>
          ) : null}

          <FieldGroup className="grid gap-4 sm:grid-cols-2">
            <Field>
              <FieldLabel htmlFor="first_name">First name</FieldLabel>
              <Input id="first_name" name="first_name" defaultValue={address?.recipient.split(" ")[0]} required />
            </Field>
            <Field>
              <FieldLabel htmlFor="last_name">Last name</FieldLabel>
              <Input id="last_name" name="last_name" defaultValue={address?.recipient.split(" ").slice(1).join(" ")} required />
            </Field>
            <Field className="sm:col-span-2">
              <FieldLabel htmlFor="address1">Address</FieldLabel>
              <Input id="address1" name="address1" defaultValue={address?.line1} required />
            </Field>
            <Field className="sm:col-span-2">
              <FieldLabel htmlFor="address2">Apt, suite, etc. (optional)</FieldLabel>
              <Input id="address2" name="address2" defaultValue={address?.line2} />
            </Field>
            <Field>
              <FieldLabel htmlFor="city">City</FieldLabel>
              <Input id="city" name="city" defaultValue={address?.city} required />
            </Field>
            <Field>
              <FieldLabel htmlFor="country">Country</FieldLabel>
              <Select name="country" defaultValue={address?.country ?? countries[0]?.code}>
                <SelectTrigger id="country">
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  {countries.map((country) => (
                    <SelectItem key={country.code} value={country.code}>
                      {country.label}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </Field>
          </FieldGroup>
        </fieldset>

        <fieldset className="flex flex-col gap-3">
          <legend className="text-foreground mb-2 text-sm font-semibold">Delivery method</legend>
          <RadioGroup name="delivery_id" defaultValue={order.delivery_options[0]?.id}>
            {order.delivery_options.map((option) => (
              <label key={option.id} className="flex items-center justify-between gap-3 rounded-md border p-4">
                <span className="flex items-center gap-3">
                  <RadioGroupItem value={option.id} />
                  <span className="text-sm">
                    <span className="text-foreground block font-medium">{option.label}</span>
                    <span className="text-muted-foreground block">{option.description}</span>
                  </span>
                </span>
                <span className="text-sm font-medium tabular-nums">{option.price_display}</span>
              </label>
            ))}
          </RadioGroup>
        </fieldset>

        <fieldset className="flex flex-col gap-3">
          <legend className="text-foreground mb-2 text-sm font-semibold">Payment</legend>
          <RadioGroup
            name="payment_method"
            defaultValue={paymentMethod}
            onValueChange={(value) => setPaymentMethod(value as "card" | "paypal")}
          >
            <label className="flex items-center gap-3 rounded-md border p-4">
              <RadioGroupItem value="card" />
              <CreditCardIcon className="size-4" aria-hidden="true" />
              <span className="text-sm font-medium">Card</span>
            </label>
            <label className="flex items-center gap-3 rounded-md border p-4">
              <RadioGroupItem value="paypal" />
              <PaypalWordmark className="h-4 w-14" aria-hidden="true" />
            </label>
          </RadioGroup>

          {/* ponytail: mount points only — wire the real Stripe Elements / PayPal SDK here. */}
          {paymentMethod === "card" ? (
            <div className="rounded-md border border-dashed p-4 text-sm text-muted-foreground">
              Stripe payment element mounts here.
            </div>
          ) : (
            <div className="rounded-md border border-dashed p-4 text-sm text-muted-foreground">
              PayPal button mounts here.
            </div>
          )}
        </fieldset>

        <label className="flex items-center gap-2 text-sm">
          <Checkbox
            name="billing_same_as_shipping"
            defaultChecked
            onCheckedChange={(checked) => setBillingSameAsShipping(!!checked)}
          />
          Billing address same as shipping
        </label>

        {!billingSameAsShipping ? (
          <FieldGroup className="grid gap-4 sm:grid-cols-2">
            <Field className="sm:col-span-2">
              <FieldLabel htmlFor="bill_address1">Billing address</FieldLabel>
              <Input id="bill_address1" name="bill_address1" />
            </Field>
          </FieldGroup>
        ) : null}

        <Field data-invalid={!!errors?.accept_policy}>
          <label className="flex items-center gap-2 text-sm">
            <Checkbox id="accept_policy" name="accept_policy" />
            I accept the Terms of Service and Privacy Policy
          </label>
          {errors?.accept_policy ? <FieldError>{errors.accept_policy}</FieldError> : null}
        </Field>

        <Button type="submit" size="lg">
          Place Order
        </Button>
      </Form>
    </>
  )
}
