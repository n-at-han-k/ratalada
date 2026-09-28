# frozen_string_literal: true

# reui: form-10
#
# <CustomerOnboardingForm>                    # blocks/form-10/customer-onboarding-form
#   <Card>
#     <CardHeader>
#       <CardTitle>
#       <CardDescription>
#     <CardContent>
#       <Alert>                               # reui/alert
#       <Field>
#         <Input>                             # first name
#       <Field>
#         <Input>                             # last name
#       <Field>
#         <Input>                             # company
#       <Field>
#         <Input>                             # tax id
#       <Field>
#         <Input>                             # email
#       <Field>
#         <Input>                             # password
#       <Button>                              # submit application
#     <CardFooter>
#       <Link>
# # submitted
# <EmptyState>                                # blocks/empty-state-14/empty-state

# Outside the gate -- guests need to reach this page to apply in the first
# place. Signed-in-but-not-approved visitors land here from the "apply again"
# link but the form still just re-submits the same fixture fields.
get "/" do
  inertia("[country]/[locale]/(wholesale)/wholesale/apply")
end

# ponytail: fixture props. The real thing registers a Spree customer and
# leaves them out of the Wholesale group until an admin approves them; here
# it's a session flag flipped to "pending", which index.rb's gate reads.
post "/" do
  required = {
    first_name: "First name",
    last_name:  "Last name",
    company:    "Company",
    email:      "Email address",
    password:   "Password",
  }
  errors = required.filter_map do |field, label|
    [field, "#{label} is required."] if params[field.to_s].to_s.strip.empty?
  end.to_h
  errors[:password] = "Password must be at least 6 characters." if
    params["password"].to_s.length.positive? && params["password"].to_s.length < 6

  if errors.any?
    page_errors(errors)
    redirect("/wholesale/apply", 303)
  else
    session[:wholesale_status] = "pending"
    redirect("/wholesale", 303)
  end
end

__END__

import { Form, Head, Link } from "@inertiajs/react"
import { Building2Icon, CircleAlertIcon, EyeIcon, EyeOffIcon } from "lucide-react"
import { useState } from "react"

import { Alert, AlertDescription } from "@/components/reui/alert"
import { Button } from "@/components/ui/button"
import {
  Card,
  CardContent,
  CardDescription,
  CardFooter,
  CardHeader,
  CardTitle,
} from "@/components/ui/card"
import { Field, FieldError, FieldLabel } from "@/components/ui/field"
import { Input } from "@/components/ui/input"

export default function WholesaleApply() {
  const [showPassword, setShowPassword] = useState(false)

  return (
    <div className="mx-auto max-w-xl px-4 py-16 sm:px-6 lg:px-8">
      <Head title="Apply for wholesale" />
      <Card>
        <CardHeader className="text-center">
          <div className="mx-auto mb-2 flex size-12 items-center justify-center rounded-full bg-slate-100">
            <Building2Icon className="size-6 text-slate-700" />
          </div>
          <CardTitle>Apply for a trade account</CardTitle>
          <CardDescription>
            Case-pack pricing and quick order, once your application is reviewed.
          </CardDescription>
        </CardHeader>

        <Form action="/wholesale/apply" method="post" resetOnError={["password"]}>
          {({ processing, errors }) => (
            <>
              <CardContent className="space-y-4">
                {Object.keys(errors).length > 0 && (
                  <Alert variant="destructive">
                    <CircleAlertIcon />
                    <AlertDescription>Fix the highlighted fields and try again.</AlertDescription>
                  </Alert>
                )}

                <div className="grid grid-cols-2 gap-4">
                  <Field data-invalid={!!errors.first_name}>
                    <FieldLabel htmlFor="first_name">First name</FieldLabel>
                    <Input id="first_name" name="first_name" required autoFocus />
                    <FieldError errors={errors.first_name ? [{ message: errors.first_name }] : undefined} />
                  </Field>
                  <Field data-invalid={!!errors.last_name}>
                    <FieldLabel htmlFor="last_name">Last name</FieldLabel>
                    <Input id="last_name" name="last_name" required />
                    <FieldError errors={errors.last_name ? [{ message: errors.last_name }] : undefined} />
                  </Field>
                </div>

                <Field data-invalid={!!errors.company}>
                  <FieldLabel htmlFor="company">Company</FieldLabel>
                  <Input id="company" name="company" required />
                  <FieldError errors={errors.company ? [{ message: errors.company }] : undefined} />
                </Field>

                <Field>
                  <FieldLabel htmlFor="tax_id">Tax ID (optional)</FieldLabel>
                  <Input id="tax_id" name="tax_id" placeholder="EIN / VAT number" />
                </Field>

                <Field data-invalid={!!errors.email}>
                  <FieldLabel htmlFor="email">Email address</FieldLabel>
                  <Input id="email" name="email" type="email" autoComplete="email" required placeholder="you@company.com" />
                  <FieldError errors={errors.email ? [{ message: errors.email }] : undefined} />
                </Field>

                <Field data-invalid={!!errors.password}>
                  <FieldLabel htmlFor="password">Password</FieldLabel>
                  <div className="relative">
                    <Input
                      id="password"
                      name="password"
                      type={showPassword ? "text" : "password"}
                      autoComplete="new-password"
                      required
                      minLength={6}
                      className="pr-10"
                    />
                    <Button
                      type="button"
                      variant="ghost"
                      size="icon-sm"
                      onClick={() => setShowPassword((v) => !v)}
                      aria-label={showPassword ? "Hide password" : "Show password"}
                      className="absolute top-1/2 right-1 -translate-y-1/2"
                    >
                      {showPassword ? <EyeOffIcon className="size-4" /> : <EyeIcon className="size-4" />}
                    </Button>
                  </div>
                  <FieldError errors={errors.password ? [{ message: errors.password }] : undefined} />
                </Field>

                <Button type="submit" disabled={processing} size="lg" className="w-full bg-slate-900 hover:bg-slate-800">
                  {processing ? "Submitting…" : "Submit application"}
                </Button>
              </CardContent>

              <CardFooter className="justify-center">
                <p className="text-muted-foreground text-sm">
                  Already have an account?{" "}
                  <Link href="/wholesale/sign-in" className="font-medium text-slate-900 hover:underline">
                    Sign in
                  </Link>
                </p>
              </CardFooter>
            </>
          )}
        </Form>
      </Card>
    </div>
  )
}
