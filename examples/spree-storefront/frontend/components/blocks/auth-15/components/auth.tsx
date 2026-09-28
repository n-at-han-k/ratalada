import { type ComponentProps } from "react"

import { LoginForm } from "./login-form"

type FormSubmitHandler = NonNullable<ComponentProps<"form">["onSubmit"]>
type FormSubmitEvent = Parameters<FormSubmitHandler>[0]

export function Auth() {
  function handleSubmit(event: FormSubmitEvent) {
    event.preventDefault()
  }

  return <LoginForm onSubmit={handleSubmit} />
}