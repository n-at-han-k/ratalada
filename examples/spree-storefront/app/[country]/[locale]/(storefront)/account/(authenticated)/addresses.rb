# frozen_string_literal: true

# reui: form-6
#
# <BusinessVerification>                      # blocks/form-6/business-verification — section list shell
#   <h1>
#   <VerificationSection>                     # blocks/form-6/verification-section — one per address
#     <dl>                                    # rendered address
#     <Button>                                # edit
#     <Button>                                # delete
#   <Button>                                  # add address
#   <EditSectionDialog>                       # blocks/form-6/edit-section-dialog
#     <Field>
#       <FieldLabel>
#       <Input>
#     <Select>                                # country / state
#     <Button>                                # save
# <Empty>                                     # ui/empty — no addresses

helpers do
  # ponytail: fixture props, swap for the Spree Store API call when it is wired
  def fixture_addresses
    [
      {
        id:           "1",
        full_name:    "Jordan Avery",
        address1:     "742 Evergreen Terrace",
        address2:     nil,
        city:         "Springfield",
        state:        "OR",
        postal_code:  "97403",
        country:      "US",
        phone:        "555-0110",
      },
      {
        id:           "2",
        full_name:    "Jordan Avery",
        address1:     "1 Infinite Loop",
        address2:     "Suite 400",
        city:         "Cupertino",
        state:        "CA",
        postal_code:  "95014",
        country:      "US",
        phone:        nil,
      },
    ]
  end
end

get "/" do
  inertia("[country]/[locale]/(storefront)/account/(authenticated)/addresses", props: {
    customer:  fixture_customer,
    addresses: fixture_addresses,
  })
end

# ponytail: no Spree Store API wired, so add/edit/delete just validate (or
# not) and redirect back -- nothing is actually persisted.
post "/" do
  if params["address1"].to_s.strip.empty?
    page_errors(address1: "Street address is required")
  end
  redirect("/#{params['country']}/#{params['locale']}/account/addresses", 303)
end

patch "/[id]" do
  if params["address1"].to_s.strip.empty?
    page_errors(address1: "Street address is required")
  end
  redirect("/#{params['country']}/#{params['locale']}/account/addresses", 303)
end

delete "/[id]" do
  redirect("/#{params['country']}/#{params['locale']}/account/addresses", 303)
end

__END__

import { useState } from "react"
import { Form, Head, usePage } from "@inertiajs/react"

