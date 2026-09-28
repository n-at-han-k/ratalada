"use client"

import { useState, type ComponentProps } from "react"

import { LoginForm } from "./login-form"

type FormSubmitHandler = NonNullable<ComponentProps<"form">["onSubmit"]>
type FormSubmitEvent = Parameters<FormSubmitHandler>[0]

export function Auth() {
  const [showPassword, setShowPassword] = useState(false)

  function handleSubmit(event: FormSubmitEvent) {
    event.preventDefault()
  }

  return (
    <LoginForm
      showPassword={showPassword}
      onTogglePassword={() => setShowPassword((current) => !current)}
      onSubmit={handleSubmit}
    />
  )
}