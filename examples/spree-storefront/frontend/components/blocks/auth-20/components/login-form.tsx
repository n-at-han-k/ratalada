import { type ComponentProps } from "react"

import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader } from "@/components/ui/card"
import { Field, FieldGroup, FieldLabel } from "@/components/ui/field"
import { Input } from "@/components/ui/input"
import {
  InputGroup,
  InputGroupAddon,
  InputGroupButton,
  InputGroupInput,
} from "@/components/ui/input-group"
import { Separator } from "@/components/ui/separator"
import { AuthLogo } from "./auth-logo"
import { AUTH_PROVIDERS } from "./data"
import { EyeOffIcon, EyeIcon } from "lucide-react"

type FormSubmitHandler = NonNullable<ComponentProps<"form">["onSubmit"]>
type FormSubmitEvent = Parameters<FormSubmitHandler>[0]

export function LoginForm({
  showPassword,
  onTogglePassword,
  onSubmit,
}: {
  showPassword: boolean
  onTogglePassword: () => void
  onSubmit: (event: FormSubmitEvent) => void
}) {
  return (
    <div className="flex w-full max-w-[26rem] flex-col gap-5">
      {/* Card */}
      <Card className="w-full gap-0 overflow-hidden p-0 shadow-sm">
        <CardHeader className="flex flex-col items-center gap-4 px-6 pt-8 pb-0 text-center sm:px-8 sm:pt-9">
          <AuthLogo />
          <div className="flex flex-col gap-1.5">
            <h1 className="text-xl font-semibold text-balance">Welcome back</h1>
            <p className="text-muted-foreground text-sm text-pretty">
              Sign in to continue to your workspace.
            </p>
          </div>
        </CardHeader>

        <CardContent className="flex flex-col gap-6 px-6 pt-6 pb-6 sm:px-8 sm:pt-7 sm:pb-8">
          <div className="grid gap-3 sm:grid-cols-2">
            {AUTH_PROVIDERS.map((provider) => (
              <Button
                key={provider.id}
                type="button"
                variant="outline"
                className="w-full"
              >
                {provider.logo}
                {provider.label}
              </Button>
            ))}
          </div>

          <div className="flex items-center gap-3">
            <Separator className="flex-1" />
            <span className="text-muted-foreground text-xs">
              Or sign in with email
            </span>
            <Separator className="flex-1" />
          </div>

          <form className="flex flex-col gap-5" onSubmit={onSubmit}>
            <FieldGroup className="gap-4">
              <Field className="gap-2">
                <FieldLabel htmlFor="auth-20-identifier">
                  Email or username
                </FieldLabel>
                <Input
                  id="auth-20-identifier"
                  type="text"
                  autoComplete="username"
                  placeholder="Email or username"
                />
              </Field>

              <Field className="gap-2">
                <div className="flex items-center justify-between gap-3">
                  <FieldLabel htmlFor="auth-20-password">Password</FieldLabel>
                  <Button
                    type="button"
                    variant="link"
                    className="text-muted-foreground h-auto cursor-pointer p-0 text-xs font-normal"
                  >
                    Forgot password?
                  </Button>
                </div>

                <InputGroup className="w-full">
                  <InputGroupInput
                    id="auth-20-password"
                    type={showPassword ? "text" : "password"}
                    autoComplete="current-password"
                    placeholder="Enter your password"
                  />
                  <InputGroupAddon align="inline-end">
                    <InputGroupButton
                      type="button"
                      size="icon-xs"
                      className="text-muted-foreground"
                      aria-label={
                        showPassword ? "Hide password" : "Show password"
                      }
                      aria-pressed={showPassword}
                      onClick={onTogglePassword}
                    >
                      {showPassword ? (
                        <EyeOffIcon aria-hidden="true" />
                      ) : (
                        <EyeIcon aria-hidden="true" />
                      )}
                    </InputGroupButton>
                  </InputGroupAddon>
                </InputGroup>
              </Field>
            </FieldGroup>

            <Button type="submit" className="w-full">
              Sign in
            </Button>
          </form>
        </CardContent>
      </Card>

      <p className="text-muted-foreground text-center text-sm">
        Don&apos;t have an account?{" "}
        <Button
          type="button"
          variant="link"
          className="h-auto cursor-pointer p-0"
        >
          Create account
        </Button>
      </p>
    </div>
  )
}