import { Button } from "@/components/ui/button"
import {
  Dialog,
  DialogContent,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog"
import { Empty, EmptyDescription, EmptyHeader, EmptyMedia, EmptyTitle } from "@/components/ui/empty"
import { Field, FieldError, FieldGroup, FieldLabel } from "@/components/ui/field"
import { Input } from "@/components/ui/input"
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select"
import { MapPinIcon, PlusIcon } from "lucide-react"

type Address = {
  id: string
  full_name: string
  address1: string
  address2: string | null
  city: string
  state: string
  postal_code: string
  country: string
  phone: string | null
}

const STATES = ["AL", "CA", "NY", "OR", "TX", "WA"]

function AddressForm({ address, url }: { address: Address | null; url: string }) {
  const action = address ? `${url}/${address.id}` : url

  return (
    <Form action={action} method={address ? "patch" : "post"} className="contents">
      {({ processing, errors }) => (
        <>
          <FieldGroup className="grid gap-4 sm:grid-cols-2">
            <Field className="sm:col-span-2">
              <FieldLabel htmlFor="full_name">Full name</FieldLabel>
              <Input id="full_name" name="full_name" defaultValue={address?.full_name} required />
            </Field>

            <Field className="sm:col-span-2">
              <FieldLabel htmlFor="address1">Address</FieldLabel>
              <Input id="address1" name="address1" defaultValue={address?.address1} required />
              <FieldError errors={errors.address1 ? [{ message: errors.address1 }] : undefined} />
            </Field>

            <Field className="sm:col-span-2">
              <FieldLabel htmlFor="address2">Apt, suite, etc.</FieldLabel>
              <Input id="address2" name="address2" defaultValue={address?.address2 ?? ""} />
            </Field>

            <Field>
              <FieldLabel htmlFor="city">City</FieldLabel>
              <Input id="city" name="city" defaultValue={address?.city} required />
            </Field>

            <Field>
              <FieldLabel htmlFor="postal_code">Postal code</FieldLabel>
              <Input id="postal_code" name="postal_code" defaultValue={address?.postal_code} required />
            </Field>

            <Field>
              <FieldLabel htmlFor="state">State</FieldLabel>
              <Select name="state" defaultValue={address?.state ?? STATES[0]}>
                <SelectTrigger id="state" className="w-full">
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  {STATES.map((state) => (
                    <SelectItem key={state} value={state}>{state}</SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </Field>

            <Field>
              <FieldLabel htmlFor="country">Country</FieldLabel>
              <Select name="country" defaultValue={address?.country ?? "US"}>
                <SelectTrigger id="country" className="w-full">
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="US">United States</SelectItem>
                  <SelectItem value="CA">Canada</SelectItem>
                  <SelectItem value="GB">United Kingdom</SelectItem>
                </SelectContent>
              </Select>
            </Field>

            <Field className="sm:col-span-2">
              <FieldLabel htmlFor="phone">Phone</FieldLabel>
              <Input id="phone" name="phone" defaultValue={address?.phone ?? ""} />
            </Field>
          </FieldGroup>

          <DialogFooter className="mt-6">
            <Button type="submit" disabled={processing}>Save address</Button>
          </DialogFooter>
        </>
      )}
    </Form>
  )
}

function AddressCard({ address, url }: { address: Address; url: string }) {
  const [editing, setEditing] = useState(false)

  return (
    <div className="rounded-xl border p-6">
      <dl className="text-sm leading-6">
        <dt className="sr-only">Name</dt>
        <dd className="font-medium">{address.full_name}</dd>
        <dt className="sr-only">Street</dt>
        <dd className="text-muted-foreground">{address.address1}</dd>
        {address.address2 && <dd className="text-muted-foreground">{address.address2}</dd>}
        <dt className="sr-only">City, state, postal code</dt>
        <dd className="text-muted-foreground">
          {address.city}, {address.state} {address.postal_code}
        </dd>
        <dt className="sr-only">Country</dt>
        <dd className="text-muted-foreground">{address.country}</dd>
        {address.phone && <dd className="text-muted-foreground mt-1">{address.phone}</dd>}
      </dl>

      <div className="mt-4 flex gap-2">
        <Dialog open={editing} onOpenChange={setEditing}>
          <DialogTrigger render={<Button type="button" variant="outline" size="sm" />}>
            Edit
          </DialogTrigger>
          <DialogContent>
            <DialogHeader>
              <DialogTitle>Edit address</DialogTitle>
            </DialogHeader>
            <AddressForm address={address} url={url} />
          </DialogContent>
        </Dialog>

        <Form action={`${url}/${address.id}`} method="delete">
          {({ processing }) => (
            <Button type="submit" variant="destructive" size="sm" disabled={processing}>
              Delete
            </Button>
          )}
        </Form>
      </div>
    </div>
  )
}

export default function Addresses({ addresses }: { addresses: Address[] }) {
  const { url } = usePage()
  const [adding, setAdding] = useState(false)

  return (
    <div className="space-y-6">
      <Head title="Addresses" />
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-semibold tracking-tight">Addresses</h1>

        <Dialog open={adding} onOpenChange={setAdding}>
          <DialogTrigger render={<Button type="button" size="sm" />}>
            <PlusIcon aria-hidden="true" />
            Add address
          </DialogTrigger>
          <DialogContent>
            <DialogHeader>
              <DialogTitle>Add address</DialogTitle>
            </DialogHeader>
            <AddressForm address={null} url={url} />
          </DialogContent>
        </Dialog>
      </div>

      {addresses.length === 0 ? (
        <Empty>
          <EmptyHeader>
            <EmptyMedia variant="icon">
              <MapPinIcon aria-hidden="true" />
            </EmptyMedia>
            <EmptyTitle>No addresses yet</EmptyTitle>
            <EmptyDescription>Add an address to speed up checkout.</EmptyDescription>
          </EmptyHeader>
        </Empty>
      ) : (
        <div className="grid gap-4 sm:grid-cols-2">
          {addresses.map((address) => (
            <AddressCard key={address.id} address={address} url={url} />
          ))}
        </div>
      )}
    </div>
  )
}
