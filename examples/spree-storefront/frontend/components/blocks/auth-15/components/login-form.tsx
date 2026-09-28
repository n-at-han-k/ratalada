import { type ComponentProps } from "react"

import { Button } from "@/components/ui/button"
import {
  Field,
  FieldDescription,
  FieldGroup,
  FieldLabel,
} from "@/components/ui/field"
import {
  InputGroup,
  InputGroupAddon,
  InputGroupInput,
} from "@/components/ui/input-group"
import { Separator } from "@/components/ui/separator"
import { AuthLogo } from "./auth-logo"
import { AUTH15_FOOTER_LINKS, AUTH15_SOCIAL_PROVIDERS } from "./data"
import { MailIcon, ArrowRightIcon } from "lucide-react"

type FormSubmitHandler = NonNullable<ComponentProps<"form">["onSubmit"]>
type FormSubmitEvent = Parameters<FormSubmitHandler>[0]

export function LoginForm({
  onSubmit,
}: {
  onSubmit: (event: FormSubmitEvent) => void
}) {
  return (
    <section className="flex min-h-svh w-full px-6 py-8 sm:px-8 sm:py-10">
      {/* Heading */}
      <div className="mx-auto flex w-full max-w-5xl flex-1 flex-col">
        <div className="flex justify-center">
          <AuthLogo />
        </div>

        <div className="flex flex-1 items-center justify-center py-10">
          <div className="flex w-full max-w-88 flex-col gap-6">
            <div className="mb-2 flex flex-col gap-1 text-center">
              <h1 className="text-3xl leading-tight font-semibold text-balance">
                Sign in
              </h1>
              <p className="text-muted-foreground text-base text-pretty">
                Enter your work email to get a magic link.
              </p>
            </div>

            <form className="flex flex-col gap-5" onSubmit={onSubmit}>
              <FieldGroup className="gap-4">
                <Field className="gap-2">
                  <FieldLabel className="sr-only" htmlFor="auth-15-email">
                    Work email
                  </FieldLabel>
                  <InputGroup className="bg-background">
                    <InputGroupAddon>
                      <MailIcon aria-hidden="true" className="size-4" />
                    </InputGroupAddon>
                    <InputGroupInput
                      id="auth-15-email"
                      type="email"
                      autoComplete="email"
                      placeholder="your@company.com"
                    />
                  </InputGroup>
                  <FieldDescription>
                    We&apos;ll email a secure sign-in link.
                  </FieldDescription>
                </Field>
              </FieldGroup>

              <Button type="submit" className="w-full">
                Send magic link
                <ArrowRightIcon aria-hidden="true" data-icon="inline-end" />
              </Button>
            </form>

            <div className="flex items-center gap-3">
              <Separator className="flex-1" />
              <span className="text-muted-foreground text-xs">
                Or continue with
              </span>
              <Separator className="flex-1" />
            </div>

            <div className="grid gap-3">
              {AUTH15_SOCIAL_PROVIDERS.map((provider) => (
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
          </div>
        </div>

        <footer className="text-muted-foreground flex flex-col items-center gap-5 text-center text-xs">
          <p className="max-w-[32rem] leading-5 text-pretty">
            By proceeding, you acknowledge that you have read, understood, and
            agree to ReUI&apos;s{" "}
            <a
              href="#"
              className="text-foreground hover:text-primary underline underline-offset-4 transition-colors"
            >
              Terms and Conditions
            </a>
            , including our sign-in and account access policies.
          </p>

          <div className="flex flex-wrap items-center justify-center gap-x-4 gap-y-2">
            <span className="whitespace-nowrap">© 2026 ReUI</span>

            {AUTH15_FOOTER_LINKS.map((link) => (
              <a
                key={link.id}
                href={link.href}
                className="text-foreground hover:text-primary underline underline-offset-4 transition-colors"
              >
                {link.label}
              </a>
            ))}
          </div>
        </footer>
      </div>
    </section>
  )
}