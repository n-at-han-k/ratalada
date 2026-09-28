import { type ComponentProps } from "react"

import { AuthFooter } from "./auth-footer"
import { AuthHeader } from "./auth-header"
import { SignInForm } from "./sign-in-form"

type FormSubmitHandler = NonNullable<ComponentProps<"form">["onSubmit"]>
type FormSubmitEvent = Parameters<FormSubmitHandler>[0]

export function Auth() {
  function handleSubmit(event: FormSubmitEvent) {
    event.preventDefault()
  }

  return (
    <div className="flex min-h-svh w-full flex-col">
      {/* Header */}
      <AuthHeader />

      {/* Main Content */}
      <main className="flex flex-1 items-center justify-center px-6 py-10 sm:px-8 sm:py-12">
        <SignInForm onSubmit={handleSubmit} />
      </main>

      {/* Footer */}
      <AuthFooter />
    </div>
  )
}