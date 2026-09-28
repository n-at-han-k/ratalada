# frozen_string_literal: true

# reui: auth-15
#
# <AuthLogo>                                  # blocks/auth-15/auth-logo
# <Card>                                      # blocks/auth-15/login-form, password fields
#   <CardHeader>
#     <CardTitle>
#     <CardDescription>
#   <CardContent>
#     <Alert>                                 # reui/alert
#     <Field>
#       <Input>                               # new password + show/hide
#     <Field>
#       <Input>                               # confirm password
#     <Button>                                # reset password
#   <CardFooter>
#     <Link>
# # invalid link / success
# <Empty>                                     # ui/empty
#   <Button>                                  # go to sign in

# ponytail: fixture — no real reset token is issued or checked, swap for the
# Spree Store API reset-password endpoint when it is wired
get "/" do
  sign_in_href = request.path.delete_suffix("/reset-password")

  inertia("[country]/[locale]/(storefront)/account/reset-password", props: {
    sign_in_href:         sign_in_href,
    forgot_password_href: "#{sign_in_href}/forgot-password",
    token:                params["token"],
    done:                 params.key?("done"),
  })
end

post "/" do
  password              = params["password"].to_s
  password_confirmation = params["password_confirmation"].to_s

  errors = {}
  errors[:password]              = "Password needs at least 6 characters" if password.length < 6
  errors[:password_confirmation] = "Passwords don't match" if password != password_confirmation

  if errors.any?
    page_errors(errors)
    redirect(request.path + "?token=#{params['token']}", 303)
  else
    redirect("#{request.path}?done=1", 303)
  end
end

__END__

import { Form, Head, Link } from "@inertiajs/react"
import { CircleAlert, CircleCheck, Eye, EyeOff } from "lucide-react"
import { useState } from "react"

import { Alert, AlertDescription } from "@/components/reui/alert"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from "@/components/ui/card"
import { Empty, EmptyDescription, EmptyHeader, EmptyMedia, EmptyTitle } from "@/components/ui/empty"
import { Field, FieldError, FieldLabel } from "@/components/ui/field"
import { Input } from "@/components/ui/input"

export default function ResetPassword({
  sign_in_href,
  forgot_password_href,
  token,
  done,
}: {
  sign_in_href: string
  forgot_password_href: string
  token: string | null
  done: boolean
}) {
  const [showPassword, setShowPassword] = useState(false)
  const [showPasswordConfirmation, setShowPasswordConfirmation] = useState(false)

  if (!token) {
    return (
      <main className="mx-auto w-full max-w-md p-6 py-16">
        <Head title="Invalid link" />
        <Card>
          <CardContent className="pt-6">
            <Empty>
              <EmptyHeader>
                <EmptyMedia variant="icon">
                  <CircleAlert />
                </EmptyMedia>
                <EmptyTitle>Invalid or expired link</EmptyTitle>
                <EmptyDescription>Request a new password reset link to continue.</EmptyDescription>
              </EmptyHeader>
              <Button nativeButton={false} render={<Link href={forgot_password_href} />}>
                Request new link
              </Button>
            </Empty>
          </CardContent>
        </Card>
      </main>
    )
  }

  if (done) {
    return (
      <main className="mx-auto w-full max-w-md p-6 py-16">
        <Head title="Password reset" />
        <Card>
          <CardContent className="pt-6">
            <Empty>
              <EmptyHeader>
                <EmptyMedia variant="icon">
                  <CircleCheck />
                </EmptyMedia>
                <EmptyTitle>Password reset</EmptyTitle>
                <EmptyDescription>Your password has been updated. Sign in with your new password.</EmptyDescription>
              </EmptyHeader>
              <Button nativeButton={false} render={<Link href={sign_in_href} />}>
                Sign in
              </Button>
            </Empty>
          </CardContent>
        </Card>
      </main>
    )
  }

  return (
    <main className="mx-auto w-full max-w-md p-6 py-16">
      <Head title="Reset password" />

      <Card>
        <CardHeader className="text-center">
          <CardTitle>Reset password</CardTitle>
          <CardDescription>Choose a new password for your account.</CardDescription>
        </CardHeader>

        <Form method="post" resetOnError={["password", "password_confirmation"]} className="contents">
          {({ processing, errors }) => (
            <CardContent className="flex flex-col gap-4">
              {(errors.password || errors.password_confirmation) && (
                <Alert variant="destructive">
                  <CircleAlert />
                  <AlertDescription>{errors.password ?? errors.password_confirmation}</AlertDescription>
                </Alert>
              )}

              <input type="hidden" name="token" value={token} />

              <Field>
                <FieldLabel htmlFor="password">New password</FieldLabel>
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

              <Button type="submit" size="lg" className="w-full" disabled={processing}>
                Reset password
              </Button>
            </CardContent>
          )}
        </Form>

        <CardFooter className="justify-center">
          <Link href={sign_in_href} className="text-primary hover:text-primary/70 text-sm font-medium">
            Back to sign in
          </Link>
        </CardFooter>
      </Card>
    </main>
  )
}
