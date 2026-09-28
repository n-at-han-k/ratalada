# frozen_string_literal: true

# reui: auth-20 (signed out), profile-1 (signed in)
#
# # signed out                                # blocks/auth-20/auth
# <AuthLogo>                                  # blocks/auth-20/auth-logo
# <LoginForm>                                 # blocks/auth-20/login-form
#   <Card>
#     <CardHeader>
#       <CardTitle>
#       <CardDescription>
#     <CardContent>
#       <Alert>                               # reui/alert — sign-in error
#       <Field>
#         <FieldLabel>
#         <Input>                             # email
#       <Field>
#         <FieldLabel>
#         <Input>                             # password + show/hide from the block
#       <Link>                                # forgot password
#       <Button>                              # sign in
#     <CardFooter>
#       <Link>                                # create account
# # signed in                                 # shell: blocks/profile-1/profile
# <AccountShell>
#   <h1>
#   <Card>                                    # tile: orders
#     <CardContent>
#       <ShoppingBag>
#   <Card>                                    # tile: addresses
#   <Card>                                    # tile: credit cards
#   <Card>                                    # tile: profile

# ponytail: fixture auth, swap for the Spree Store API session when it is wired
get "/" do
  if session[:customer]
    inertia("[country]/[locale]/(storefront)/account", props: {
      signed_in: true,
      orders_href:        "#{request.path}/orders",
      addresses_href:      "#{request.path}/addresses",
      credit_cards_href:   "#{request.path}/credit-cards",
      profile_href:        "#{request.path}/profile",
    })
  else
    inertia("[country]/[locale]/(storefront)/account", props: {
      signed_in:          false,
      register_href:      "#{request.path}/register",
      forgot_password_href: "#{request.path}/forgot-password",
    })
  end
end

post "/" do
  email    = params["email"].to_s.strip
  password = params["password"].to_s

  if email.empty? || password.empty?
    page_errors(base: "Enter your email and password")
    redirect(request.path, 303)
  else
    session[:customer] = {email: email}
    redirect(request.path, 303)
  end
end

__END__

import { Form, Head, Link } from "@inertiajs/react"
import { CircleAlert, CreditCard, Eye, EyeOff, MapPin, ShoppingBag, User } from "lucide-react"
import { useState } from "react"

import { Alert, AlertDescription } from "@/components/reui/alert"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from "@/components/ui/card"
import { Field, FieldLabel } from "@/components/ui/field"
import { Input } from "@/components/ui/input"

function SignIn({ register_href, forgot_password_href }: { register_href: string; forgot_password_href: string }) {
  const [showPassword, setShowPassword] = useState(false)

  return (
    <main className="mx-auto w-full max-w-md p-6 py-16">
      <Head title="Sign in" />

      <Card>
        <CardHeader className="text-center">
          <CardTitle>My account</CardTitle>
          <CardDescription>Sign in to see your orders, addresses and saved cards.</CardDescription>
        </CardHeader>

        <Form method="post" resetOnError={["password"]} className="contents">
          {({ processing, errors }) => (
            <>
              <CardContent className="flex flex-col gap-4">
                {(errors.base || errors.email || errors.password) && (
                  <Alert variant="destructive">
                    <CircleAlert />
                    <AlertDescription>{errors.base ?? errors.email ?? errors.password}</AlertDescription>
                  </Alert>
                )}

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
                      autoComplete="current-password"
                      required
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
                </Field>

                <div className="flex justify-end">
                  <Link href={forgot_password_href} className="text-primary hover:text-primary/70 text-sm font-medium">
                    Forgot password?
                  </Link>
                </div>

                <Button type="submit" size="lg" className="w-full" disabled={processing}>
                  Sign in
                </Button>
              </CardContent>
            </>
          )}
        </Form>

        <CardFooter className="justify-center">
          <p className="text-muted-foreground text-sm">
            Don&apos;t have an account?{" "}
            <Link href={register_href} className="text-primary hover:text-primary/70 font-medium">
              Sign up
            </Link>
          </p>
        </CardFooter>
      </Card>
    </main>
  )
}

function Tile({ href, icon, title, description }: { href: string; icon: React.ReactNode; title: string; description: string }) {
  return (
    <Link href={href}>
      <Card className="h-full transition-colors hover:border-foreground/20">
        <CardContent className="flex items-center gap-4 py-0">
          <div className="bg-muted rounded-xl p-3">{icon}</div>
          <div>
            <h2 className="text-lg font-medium">{title}</h2>
            <p className="text-muted-foreground mt-1 text-sm">{description}</p>
          </div>
        </CardContent>
      </Card>
    </Link>
  )
}

export default function Account(props: {
  signed_in: boolean
  orders_href?: string
  addresses_href?: string
  credit_cards_href?: string
  profile_href?: string
  register_href?: string
  forgot_password_href?: string
}) {
  if (!props.signed_in) {
    return <SignIn register_href={props.register_href!} forgot_password_href={props.forgot_password_href!} />
  }

  return (
    <main className="mx-auto w-full max-w-4xl p-6">
      <Head title="Account" />
      <h1 className="mb-6 text-2xl font-bold">Account overview</h1>

      <div className="grid grid-cols-1 gap-6 md:grid-cols-2">
        <Tile href={props.orders_href!} icon={<ShoppingBag className="text-primary size-6" />} title="Order history" description="Track and view your past orders" />
        <Tile href={props.addresses_href!} icon={<MapPin className="text-primary size-6" />} title="Addresses" description="Manage your shipping addresses" />
        <Tile href={props.credit_cards_href!} icon={<CreditCard className="text-primary size-6" />} title="Payment methods" description="Manage your saved cards" />
        <Tile href={props.profile_href!} icon={<User className="text-primary size-6" />} title="Profile" description="Update your personal information" />
      </div>
    </main>
  )
}
