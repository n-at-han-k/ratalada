import { type ComponentProps } from "react"

import { Button } from "@/components/ui/button"
import { Field, FieldGroup, FieldLabel } from "@/components/ui/field"
import { Input } from "@/components/ui/input"
import { Separator } from "@/components/ui/separator"
import { AUTH16_PROVIDERS } from "./data"
import { ArrowRightIcon } from "lucide-react"

type FormSubmitHandler = NonNullable<ComponentProps<"form">["onSubmit"]>
type FormSubmitEvent = Parameters<FormSubmitHandler>[0]

export function SignInForm({
  onSubmit,
}: {
  onSubmit: (event: FormSubmitEvent) => void
}) {
  return (
    <div className="flex w-full max-w-sm flex-col gap-6">
      {/* Heading */}
      <div className="flex flex-col gap-1.5 text-center">
        <h1 className="text-2xl font-semibold tracking-tight text-balance sm:text-[1.6875rem]">
          Back to building.
        </h1>
        <p className="text-muted-foreground text-sm text-pretty">
          Sign in to sync your team, tasks, and timelines across every surface.
        </p>
      </div>

      {/* Grid */}
      <div className="grid gap-2.5">
        {AUTH16_PROVIDERS.map((provider) => (
          <Button
            key={provider.id}
            type="button"
            variant="outline"
            className="w-full justify-center px-4 [&_svg:not([class*='size-'])]:size-4"
          >
            {provider.logo}
            {provider.label}
          </Button>
        ))}
      </div>

      <div className="flex items-center gap-3">
        <Separator className="flex-1" />
        <span className="text-muted-foreground text-xs">or</span>
        <Separator className="flex-1" />
      </div>

      {/* Form */}
      <form className="flex flex-col gap-4" onSubmit={onSubmit}>
        <FieldGroup>
          <Field className="gap-2">
            <FieldLabel htmlFor="auth-16-email">
              Work email
            </FieldLabel>
            <Input
              id="auth-16-email"
              type="email"
              autoComplete="email"
              placeholder="you@company.com"
            />
          </Field>
        </FieldGroup>

        <Button type="submit" className="w-full">
          Continue
          <ArrowRightIcon aria-hidden="true" data-icon="inline-end" />
        </Button>
      </form>

      <p className="text-muted-foreground text-center text-xs leading-5 text-pretty">
        By continuing, you agree to ReUI&apos;s{" "}
        <a
          href="#"
          className="text-foreground hover:text-primary underline underline-offset-4 transition-colors"
        >
          Terms of Service
        </a>{" "}
        and{" "}
        <a
          href="#"
          className="text-foreground hover:text-primary underline underline-offset-4 transition-colors"
        >
          Privacy Policy
        </a>
        .
      </p>
    </div>
  )
}