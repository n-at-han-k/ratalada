# frozen_string_literal: true

# reui: profile-3
#
# <Profile>                                   # blocks/profile-3/profile
#   <h1>
#   <ProfileSyncAlert>                        # blocks/profile-3/profile-sync-alert
#   <ImageUploadField>                        # blocks/profile-3/image-upload-field — avatar
#   <ProfileFormFields>                       # blocks/profile-3/profile-form-fields
#     <Field>
#       <FieldLabelWithHint>                  # blocks/profile-3/field-label-with-hint
#       <Input>                               # first name
#     <Field>
#       <Input>                               # last name
#     <Field>
#       <Input>                               # email
#     <Field>
#       <Input>                               # new password
#   <Button>                                  # save changes

get "/" do
  inertia("[country]/[locale]/(storefront)/account/(authenticated)/profile", props: {
    customer: fixture_customer,
  })
end

# ponytail: no Spree Store API wired, so this just validates and redirects
# back -- nothing is actually persisted.
post "/" do
  first_name = params["first_name"].to_s.strip

  if first_name.empty?
    page_errors(first_name: "Give us your first name")
    redirect("/#{params['country']}/#{params['locale']}/account/profile", 303)
  else
    redirect("/#{params['country']}/#{params['locale']}/account/profile", 303)
  end
end

__END__

import { Form, Head, usePage } from "@inertiajs/react"

import { ImageUploadField } from "@/components/blocks/profile-3/components/image-upload-field"
import { ProfileSyncAlert } from "@/components/blocks/profile-3/components/profile-sync-alert"
import { FieldLabelWithHint } from "@/components/blocks/profile-3/components/field-label-with-hint"
import { Badge } from "@/components/reui/badge"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardFooter } from "@/components/ui/card"
import { Field, FieldError, FieldGroup, FieldLabel } from "@/components/ui/field"
import { Input } from "@/components/ui/input"
import { Separator } from "@/components/ui/separator"

type Customer = { first_name: string; last_name: string; email: string }

export default function Profile({ customer }: { customer: Customer }) {
  const { url } = usePage()

  return (
    <div className="w-full max-w-2xl space-y-6">
      <Head title="Profile" />
      <h1 className="text-2xl font-semibold tracking-tight">Profile</h1>

      <ProfileSyncAlert />

      <Card className="overflow-hidden p-0">
        <Form action={url} method="post" resetOnSuccess={["password"]}>
          {({ processing, errors }) => (
            <>
              <CardContent className="space-y-6 px-6 py-7 sm:px-8">
                <ImageUploadField
                  ariaLabel="Upload profile image"
                  inputId="profile-avatar"
                  alt={`${customer.first_name} ${customer.last_name}`.trim()}
                />

                <Separator />

                <FieldGroup className="grid gap-x-6 gap-y-6 md:grid-cols-2">
                  <Field className="gap-2.5">
                    <FieldLabelWithHint htmlFor="first_name" label="First name" />
                    <Input id="first_name" name="first_name" defaultValue={customer.first_name} />
                    <FieldError errors={errors.first_name ? [{ message: errors.first_name }] : undefined} />
                  </Field>

                  <Field className="gap-2.5">
                    <FieldLabel htmlFor="last_name">Last name</FieldLabel>
                    <Input id="last_name" name="last_name" defaultValue={customer.last_name} />
                  </Field>

                  <Field className="gap-2.5">
                    <div className="flex items-center gap-1.5">
                      <FieldLabel htmlFor="email">Email address</FieldLabel>
                      <Badge variant="success-light" size="sm">Verified</Badge>
                    </div>
                    <Input id="email" name="email" type="email" defaultValue={customer.email} />
                  </Field>

                  <Field className="gap-2.5">
                    <FieldLabel htmlFor="password">New password</FieldLabel>
                    <Input id="password" name="password" type="password" placeholder="Leave blank to keep current" autoComplete="new-password" />
                  </Field>
                </FieldGroup>
              </CardContent>

              <CardFooter className="border-t px-6 py-4 sm:px-8">
                <Button type="submit" disabled={processing}>
                  Save changes
                </Button>
              </CardFooter>
            </>
          )}
        </Form>
      </Card>
    </div>
  )
}
