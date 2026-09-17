# frozen_string_literal: true

get "/" do
  redirect(safe_return_to(params["return_to"]), 303) if current_user

  inertia("login", props: {
    return_to:      params["return_to"],
    # Whether the Google button is worth drawing at all: no credentials, no
    # provider mounted in server.rb, and the form stands alone.
    google_enabled: !ENV["GOOGLE_CLIENT_ID"].nil?,
  })
end

__END__

import { Form, Head } from "@inertiajs/react"

import TextLink from "@/components/text-link"
import { Button } from "@/components/ui/button"
import { Field, FieldError, FieldGroup, FieldLabel } from "@/components/ui/field"
import { Input } from "@/components/ui/input"
import AuthLayout from "@/layouts/auth-layout"

export default function Login({
  return_to,
  google_enabled,
}: {
  return_to: string | null
  google_enabled: boolean
}) {
  return (
    <AuthLayout
      title="Log in to your account"
      description="Enter your email and password below to log in"
    >
      <Head title="Log in" />

      <Form
        action="/auth/identity/callback"
        method="post"
        resetOnSuccess={["password"]}
        className="flex flex-col gap-6"
      >
        {({ processing, errors }) => (
          <>
            <input type="hidden" name="return_to" value={return_to ?? ""} />
            <FieldGroup>
              <Field>
                <FieldLabel htmlFor="auth_key">Email address</FieldLabel>
                <Input
                  id="auth_key"
                  name="auth_key"
                  type="email"
                  required
                  autoFocus
                  autoComplete="email"
                  placeholder="email@example.com"
                />
                <FieldError errors={errors.auth_key ? [{ message: errors.auth_key }] : undefined} />
              </Field>

              <Field>
                <FieldLabel htmlFor="password">Password</FieldLabel>
                <Input
                  id="password"
                  name="password"
                  type="password"
                  required
                  autoComplete="current-password"
                  placeholder="Password"
                />
              </Field>

              <Button type="submit" className="mt-4 w-full" disabled={processing}>
                Log in
              </Button>
            </FieldGroup>

            <div className="text-muted-foreground text-center text-sm">
              Don&apos;t have an account? <TextLink href="/signup">Sign up</TextLink>
            </div>
          </>
        )}
      </Form>

      {google_enabled && (
        <>
          <div className="text-muted-foreground flex items-center gap-3 text-xs">
            <span className="bg-border h-px flex-1" />
            OR
            <span className="bg-border h-px flex-1" />
          </div>

          {/* Its own form, deliberately outside the credentials one above.
              OmniAuth's request phase is a POST to /auth/google_oauth2 that
              leaves the app entirely, so it cannot be a second submit button
              inside a form that posts to the session endpoint. */}
          <Form action="/auth/google_oauth2" method="post">
            {({ processing }) => (
              <>
                <input type="hidden" name="return_to" value={return_to ?? ""} />
                <Button type="submit" variant="outline" className="w-full" disabled={processing}>
                  Continue with Google
                </Button>
              </>
            )}
          </Form>
        </>
      )}
    </AuthLayout>
  )
}
