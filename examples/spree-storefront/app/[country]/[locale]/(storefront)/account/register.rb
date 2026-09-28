# frozen_string_literal: true

# reui: auth-20, form-10
#
# <AuthLogo>                                  # blocks/auth-20/auth-logo
# <Card>                                      # blocks/auth-20/login-form, extended
#   <CardHeader>
#     <CardTitle>
#     <CardDescription>
#   <CardContent>
#     <Alert>                                 # reui/alert
#     <Field>                                 # field rows: blocks/form-10/customer-onboarding-form
#       <FieldLabel>
#       <Input>                               # first name
#     <Field>
#       <Input>                               # last name
#     <Field>
#       <Input>                               # email
#     <Field>
#       <Input>                               # password + show/hide
#     <Field>
#       <Input>                               # confirm password
#     <Checkbox>                              # policy consent
#       <Link>
#     <Button>                                # create account
#   <CardFooter>
#     <Link>                                  # sign in

# ponytail: fixture auth, swap for the Spree Store API session when it is wired
get "/" do
  sign_in_href = request.path.delete_suffix("/register")
  redirect(sign_in_href, 303) if session[:customer]

  inertia("[country]/[locale]/(storefront)/account/register", props: {sign_in_href: sign_in_href})
end

post "/" do
  first_name            = params["first_name"].to_s.strip
  last_name             = params["last_name"].to_s.strip
  email                 = params["email"].to_s.strip
  password              = params["password"].to_s
  password_confirmation = params["password_confirmation"].to_s
  consent               = params["policy_consent"] == "on"

  errors = {}
  errors[:email]                  = "Enter your email" if email.empty?
  errors[:password]               = "Password needs at least 6 characters" if password.length < 6
  errors[:password_confirmation]  = "Passwords don't match" if password != password_confirmation
  errors[:policy_consent]         = "You need to accept the policy to continue" unless consent

  if errors.any?
    page_errors(errors)
    redirect(request.path, 303)
  else
    session[:customer] = {email: email, first_name: first_name, last_name: last_name}
    redirect(request.path.delete_suffix("/register"), 303)
  end
end

__END__

import { Form, Head, Link } from "@inertiajs/react"
import { CircleAlert, Eye, EyeOff } from "lucide-react"
import { useState } from "react"

import { Alert, AlertDescription } from "@/components/reui/alert"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from "@/components/ui/card"
import { Checkbox } from "@/components/ui/checkbox"
import { Field, FieldError, FieldLabel } from "@/components/ui/field"
import { Input } from "@/components/ui/input"

export default function Register({ sign_in_href }: { sign_in_href: string }) {
  const [showPassword, setShowPassword] = useState(false)
  const [showPasswordConfirmation, setShowPasswordConfirmation] = useState(false)

  return (
    <main className="mx-auto w-full max-w-md p-6 py-16">
      <Head title="Create account" />

      <Card>
        <CardHeader className="text-center">
          <CardTitle>Create account</CardTitle>
          <CardDescription>Sign up to check out faster and track your orders.</CardDescription>
        </CardHeader>

        <Form
          method="post"
          resetOnError={["password", "password_confirmation"]}
          className="contents"
        >
          {({ processing, errors }) => (
            <CardContent className="flex flex-col gap-4">
              {errors.email && (
                <Alert variant="destructive">
                  <CircleAlert />
                  <AlertDescription>{errors.email}</AlertDescription>
                </Alert>
              )}

              <div className="grid grid-cols-2 gap-4">
                <Field>
                  <FieldLabel htmlFor="first_name">First name</FieldLabel>
                  <Input id="first_name" name="first_name" type="text" autoComplete="given-name" placeholder="Jordan" />
                </Field>

                <Field>
                  <FieldLabel htmlFor="last_name">Last name</FieldLabel>
                  <Input id="last_name" name="last_name" type="text" autoComplete="family-name" placeholder="Rivera" />
                </Field>
              </div>

              <Field>
                <FieldLabel htmlFor="email">Email</FieldLabel>
                <Input id="email" name="email" type="email" autoComplete="email" required placeholder="you@example.com" />
              </Field>

              <Field>
                <FieldLabel htmlFor="password">Password</FieldLabel>
                <div className="relative">
                  <Input
                    id="password"
                    name="password"
                    type={showPassword ? "text" : "password"}
                    autoComplete="new-password"
                    required
                    minLength={6}
                    placeholder="••••••••"
                    className="pr-10"
                  />
                  <Button
                    type="button"
                    variant="ghost"
                    size="icon-sm"
                    className="absolute right-1 top-1/2 -translate-y-1/2"
                    aria-label={showPassword ? "Hide password" : "Show password"}
                    onClick={() => setShowPassword((current) => !current)}
                  >
                    {showPassword ? <EyeOff /> : <Eye />}
                  </Button>
                </div>
                <FieldError errors={errors.password ? [{message: errors.password}] : undefined} />
              </Field>

              <Field>
                <FieldLabel htmlFor="password_confirmation">Confirm password</FieldLabel>
                <div className="relative">
                  <Input
                    id="password_confirmation"
                    name="password_confirmation"
                    type={showPasswordConfirmation ? "text" : "password"}
                    autoComplete="new-password"
                    required
                    minLength={6}
                    placeholder="••••••••"
                    className="pr-10"
                  />
                  <Button
                    type="button"
                    variant="ghost"
                    size="icon-sm"
                    className="absolute right-1 top-1/2 -translate-y-1/2"
                    aria-label={showPasswordConfirmation ? "Hide password" : "Show password"}
                    onClick={() => setShowPasswordConfirmation((current) => !current)}
                  >
                    {showPasswordConfirmation ? <EyeOff /> : <Eye />}
                  </Button>
                </div>
                <FieldError errors={errors.password_confirmation ? [{message: errors.password_confirmation}] : undefined} />
              </Field>

              <Field orientation="horizontal">
                <Checkbox id="policy_consent" name="policy_consent" />
                <FieldLabel htmlFor="policy_consent" className="font-normal">
                  I agree to the{" "}
                  <a href="#" className="text-primary underline underline-offset-4">
                    terms and privacy policy
                  </a>
                </FieldLabel>
              </Field>
              <FieldError errors={errors.policy_consent ? [{message: errors.policy_consent}] : undefined} />

              <Button type="submit" size="lg" className="w-full" disabled={processing}>
                Create account
              </Button>
            </CardContent>
          )}
        </Form>

        <CardFooter className="justify-center">
          <p className="text-muted-foreground text-sm">
            Already have an account?{" "}
            <Link href={sign_in_href} className="text-primary hover:text-primary/70 font-medium">
              Sign in
            </Link>
          </p>
        </CardFooter>
      </Card>
    </main>
  )
}
