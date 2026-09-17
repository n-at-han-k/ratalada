# frozen_string_literal: true

# The form posts to /auth/identity/register, which omniauth-identity answers
# itself: it creates the Account, and on a validation failure server.rb's
# on_failed_registration puts the errors in the session and sends the browser
# back here. A successful registration lands on the identity callback below.
get "/" do
  redirect("/", 303) if current_user

  inertia("signup")
end

__END__

import { Form, Head } from "@inertiajs/react"

import TextLink from "@/components/text-link"
import { Button } from "@/components/ui/button"
import { Field, FieldError, FieldGroup, FieldLabel } from "@/components/ui/field"
import { Input } from "@/components/ui/input"
import AuthLayout from "@/layouts/auth-layout"

export default function Signup() {
  return (
    <AuthLayout
      title="Create an account"
      description="Enter your email and a password below to sign up"
    >
      <Head title="Sign up" />

      <Form
        action="/auth/identity/register"
        method="post"
        resetOnError={["password", "password_confirmation"]}
        className="flex flex-col gap-6"
      >
        {({ processing, errors }) => (
          <FieldGroup>
            <Field>
              <FieldLabel htmlFor="email">Email address</FieldLabel>
              <Input
                id="email"
                name="email"
                type="email"
                required
                autoFocus
                autoComplete="email"
                placeholder="email@example.com"
              />
              <FieldError errors={errors.email ? [{ message: errors.email }] : undefined} />
            </Field>

            <Field>
              <FieldLabel htmlFor="password">Password</FieldLabel>
              <Input
                id="password"
                name="password"
                type="password"
                required
                autoComplete="new-password"
                placeholder="Password"
              />
              <FieldError errors={errors.password ? [{ message: errors.password }] : undefined} />
            </Field>

            <Field>
              <FieldLabel htmlFor="password_confirmation">Confirm password</FieldLabel>
              <Input
                id="password_confirmation"
                name="password_confirmation"
                type="password"
                required
                autoComplete="new-password"
                placeholder="Confirm password"
              />
            </Field>

            <Button type="submit" className="mt-4 w-full" disabled={processing}>
              Create account
            </Button>

            <div className="text-muted-foreground text-center text-sm">
              Already have an account? <TextLink href="/login">Log in</TextLink>
            </div>
          </FieldGroup>
        )}
      </Form>
    </AuthLayout>
  )
}
