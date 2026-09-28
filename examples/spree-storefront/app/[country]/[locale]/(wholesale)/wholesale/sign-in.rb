# frozen_string_literal: true

# reui: auth-16
#
# <Auth>                                      # blocks/auth-16/auth
#   <AuthHeader>                              # blocks/auth-16/auth-header
#     <AuthLogo>                              # blocks/auth-16/auth-logo
#   <SignInForm>                              # blocks/auth-16/sign-in-form
#     <Alert>                                 # reui/alert
#     <Field>
#       <Input>                               # email
#     <Field>
#       <Input>                               # password + show/hide
#     <Button>                                # sign in
#     <Link>                                  # apply for an account
#   <AuthFooter>                              # blocks/auth-16/auth-footer

# Already approved and just re-hit /wholesale/sign-in? Send them on into the
# portal instead of showing the form again.
get "/" do
  redirect("/wholesale", 303) if wholesale_status == "approved"

  inertia("[country]/[locale]/(wholesale)/wholesale/sign-in")
end

# ponytail: fixture credentials, one trade account. Swap for the Spree
# identity/session call when the backend is wired -- this never touches a
# password hash.
WHOLESALE_FIXTURE_CREDENTIALS = {"trade@northstartrading.com" => "wholesale123"}.freeze

post "/" do
  email = params["email"].to_s
  password = params["password"].to_s

  if WHOLESALE_FIXTURE_CREDENTIALS[email] == password
    session[:wholesale_status] = "approved"
    redirect("/wholesale", 303)
  else
    page_errors(auth: "That email and password don't match a trade account.")
    redirect("/wholesale/sign-in", 303)
  end
end

__END__

import { Form, Head, Link } from "@inertiajs/react"
import { Building2Icon, CircleAlertIcon, EyeIcon, EyeOffIcon } from "lucide-react"
import { useState } from "react"

import { Alert, AlertDescription } from "@/components/reui/alert"
import { Badge } from "@/components/reui/badge"
import { Button } from "@/components/ui/button"
import { Field, FieldError, FieldLabel } from "@/components/ui/field"
import { Input } from "@/components/ui/input"

export default function WholesaleSignIn() {
  const [showPassword, setShowPassword] = useState(false)

  return (
    <div className="mx-auto flex min-h-screen max-w-md flex-col justify-center px-4 py-16 sm:px-6">
      <Head title="Wholesale sign in" />

      <div className="mb-8 flex flex-col items-center gap-3 text-center">
        <div className="inline-flex items-center gap-2 rounded-full bg-slate-900 px-3 py-1 text-xs font-semibold uppercase tracking-wide text-slate-100">
          <Building2Icon className="size-3.5" />
          Trade
        </div>
        <h1 className="text-2xl font-semibold text-slate-900">Sign in to the trade portal</h1>
        <Badge variant="secondary">Wholesale accounts only</Badge>
      </div>

      <Form action="/wholesale/sign-in" method="post" resetOnSuccess={["password"]} className="flex flex-col gap-6">
        {({ processing, errors }) => (
          <>
            {errors.auth && (
              <Alert variant="destructive">
                <CircleAlertIcon />
                <AlertDescription>{errors.auth}</AlertDescription>
              </Alert>
            )}

            <Field data-invalid={!!errors.email}>
              <FieldLabel htmlFor="email">Email address</FieldLabel>
              <Input id="email" name="email" type="email" required autoFocus autoComplete="email" placeholder="you@company.com" />
            </Field>

            <Field>
              <FieldLabel htmlFor="password">Password</FieldLabel>
              <div className="relative">
                <Input
                  id="password"
                  name="password"
                  type={showPassword ? "text" : "password"}
                  required
                  autoComplete="current-password"
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
            </Field>

            <Button type="submit" disabled={processing} size="lg" className="w-full bg-slate-900 hover:bg-slate-800">
              {processing ? "Signing in…" : "Sign in"}
            </Button>

            <p className="text-muted-foreground text-center text-sm">
              Don&apos;t have an account?{" "}
              <Link href="/wholesale/apply" className="font-medium text-slate-900 hover:underline">
                Apply for one
              </Link>
            </p>
          </>
        )}
      </Form>

      <p className="text-muted-foreground mt-10 text-center text-xs">
        Demo credentials: trade@northstartrading.com / wholesale123
      </p>
    </div>
  )
}
