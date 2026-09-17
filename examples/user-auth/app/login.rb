# frozen_string_literal: true

get "/" do
  redirect(safe_return_to(params["return_to"]), 303) if current_user

  inertia("login", props: {
    return_to:        params["return_to"],
    # One Tap is client-side, so the client id has to reach the browser. It is
    # public by design (it is in every OAuth redirect URL already); the secret
    # stays here. nil without credentials, and the page renders the form alone.
    google_client_id: ENV["GOOGLE_CLIENT_ID"],
    # Set by the sign-out route. Suppresses One Tap's auto-select on the page a
    # user lands on right after signing out, which would otherwise sign them
    # straight back in before they saw it.
    signed_out:       params.key?("signed_out"),
  })
end

__END__

import { Form, Head, router } from "@inertiajs/react"
import { GoogleOAuthProvider, useGoogleOneTapLogin } from "@react-oauth/google"

import TextLink from "@/components/text-link"
import { Button } from "@/components/ui/button"
import { Field, FieldError, FieldGroup, FieldLabel } from "@/components/ui/field"
import { Input } from "@/components/ui/input"
import AuthLayout from "@/layouts/auth-layout"

/* Google One Tap. Behaviour only, deliberately rendering nothing: the prompt
   is drawn by Google inside a cross-origin iframe it owns, so there is no
   markup here to style and no shadcn component to reach for. The one thing
   this side owns is when it fires and where the token goes.

   Mounted only when a client id is present, so a checkout with no Google
   credentials (and so no provider in server.rb) renders the page without it. */
function GoogleOneTap({
  return_to,
  auto_select,
}: {
  return_to: string | null
  auto_select: boolean
}) {
  useGoogleOneTapLogin({
    // Signs a returning user straight back in with no interaction. Off on the
    // page reached by signing out.
    auto_select,
    use_fedcm_for_prompt: true,
    onSuccess: ({ credential }) => {
      router.post("/auth/google/one-tap", { credential, return_to: return_to ?? "" })
    },
    // No UI for a failure: a user who never asked for One Tap should not be
    // shown an error about it — the form below is still right there.
    onError: () => {},
  })

  return null
}

export default function Login({
  return_to,
  google_client_id,
  signed_out,
}: {
  return_to: string | null
  google_client_id: string | null
  signed_out: boolean
}) {
  return (
    <AuthLayout
      title="Log in to your account"
      description="Enter your email and password below to log in"
    >
      <Head title="Log in" />
      {google_client_id && (
        <GoogleOAuthProvider clientId={google_client_id}>
          <GoogleOneTap return_to={return_to} auto_select={!signed_out} />
        </GoogleOAuthProvider>
      )}

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

      {google_client_id && (
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
