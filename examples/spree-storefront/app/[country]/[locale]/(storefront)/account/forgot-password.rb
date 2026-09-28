# frozen_string_literal: true

# reui: auth-15
#
# <AuthLogo>                                  # blocks/auth-15/auth-logo
# <LoginForm>                                 # blocks/auth-15/login-form — email-only card
#   <Card>
#     <CardHeader>
#       <CardTitle>
#       <CardDescription>
#     <CardContent>
#       <Alert>                               # reui/alert
#       <Field>
#         <FieldLabel>
#         <Input>                             # email
#       <Button>                              # send reset link
#     <CardFooter>
#       <Link>                                # back to sign in
# # sent
# <Empty>                                     # ui/empty — check your email
#   <Button>                                  # resend

# ponytail: fixture — no email actually goes out, swap for the Spree Store API
# forgot-password endpoint when it is wired
get "/" do
  inertia("[country]/[locale]/(storefront)/account/forgot-password", props: {
    sign_in_href: request.path.delete_suffix("/forgot-password"),
    sent:         params.key?("sent"),
    email:        params["email"],
  })
end

post "/" do
  email = params["email"].to_s.strip

  if email.empty?
    page_errors(email: "Enter your email")
    redirect(request.path, 303)
  else
    redirect("#{request.path}?sent=1&email=#{Rack::Utils.escape(email)}", 303)
  end
end

__END__

import { Form, Head, Link } from "@inertiajs/react"
import { CircleAlert, Mail } from "lucide-react"

import { Alert, AlertDescription } from "@/components/reui/alert"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from "@/components/ui/card"
import { Empty, EmptyDescription, EmptyHeader, EmptyMedia, EmptyTitle } from "@/components/ui/empty"
import { Field, FieldLabel } from "@/components/ui/field"
import { Input } from "@/components/ui/input"

export default function ForgotPassword({
  sign_in_href,
  sent,
  email,
}: {
  sign_in_href: string
  sent: boolean
  email: string | null
}) {
  if (sent) {
    return (
      <main className="mx-auto w-full max-w-md p-6 py-16">
        <Head title="Check your email" />
        <Card>
          <CardContent className="pt-6">
            <Empty>
              <EmptyHeader>
                <EmptyMedia variant="icon">
                  <Mail />
                </EmptyMedia>
                <EmptyTitle>Check your email</EmptyTitle>
                <EmptyDescription>
                  We sent a password reset link to <strong>{email}</strong>. It expires in an hour.
                </EmptyDescription>
              </EmptyHeader>
              <Form method="post" className="contents">
                {({ processing }) => (
                  <>
                    <input type="hidden" name="email" value={email ?? ""} />
                    <Button type="submit" variant="outline" disabled={processing}>
                      Resend
                    </Button>
                  </>
                )}
              </Form>
              <Link href={sign_in_href} className="text-primary hover:text-primary/70 text-sm font-medium">
                Back to sign in
              </Link>
            </Empty>
          </CardContent>
        </Card>
      </main>
    )
  }

  return (
    <main className="mx-auto w-full max-w-md p-6 py-16">
      <Head title="Forgot password" />

      <Card>
        <CardHeader className="text-center">
          <CardTitle>Forgot password</CardTitle>
          <CardDescription>Enter your email and we&apos;ll send you a reset link.</CardDescription>
        </CardHeader>

        <Form method="post" className="contents">
          {({ processing, errors }) => (
            <CardContent className="flex flex-col gap-4">
              {errors.email && (
                <Alert variant="destructive">
                  <CircleAlert />
                  <AlertDescription>{errors.email}</AlertDescription>
                </Alert>
              )}

              <Field>
                <FieldLabel htmlFor="email">Email</FieldLabel>
                <Input id="email" name="email" type="email" autoComplete="email" required placeholder="you@example.com" />
              </Field>

              <Button type="submit" size="lg" className="w-full" disabled={processing}>
                Send reset link
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
