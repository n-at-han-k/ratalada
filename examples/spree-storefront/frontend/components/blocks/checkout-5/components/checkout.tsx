import { useState, type FormEvent, type ReactNode } from "react"
import {
  Alert,
  AlertDescription,
  AlertTitle,
} from "@/components/reui/alert"
import { Badge } from "@/components/reui/badge"
import {
  Frame,
  FrameDescription,
  FrameFooter,
  FrameHeader,
  FramePanel,
  FrameTitle,
} from "@/components/reui/frame"
import {
  Stepper,
  StepperIndicator,
  StepperItem,
  StepperNav,
  StepperSeparator,
  StepperTitle,
  StepperTrigger,
} from "@/components/reui/stepper"
import { cn } from "cn"
import { AnimatePresence, motion, useReducedMotion } from "motion/react"
import { toast } from "sonner"

import { Button } from "@/components/ui/button"
import { Checkbox } from "@/components/ui/checkbox"
import {
  Combobox,
  ComboboxContent,
  ComboboxEmpty,
  ComboboxInput,
  ComboboxItem,
  ComboboxList,
  ComboboxTrigger,
  ComboboxValue,
} from "@/components/ui/combobox"
import {
  Field,
  FieldContent,
  FieldDescription,
  FieldError,
  FieldGroup,
  FieldLabel,
  FieldLegend,
  FieldSet,
} from "@/components/ui/field"
import { Input } from "@/components/ui/input"
import {
  Item,
  ItemActions,
  ItemContent,
  ItemDescription,
  ItemGroup,
  ItemMedia,
  ItemTitle,
} from "@/components/ui/item"
import {
  RadioGroup,
  RadioGroupItem,
} from "@/components/ui/radio-group"
import { Separator } from "@/components/ui/separator"
import { Spinner } from "@/components/ui/spinner"
import {
  CHECKOUT_ITEMS,
  CHECKOUT_STEPS,
  COUNTRY_OPTIONS,
  DEFAULT_CHECKOUT_VALUES,
  DELIVERY_OPTIONS,
  PAYMENT_METHODS,
  PROMO_CODE,
  PROMO_DISCOUNT,
  SAVED_ADDRESSES,
  TAX_RATE,
  type AddressId,
  type CheckoutItem,
  type CheckoutStepId,
  type CheckoutValues,
  type CountryOption,
  type DeliveryOptionId,
  type PaymentMethodId,
} from "./data"
import { CheckIcon, ChevronRightIcon, ArrowRightIcon, InfoIcon, CircleCheckIcon, Trash2Icon, ArrowLeftIcon } from "lucide-react"

const TOTAL_STEPS = CHECKOUT_STEPS.length
const FORM_ID = "checkout-5-form"

type CheckoutErrors = Partial<Record<keyof CheckoutValues, string>>
type PromoStatus = "idle" | "applied" | "invalid"

function copyCheckoutValues() {
  return { ...DEFAULT_CHECKOUT_VALUES }
}

function formatCurrency(value: number) {
  return new Intl.NumberFormat("en-US", {
    style: "currency",
    currency: "USD",
  }).format(value)
}

function getCartSubtotal(items: CheckoutItem[]) {
  return items.reduce((total, item) => total + item.price * item.quantity, 0)
}

function getSelectedAddress(addressId: AddressId) {
  return (
    SAVED_ADDRESSES.find((address) => address.id === addressId) ??
    SAVED_ADDRESSES[0]
  )
}

function getSelectedDelivery(deliveryId: DeliveryOptionId) {
  return (
    DELIVERY_OPTIONS.find((option) => option.id === deliveryId) ??
    DELIVERY_OPTIONS[0]
  )
}

function getSelectedPaymentMethod(paymentMethodId: PaymentMethodId) {
  return (
    PAYMENT_METHODS.find((method) => method.id === paymentMethodId) ??
    PAYMENT_METHODS[0]
  )
}

function getSelectedCountry(countryValue: string) {
  return (
    COUNTRY_OPTIONS.find((country) => country.value === countryValue) ??
    COUNTRY_OPTIONS[0]
  )
}

function getOrderSummary(
  values: CheckoutValues,
  promoStatus: PromoStatus,
  items: CheckoutItem[]
) {
  const delivery = getSelectedDelivery(values.deliveryId)
  const subtotal = getCartSubtotal(items)
  const deliveryPrice = subtotal > 0 ? delivery.price : 0
  const discount =
    promoStatus === "applied" ? Math.min(PROMO_DISCOUNT, subtotal) : 0
  const taxableAmount = Math.max(subtotal + deliveryPrice - discount, 0)
  const tax = taxableAmount * TAX_RATE

  return {
    subtotal,
    delivery: deliveryPrice,
    discount,
    tax,
    total: taxableAmount + tax,
  }
}

function getStepErrors(
  stepId: CheckoutStepId,
  values: CheckoutValues
): CheckoutErrors {
  const errors: CheckoutErrors = {}
  const cardDigits = values.cardNumber.replace(/\D/g, "")

  if (stepId === "contact") {
    if (!values.firstName.trim()) {
      errors.firstName = "Enter a first name."
    }
    if (!values.lastName.trim()) {
      errors.lastName = "Enter a last name."
    }
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(values.email.trim())) {
      errors.email = "Enter a valid email address."
    }
  }

  if (stepId === "delivery") {
    if (!values.addressId) {
      errors.addressId = "Choose a delivery address."
    }
    if (!values.deliveryId) {
      errors.deliveryId = "Choose a delivery speed."
    }
  }

  if (stepId === "payment") {
    if (!values.paymentMethodId) {
      errors.paymentMethodId = "Choose a payment method."
    }
    if (values.paymentMethodId === "card") {
      if (!values.cardName.trim()) {
        errors.cardName = "Enter the name on card."
      }
      if (cardDigits.length < 12) {
        errors.cardNumber = "Enter a valid card number."
      }
      if (!/^\d{2}\/\d{2}$/.test(values.expiry.trim())) {
        errors.expiry = "Use MM/YY format."
      }
      if (values.cvc.replace(/\D/g, "").length < 3) {
        errors.cvc = "Enter the security code."
      }
    }
  }

  if (stepId === "review" && !values.acceptTerms) {
    errors.acceptTerms = "Confirm the order details before placing the order."
  }

  return errors
}

function getFirstInvalidStep(values: CheckoutValues) {
  for (const step of CHECKOUT_STEPS) {
    const errors = getStepErrors(step.id, values)

    if (Object.keys(errors).length > 0) {
      return step.step
    }
  }

  return null
}

function ErrorLine({ children }: { children?: ReactNode }) {
  if (!children) return null

  return <FieldError>{children}</FieldError>
}

function DotSeparator() {
  return (
    <span
      aria-hidden="true"
      className="bg-muted-foreground/40 size-1 shrink-0 rounded-full"
    />
  )
}

function CheckoutProgressStepper({
  currentStep,
  compact = false,
}: {
  currentStep: number
  compact?: boolean
}) {
  return (
    <Stepper
      value={currentStep}
      aria-label="Checkout steps"
      indicators={{
        completed: (
          <CheckIcon className="size-3.5" aria-hidden="true" />
        ),
        loading: <Spinner className="size-3.5" />,
      }}
      className="w-full"
    >
      <StepperNav aria-label="Checkout progress" className="items-center">
        {CHECKOUT_STEPS.map((step, index) => (
          <StepperItem
            key={step.id}
            step={step.step}
            className="relative min-w-0"
          >
            <StepperTrigger
              type="button"
              tabIndex={-1}
              className="pointer-events-none min-w-0 cursor-default justify-start gap-1.5 disabled:opacity-100"
            >
              <StepperIndicator className="data-[state=active]:border-primary/10 data-[state=active]:bg-primary/10 data-[state=active]:text-primary data-[state=completed]:bg-primary data-[state=inactive]:border-border data-[state=inactive]:bg-muted data-[state=inactive]:text-foreground data-[state=active]:before:border-primary relative isolate size-6 overflow-visible before:pointer-events-none before:absolute before:inset-0 before:z-10 before:rounded-md before:border before:border-dashed before:border-transparent before:content-[''] data-[state=active]:before:animate-[spin_8s_linear_infinite] motion-reduce:data-[state=active]:before:animate-none">
                {index + 1}
                {compact ? <span className="sr-only">{step.title}</span> : null}
              </StepperIndicator>
              {!compact ? (
                <StepperTitle className="text-foreground truncate text-sm">
                  {step.title}
                </StepperTitle>
              ) : null}
            </StepperTrigger>
            {CHECKOUT_STEPS.length > index + 1 ? (
              <StepperSeparator
                className={cn(
                  "bg-border group-data-[state=completed]/step:bg-primary",
                  compact ? "mx-2" : "md:mx-2.5"
                )}
              />
            ) : null}
          </StepperItem>
        ))}
      </StepperNav>
    </Stepper>
  )
}

function CheckoutHeader({ currentStep }: { currentStep: number }) {
  return (
    <header className="flex flex-col">
      <div className="flex min-w-0 flex-col gap-3">
        <div className="flex min-w-0 flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
          <nav
            aria-label="Breadcrumb"
            className="text-muted-foreground flex flex-wrap items-center gap-1.5 text-sm"
          >
            <a
              href="#"
              className="hover:text-primary underline-offset-4 transition-colors hover:underline"
            >
              Store
            </a>
            <ChevronRightIcon className="size-3.5" aria-hidden="true" />
            <a
              href="#"
              className="hover:text-primary underline-offset-4 transition-colors hover:underline"
            >
              Bag
            </a>
            <ChevronRightIcon className="size-3.5" aria-hidden="true" />
            <span className="text-foreground">Checkout</span>
          </nav>

          <Button
            type="button"
            variant="ghost"
            size="sm"
            className="text-muted-foreground hover:text-foreground -mr-2 w-fit shrink-0"
          >
            Continue Shopping
            <ArrowRightIcon data-icon="inline-end" aria-hidden="true" />
          </Button>
        </div>

        <div className="max-w-xl">
          <h1 className="text-xl font-semibold tracking-tight sm:text-2xl">
            Checkout
          </h1>
          <p className="text-muted-foreground mt-0.5 text-sm leading-5">
            Confirm shipping, payment, and order details.
          </p>
        </div>
      </div>

      <div className="w-full py-6">
        <div className="hidden sm:block">
          <CheckoutProgressStepper currentStep={currentStep} />
        </div>
        <div className="sm:hidden">
          <CheckoutProgressStepper currentStep={currentStep} compact />
        </div>
      </div>
    </header>
  )
}

function SectionHeading({
  id,
  title,
  description,
}: {
  id: string
  title: string
  description: string
}) {
  return (
    <div className="flex min-w-0 flex-col gap-0.5">
      <h2 id={id} className="text-base font-semibold">
        {title}
      </h2>
      <p className="text-muted-foreground max-w-xl text-sm leading-5">
        {description}
      </p>
    </div>
  )
}

function CustomerAccountOptions({
  values,
  onValueChange,
}: {
  values: CheckoutValues
  onValueChange: <TField extends keyof CheckoutValues>(
    field: TField,
    value: CheckoutValues[TField]
  ) => void
}) {
  function handleSignIn() {
    if (!values.loginEmail.trim() || !values.loginPassword.trim()) {
      toast.message("Add account details", {
        description: "Enter an email and password to sign in.",
      })
      return
    }

    toast.success("Signed in for checkout", {
      description: "Saved account details are ready for this order.",
    })
  }

  function handlePasswordReset() {
    toast.info("Password reset link ready", {
      description: `We will send recovery steps to ${values.loginEmail || "your account email"}.`,
    })
  }

  function handleCreateAccount() {
    if (!values.createAccount) {
      onValueChange("createAccount", true)
    }

    if (values.createPassword.trim().length < 8) {
      toast.message("Add a password", {
        description: "Use at least 8 characters to create an account.",
      })
      return
    }

    toast.success("Account will be created", {
      description:
        "Your new account will be attached after the order is placed.",
    })
  }

  return (
    <FieldSet
      className="gap-4 border-t pt-5"
      aria-labelledby="checkout-5-account-title"
    >
      <FieldLegend className="sr-only">Account options</FieldLegend>
      <SectionHeading
        id="checkout-5-account-title"
        title="Account Options"
        description="Sign in with saved details, or save this order for next time."
      />

      <ItemGroup className="grid items-start gap-3 xl:grid-cols-2">
        <Item
          role="listitem"
          variant="outline"
          size="sm"
          className="items-start gap-0 p-4 sm:p-5"
        >
          <ItemContent className="min-w-0 gap-4">
            <div className="min-w-0">
              <ItemTitle>Returning Customer</ItemTitle>
              <ItemDescription>Use saved checkout details.</ItemDescription>
            </div>

            <FieldGroup className="gap-3">
              <Field className="gap-2">
                <FieldLabel htmlFor="checkout-5-login-email">Email</FieldLabel>
                <Input
                  id="checkout-5-login-email"
                  type="email"
                  value={values.loginEmail}
                  autoComplete="email"
                  placeholder="you@example.com"
                  onChange={(event) =>
                    onValueChange("loginEmail", event.target.value)
                  }
                />
              </Field>
              <Field className="gap-2">
                <div className="flex items-center justify-between gap-3">
                  <FieldLabel htmlFor="checkout-5-login-password">
                    Password
                  </FieldLabel>
                  <Button
                    type="button"
                    variant="link"
                    className="hover:text-primary h-auto p-0 text-sm font-normal underline-offset-4 hover:underline"
                    onClick={handlePasswordReset}
                  >
                    Reset Password
                  </Button>
                </div>
                <Input
                  id="checkout-5-login-password"
                  type="password"
                  value={values.loginPassword}
                  autoComplete="current-password"
                  placeholder="Enter password"
                  onChange={(event) =>
                    onValueChange("loginPassword", event.target.value)
                  }
                />
              </Field>
            </FieldGroup>

            <Button
              type="button"
              variant="secondary"
              className="w-full justify-center"
              onClick={handleSignIn}
            >
              Sign In
              <ArrowRightIcon data-icon="inline-end" aria-hidden="true" />
            </Button>
          </ItemContent>
        </Item>

        <Item
          role="listitem"
          variant="outline"
          size="sm"
          className={cn(
            "items-start gap-0 p-4 transition-colors sm:p-5",
            values.createAccount && "border-primary bg-primary/5"
          )}
        >
          <ItemContent className="min-w-0 gap-4">
            <div className="min-w-0">
              <ItemTitle>Create Account</ItemTitle>
              <ItemDescription>Save details for next time.</ItemDescription>
            </div>

            <Field orientation="horizontal" className="items-start gap-3">
              <Checkbox
                id="checkout-5-create-account"
                checked={values.createAccount}
                onCheckedChange={(checked) =>
                  onValueChange("createAccount", checked === true)
                }
              />
              <FieldContent className="gap-1">
                <FieldLabel htmlFor="checkout-5-create-account">
                  Create Account After Checkout
                </FieldLabel>
                <FieldDescription>
                  Uses {values.email || "your checkout email"}.
                </FieldDescription>
              </FieldContent>
            </Field>

            <FieldGroup className="gap-3">
              <Field className="gap-2">
                <FieldLabel htmlFor="checkout-5-create-password">
                  New Password
                </FieldLabel>
                <Input
                  id="checkout-5-create-password"
                  type="password"
                  value={values.createPassword}
                  autoComplete="new-password"
                  placeholder="8+ characters"
                  onChange={(event) =>
                    onValueChange("createPassword", event.target.value)
                  }
                />
              </Field>
              <Field orientation="horizontal" className="items-start gap-3">
                <Checkbox
                  id="checkout-5-email-offers"
                  checked={values.emailOffers}
                  onCheckedChange={(checked) =>
                    onValueChange("emailOffers", checked === true)
                  }
                />
                <FieldContent className="gap-1">
                  <FieldLabel htmlFor="checkout-5-email-offers">
                    Email Order Perks
                  </FieldLabel>
                </FieldContent>
              </Field>
            </FieldGroup>

            <Button
              type="button"
              variant="secondary"
              className="w-full justify-center"
              onClick={handleCreateAccount}
            >
              Create Account
              <ArrowRightIcon data-icon="inline-end" aria-hidden="true" />
            </Button>
          </ItemContent>
        </Item>
      </ItemGroup>
    </FieldSet>
  )
}

function CountryFlag({
  country,
  className,
}: {
  country: CountryOption
  className?: string
}) {
  return (
    <img
      src={`https://flagcdn.com/w40/${country.code.toLowerCase()}.png`}
      alt=""
      width={16}
      height={12}
      loading="eager"
      className={cn(
        "block h-3 w-4 shrink-0 rounded-xs object-cover",
        className
      )}
    />
  )
}

function CountryLabel({ country }: { country: CountryOption }) {
  return (
    <span className="flex min-w-0 items-center gap-2">
      <CountryFlag country={country} />
      <span className="truncate">{country.label}</span>
    </span>
  )
}

function CountryCombobox({
  id,
  value,
  onValueChange,
}: {
  id: string
  value: string
  onValueChange: (value: string) => void
}) {
  const selectedCountry = getSelectedCountry(value)

  return (
    <Combobox
      items={COUNTRY_OPTIONS}
      value={selectedCountry}
      onValueChange={(nextCountry) => {
        if (nextCountry) {
          onValueChange((nextCountry as CountryOption).value)
        }
      }}
      itemToStringValue={(country: CountryOption) => country.label}
      autoHighlight
    >
      <ComboboxTrigger
        render={
          <Button
            id={id}
            type="button"
            variant="outline"
            className="w-full justify-between font-normal"
          />
        }
      >
        <ComboboxValue placeholder="Country">
          {(country: CountryOption | null) =>
            country ? (
              <CountryLabel country={country} />
            ) : (
              <span className="text-muted-foreground">Country</span>
            )
          }
        </ComboboxValue>
      </ComboboxTrigger>
      <ComboboxContent className="max-w-(--anchor-width) min-w-(--anchor-width)">
        <ComboboxInput showTrigger={false} placeholder="Search countries" />
        <ComboboxEmpty>No countries found.</ComboboxEmpty>
        <ComboboxList>
          {(country: CountryOption) => (
            <ComboboxItem key={country.value} value={country}>
              <CountryLabel country={country} />
            </ComboboxItem>
          )}
        </ComboboxList>
      </ComboboxContent>
    </Combobox>
  )
}

function ContactStep({
  values,
  errors,
  onValueChange,
}: {
  values: CheckoutValues
  errors: CheckoutErrors
  onValueChange: <TField extends keyof CheckoutValues>(
    field: TField,
    value: CheckoutValues[TField]
  ) => void
}) {
  return (
    <section
      className="flex min-w-0 flex-col gap-5"
      aria-labelledby="checkout-5-contact-title"
    >
      <SectionHeading
        id="checkout-5-contact-title"
        title="Customer Details"
        description="Used for receipts and order updates."
      />

      <FieldSet className="gap-0">
        <FieldLegend className="sr-only">Customer information</FieldLegend>
        <FieldDescription className="sr-only">
          Enter the buyer name, email, phone, and country.
        </FieldDescription>

        <FieldGroup className="grid gap-4 sm:grid-cols-2">
          <Field data-invalid={Boolean(errors.firstName)}>
            <FieldLabel htmlFor="checkout-5-first-name">First Name</FieldLabel>
            <Input
              id="checkout-5-first-name"
              value={values.firstName}
              autoComplete="given-name"
              aria-invalid={Boolean(errors.firstName)}
              onChange={(event) =>
                onValueChange("firstName", event.target.value)
              }
            />
            <ErrorLine>{errors.firstName}</ErrorLine>
          </Field>
          <Field data-invalid={Boolean(errors.lastName)}>
            <FieldLabel htmlFor="checkout-5-last-name">Last Name</FieldLabel>
            <Input
              id="checkout-5-last-name"
              value={values.lastName}
              autoComplete="family-name"
              aria-invalid={Boolean(errors.lastName)}
              onChange={(event) =>
                onValueChange("lastName", event.target.value)
              }
            />
            <ErrorLine>{errors.lastName}</ErrorLine>
          </Field>

          <Field data-invalid={Boolean(errors.email)}>
            <FieldLabel htmlFor="checkout-5-email">Email</FieldLabel>
            <Input
              id="checkout-5-email"
              type="email"
              value={values.email}
              autoComplete="email"
              aria-invalid={Boolean(errors.email)}
              onChange={(event) => onValueChange("email", event.target.value)}
            />
            <ErrorLine>{errors.email}</ErrorLine>
          </Field>

          <Field>
            <FieldLabel htmlFor="checkout-5-phone">Phone</FieldLabel>
            <Input
              id="checkout-5-phone"
              value={values.phone}
              autoComplete="tel"
              onChange={(event) => onValueChange("phone", event.target.value)}
            />
          </Field>
          <Field>
            <FieldLabel htmlFor="checkout-5-country">Country</FieldLabel>
            <CountryCombobox
              id="checkout-5-country"
              value={values.country}
              onValueChange={(country) => onValueChange("country", country)}
            />
          </Field>
        </FieldGroup>
      </FieldSet>

      <CustomerAccountOptions values={values} onValueChange={onValueChange} />
    </section>
  )
}

function DeliveryStep({
  values,
  errors,
  onValueChange,
}: {
  values: CheckoutValues
  errors: CheckoutErrors
  onValueChange: <TField extends keyof CheckoutValues>(
    field: TField,
    value: CheckoutValues[TField]
  ) => void
}) {
  return (
    <section
      className="flex min-w-0 flex-col gap-6"
      aria-labelledby="checkout-5-delivery-title"
    >
      <SectionHeading
        id="checkout-5-delivery-title"
        title="Delivery"
        description="Pick the destination and how fast it should arrive."
      />

      <FieldSet className="gap-3">
        <FieldLegend
          variant="label"
          className="flex w-full items-center justify-between gap-3"
        >
          <span>Ship To</span>
          <Button
            type="button"
            variant="link"
            className="hover:text-primary h-auto p-0 text-sm font-normal underline-offset-4 hover:underline"
          >
            Manage Address
          </Button>
        </FieldLegend>
        <RadioGroup
          name="checkout-address"
          value={values.addressId}
          onValueChange={(value) =>
            onValueChange("addressId", value as AddressId)
          }
          aria-invalid={Boolean(errors.addressId)}
        >
          <ItemGroup className="grid gap-3 sm:grid-cols-2">
            {SAVED_ADDRESSES.map((address) => {
              const selected = values.addressId === address.id
              const id = `checkout-5-address-${address.id}`

              return (
                <Item
                  key={address.id}
                  role="listitem"
                  variant="outline"
                  size="sm"
                  className={cn(
                    "hover:bg-muted/50 h-full gap-3 transition-colors",
                    selected && "bg-muted/70"
                  )}
                >
                  <Field
                    orientation="horizontal"
                    data-invalid={Boolean(errors.addressId)}
                    className="w-full items-start gap-3"
                  >
                    <RadioGroupItem
                      id={id}
                      value={address.id}
                      aria-invalid={Boolean(errors.addressId)}
                      className="mt-1"
                    />
                    <FieldLabel
                      htmlFor={id}
                      className="min-w-0 flex-1 items-start"
                    >
                      <span className="flex min-w-0 flex-col gap-1">
                        <span className="font-medium">{address.label}</span>
                        <span className="text-muted-foreground text-sm leading-5 font-normal">
                          {address.recipient}
                          <br />
                          {address.line1}
                          <br />
                          {address.line2}
                        </span>
                      </span>
                    </FieldLabel>
                    {address.isDefault ? (
                      <Badge variant="primary-light" className="mt-0.5">
                        Default
                      </Badge>
                    ) : null}
                  </Field>
                </Item>
              )
            })}
          </ItemGroup>
        </RadioGroup>
        <ErrorLine>{errors.addressId}</ErrorLine>
      </FieldSet>

      <FieldSet className="gap-3">
        <FieldLegend variant="label">Delivery Speed</FieldLegend>
        <RadioGroup
          name="checkout-delivery"
          value={values.deliveryId}
          onValueChange={(value) =>
            onValueChange("deliveryId", value as DeliveryOptionId)
          }
          aria-invalid={Boolean(errors.deliveryId)}
        >
          <ItemGroup className="gap-2">
            {DELIVERY_OPTIONS.map((option) => {
              const selected = values.deliveryId === option.id
              const id = `checkout-5-delivery-${option.id}`

              return (
                <Item
                  key={option.id}
                  role="listitem"
                  variant="outline"
                  size="sm"
                  className={cn(
                    "hover:bg-muted/50 gap-3 transition-colors",
                    selected && "bg-muted/70"
                  )}
                >
                  <Field
                    orientation="horizontal"
                    data-invalid={Boolean(errors.deliveryId)}
                    className="w-full flex-wrap items-start gap-3 sm:flex-nowrap"
                  >
                    <RadioGroupItem
                      id={id}
                      value={option.id}
                      aria-invalid={Boolean(errors.deliveryId)}
                      className="mt-1"
                    />
                    <FieldLabel
                      htmlFor={id}
                      className="min-w-0 flex-1 items-start"
                    >
                      <span className="flex min-w-0 flex-col gap-0.5">
                        <span className="font-medium">{option.label}</span>
                        <span className="text-muted-foreground flex min-w-0 flex-wrap items-center gap-1.5 text-sm leading-5 font-normal">
                          <span>{option.description}</span>
                          <DotSeparator />
                          <span>{option.eta}</span>
                        </span>
                      </span>
                    </FieldLabel>
                    <span className="ml-auto shrink-0 text-right text-sm font-semibold tabular-nums">
                      {option.price === 0
                        ? "Free"
                        : formatCurrency(option.price)}
                    </span>
                  </Field>
                </Item>
              )
            })}
          </ItemGroup>
        </RadioGroup>
        <ErrorLine>{errors.deliveryId}</ErrorLine>
      </FieldSet>
    </section>
  )
}

function PaymentMethodMark({ children }: { children: ReactNode }) {
  return (
    <span className="text-foreground flex h-5 min-w-0 items-center">
      {children}
    </span>
  )
}

function PaymentStep({
  values,
  errors,
  onValueChange,
}: {
  values: CheckoutValues
  errors: CheckoutErrors
  onValueChange: <TField extends keyof CheckoutValues>(
    field: TField,
    value: CheckoutValues[TField]
  ) => void
}) {
  const selectedMethod = getSelectedPaymentMethod(values.paymentMethodId)

  return (
    <section
      className="flex min-w-0 flex-col gap-6"
      aria-labelledby="checkout-5-payment-title"
    >
      <SectionHeading
        id="checkout-5-payment-title"
        title="Payment Method"
        description="Card details stay in this form."
      />

      <FieldSet className="gap-3">
        <FieldLegend variant="label">Payment</FieldLegend>
        <RadioGroup
          name="checkout-payment"
          value={values.paymentMethodId}
          onValueChange={(value) =>
            onValueChange("paymentMethodId", value as PaymentMethodId)
          }
          aria-invalid={Boolean(errors.paymentMethodId)}
        >
          <ItemGroup className="grid gap-3 sm:grid-cols-3">
            {PAYMENT_METHODS.map((method) => {
              const selected = values.paymentMethodId === method.id
              const id = `checkout-5-payment-${method.id}`

              return (
                <Item
                  key={method.id}
                  role="listitem"
                  variant="outline"
                  size="sm"
                  className={cn(
                    "hover:bg-muted/50 h-full gap-3 transition-colors",
                    selected && "bg-muted/70"
                  )}
                >
                  <Field
                    orientation="horizontal"
                    data-invalid={Boolean(errors.paymentMethodId)}
                    className="w-full items-start gap-3"
                  >
                    <RadioGroupItem
                      id={id}
                      value={method.id}
                      aria-invalid={Boolean(errors.paymentMethodId)}
                      className="mt-1"
                    />
                    <FieldLabel
                      htmlFor={id}
                      className="min-w-0 flex-1 items-start"
                    >
                      <span className="flex min-w-0 flex-col gap-2.5">
                        <PaymentMethodMark>{method.mark}</PaymentMethodMark>
                        <span className="flex min-w-0 flex-col gap-0.5">
                          <span className="font-medium">{method.label}</span>
                          <span className="text-muted-foreground text-sm leading-5 font-normal">
                            {method.description}
                          </span>
                        </span>
                      </span>
                    </FieldLabel>
                  </Field>
                </Item>
              )
            })}
          </ItemGroup>
        </RadioGroup>
        <ErrorLine>{errors.paymentMethodId}</ErrorLine>
      </FieldSet>

      {values.paymentMethodId === "card" ? (
        <FieldGroup className="gap-4">
          <div className="grid gap-4 sm:grid-cols-2">
            <Field data-invalid={Boolean(errors.cardName)}>
              <FieldLabel htmlFor="checkout-5-card-name">
                Name On Card
              </FieldLabel>
              <Input
                id="checkout-5-card-name"
                value={values.cardName}
                autoComplete="cc-name"
                aria-invalid={Boolean(errors.cardName)}
                onChange={(event) =>
                  onValueChange("cardName", event.target.value)
                }
              />
              <ErrorLine>{errors.cardName}</ErrorLine>
            </Field>
            <Field data-invalid={Boolean(errors.cardNumber)}>
              <FieldLabel htmlFor="checkout-5-card-number">
                Card Number
              </FieldLabel>
              <Input
                id="checkout-5-card-number"
                inputMode="numeric"
                value={values.cardNumber}
                autoComplete="cc-number"
                aria-invalid={Boolean(errors.cardNumber)}
                onChange={(event) =>
                  onValueChange("cardNumber", event.target.value)
                }
              />
              <ErrorLine>{errors.cardNumber}</ErrorLine>
            </Field>
          </div>

          <div className="grid gap-4 sm:grid-cols-2">
            <Field data-invalid={Boolean(errors.expiry)}>
              <FieldLabel htmlFor="checkout-5-expiry">Expiry</FieldLabel>
              <Input
                id="checkout-5-expiry"
                inputMode="numeric"
                value={values.expiry}
                placeholder="MM/YY"
                autoComplete="cc-exp"
                aria-invalid={Boolean(errors.expiry)}
                onChange={(event) =>
                  onValueChange("expiry", event.target.value.slice(0, 5))
                }
              />
              <ErrorLine>{errors.expiry}</ErrorLine>
            </Field>
            <Field data-invalid={Boolean(errors.cvc)}>
              <FieldLabel htmlFor="checkout-5-cvc">CVC</FieldLabel>
              <Input
                id="checkout-5-cvc"
                inputMode="numeric"
                value={values.cvc}
                autoComplete="cc-csc"
                aria-invalid={Boolean(errors.cvc)}
                onChange={(event) =>
                  onValueChange(
                    "cvc",
                    event.target.value.replace(/\D/g, "").slice(0, 4)
                  )
                }
              />
              <ErrorLine>{errors.cvc}</ErrorLine>
            </Field>
          </div>
          <Field orientation="horizontal" className="items-start gap-3">
            <Checkbox
              id="checkout-5-save-payment"
              checked={values.savePayment}
              onCheckedChange={(checked) =>
                onValueChange("savePayment", checked === true)
              }
            />
            <FieldContent className="gap-1">
              <FieldLabel htmlFor="checkout-5-save-payment">
                Save Card
              </FieldLabel>
              <FieldDescription>
                Use this payment method faster next time.
              </FieldDescription>
            </FieldContent>
          </Field>
        </FieldGroup>
      ) : (
        <Alert
          variant={values.paymentMethodId === "apple-pay" ? "warning" : "info"}
        >
          <InfoIcon aria-hidden="true" />
          <AlertTitle>{selectedMethod.label} Selected</AlertTitle>
          <AlertDescription>
            <p>
              You will confirm with {selectedMethod.label} after reviewing the
              order total.
            </p>
          </AlertDescription>
        </Alert>
      )}
    </section>
  )
}

function ReviewRow({
  label,
  value,
  detail,
  onEdit,
}: {
  label: string
  value: string
  detail?: string
  onEdit: () => void
}) {
  return (
    <Item
      render={<button type="button" />}
      variant="outline"
      size="sm"
      className="hover:bg-muted/50 group/review cursor-pointer gap-3 text-left"
      onClick={onEdit}
    >
      <ItemContent className="min-w-0 gap-0.5">
        <ItemTitle className="text-muted-foreground text-sm font-normal">
          {label}
        </ItemTitle>
      </ItemContent>
      <ItemActions className="min-w-0 shrink-0 gap-2">
        <span className="min-w-0 text-right">
          <span className="block truncate text-sm font-medium">{value}</span>
          {detail ? (
            <span className="text-muted-foreground block truncate text-xs">
              {detail}
            </span>
          ) : null}
        </span>
        <ArrowRightIcon className="text-muted-foreground size-4 shrink-0 transition-transform duration-150 ease-out group-hover/review:translate-x-0.5" aria-hidden="true" />
      </ItemActions>
    </Item>
  )
}

function ReviewStep({
  values,
  errors,
  orderTotal,
  orderComplete,
  onEditStep,
  onValueChange,
}: {
  values: CheckoutValues
  errors: CheckoutErrors
  orderTotal: number
  orderComplete: boolean
  onEditStep: (step: number) => void
  onValueChange: <TField extends keyof CheckoutValues>(
    field: TField,
    value: CheckoutValues[TField]
  ) => void
}) {
  const address = getSelectedAddress(values.addressId)
  const delivery = getSelectedDelivery(values.deliveryId)
  const paymentMethod = getSelectedPaymentMethod(values.paymentMethodId)

  return (
    <section
      className="flex min-w-0 flex-col gap-6"
      aria-labelledby="checkout-5-review-title"
    >
      <SectionHeading
        id="checkout-5-review-title"
        title="Review Order"
        description="Confirm delivery, payment, and total before placing the order."
      />

      {orderComplete ? (
        <Alert variant="success">
          <CircleCheckIcon aria-hidden="true" />
          <AlertTitle>Order Placed</AlertTitle>
          <AlertDescription>
            <p>
              Confirmation was sent to {values.email}. The order total is{" "}
              {formatCurrency(orderTotal)}.
            </p>
          </AlertDescription>
        </Alert>
      ) : null}

      <ItemGroup role="group" aria-label="Review details" className="gap-2">
        <ReviewRow
          label="Customer"
          value={`${values.firstName} ${values.lastName}`}
          detail={values.email}
          onEdit={() => onEditStep(1)}
        />
        <ReviewRow
          label="Delivery"
          value={delivery.label}
          detail={`${address.line1} · ${delivery.eta}`}
          onEdit={() => onEditStep(2)}
        />
        <ReviewRow
          label="Payment"
          value={paymentMethod.label}
          detail={
            values.paymentMethodId === "card"
              ? `Card ending ${values.cardNumber.replace(/\D/g, "").slice(-4)}`
              : paymentMethod.description
          }
          onEdit={() => onEditStep(3)}
        />
      </ItemGroup>

      <Field
        orientation="horizontal"
        data-invalid={Boolean(errors.acceptTerms)}
        className="items-start gap-3"
      >
        <Checkbox
          id="checkout-5-terms"
          checked={values.acceptTerms}
          aria-invalid={Boolean(errors.acceptTerms)}
          onCheckedChange={(checked) =>
            onValueChange("acceptTerms", checked === true)
          }
        />
        <FieldContent className="gap-1">
          <FieldLabel htmlFor="checkout-5-terms">Confirm This Order</FieldLabel>
          <FieldDescription>
            I reviewed the delivery address, payment method, return policy, and
            final total.
          </FieldDescription>
          <ErrorLine>{errors.acceptTerms}</ErrorLine>
        </FieldContent>
      </Field>
    </section>
  )
}

function ProductSummaryItem({
  item,
  priority,
  onRemove,
}: {
  item: CheckoutItem
  priority?: boolean
  onRemove: (item: CheckoutItem) => void
}) {
  return (
    <Item role="listitem" className="items-start gap-3 px-0 py-0">
      <ItemMedia variant="image">
        <Item className="bg-muted relative size-16 w-auto flex-nowrap overflow-hidden border p-0">
          <a
            href="#"
            aria-label={`View ${item.name}`}
            className="focus-visible:ring-ring absolute inset-0 outline-none focus-visible:ring-2 focus-visible:ring-inset"
          >
            <img
              src={item.image.src}
              alt={item.image.alt}
              className="absolute inset-0 h-full w-full object-cover"
              loading={priority ? "eager" : "lazy"}
              fetchPriority={priority ? "high" : "auto"}
            />
          </a>
        </Item>
      </ItemMedia>
      <ItemContent className="min-w-0 gap-0.5">
        <ItemTitle className="max-w-full truncate">
          <a
            href="#"
            className="text-foreground hover:text-primary block min-w-0 truncate underline-offset-4 transition-colors hover:underline"
          >
            {item.name}
          </a>
        </ItemTitle>
        <ItemDescription
          className="flex min-w-0 items-center gap-1.5 overflow-hidden"
          aria-label={`${item.color}, ${item.size}, quantity ${item.quantity}`}
        >
          <span className="shrink-0">{item.color}</span>
          <DotSeparator />
          <span className="shrink-0">{item.size}</span>
          <DotSeparator />
          <span className="shrink-0">Qty {item.quantity}</span>
        </ItemDescription>
      </ItemContent>
      <ItemActions className="shrink-0 flex-col items-end gap-1">
        <span className="flex items-baseline justify-end gap-1.5 tabular-nums">
          {item.compareAtPrice ? (
            <span className="text-muted-foreground text-xs line-through">
              {formatCurrency(item.compareAtPrice * item.quantity)}
            </span>
          ) : null}
          <span className="text-sm font-medium">
            {formatCurrency(item.price * item.quantity)}
          </span>
        </span>
        <Button
          type="button"
          variant="ghost"
          size="icon-sm"
          aria-label={`Remove ${item.name}`}
          onClick={() => onRemove(item)}
        >
          <Trash2Icon className="size-4" aria-hidden="true" />
        </Button>
      </ItemActions>
    </Item>
  )
}

function SummaryLine({
  label,
  value,
  description,
  tone,
  strong = false,
  emphasis = false,
}: {
  label: string
  value: string
  description?: string
  tone?: "success"
  strong?: boolean
  emphasis?: boolean
}) {
  return (
    <Item role="listitem" size="xs" className="min-h-7 gap-3 px-0 py-1">
      <ItemContent className="min-w-0 gap-0">
        <ItemTitle
          className={cn(
            "text-sm leading-5 font-normal",
            strong && "font-semibold",
            emphasis && "text-foreground font-semibold",
            tone === "success" && "text-success"
          )}
        >
          {label}
        </ItemTitle>
        {description ? (
          <ItemDescription className="mt-0.5">{description}</ItemDescription>
        ) : null}
      </ItemContent>
      <ItemActions className="shrink-0">
        <span
          className={cn(
            "text-sm leading-5 font-medium tabular-nums",
            strong && "font-semibold",
            emphasis && "text-xl font-semibold",
            tone === "success" && "text-success"
          )}
        >
          {value}
        </span>
      </ItemActions>
    </Item>
  )
}

function TotalSummaryPanel({
  total,
  currentStep,
  totalSteps,
  orderComplete,
}: {
  total: number
  currentStep: number
  totalSteps: number
  orderComplete: boolean
}) {
  const isReviewStep = currentStep === totalSteps
  const status = orderComplete
    ? { label: "Order placed", variant: "success-light" as const }
    : isReviewStep
      ? { label: "Ready to place", variant: "success-light" as const }
      : {
          label: `Step ${currentStep} of ${totalSteps}`,
          variant: "secondary" as const,
        }
  const note = orderComplete
    ? "Charge confirmed"
    : isReviewStep
      ? "Charged after review"
      : "Total updates each step"

  return (
    <div className="flex min-w-0 flex-col gap-3">
      <div className="flex min-w-0 items-start justify-between gap-4">
        <div className="min-w-0">
          <div className="text-base font-semibold">Total</div>
          <div className="text-muted-foreground mt-0.5 text-sm leading-5">
            Delivery, promo, and tax included.
          </div>
        </div>
        <span className="shrink-0 text-2xl leading-none font-semibold tabular-nums">
          {formatCurrency(total)}
        </span>
      </div>
      <div className="flex min-w-0 items-center justify-between gap-3 border-t border-dashed pt-3">
        <span className="text-muted-foreground truncate text-xs">{note}</span>
        <Badge variant={status.variant}>{status.label}</Badge>
      </div>
    </div>
  )
}

function OrderSummary({
  items,
  values,
  promoStatus,
  currentStep,
  totalSteps,
  orderComplete,
  onValueChange,
  onApplyPromo,
  onRemoveItem,
}: {
  items: CheckoutItem[]
  values: CheckoutValues
  promoStatus: PromoStatus
  currentStep: number
  totalSteps: number
  orderComplete: boolean
  onValueChange: <TField extends keyof CheckoutValues>(
    field: TField,
    value: CheckoutValues[TField]
  ) => void
  onApplyPromo: () => void
  onRemoveItem: (item: CheckoutItem) => void
}) {
  const summary = getOrderSummary(values, promoStatus, items)
  const address = getSelectedAddress(values.addressId)

  return (
    <aside
      className="min-w-0 border-t pt-6 lg:sticky lg:top-6 lg:border-t-0 lg:pt-0"
      aria-label="Order summary"
    >
      <Frame spacing="sm">
        <FrameHeader>
          <FrameTitle className="text-base">Order Summary</FrameTitle>
          <FrameDescription>
            {items.length} {items.length === 1 ? "item" : "items"} shipping to{" "}
            {address.label}
          </FrameDescription>
        </FrameHeader>

        <FramePanel className="flex flex-col gap-5">
          <ItemGroup className="gap-4">
            {items.length > 0 ? (
              items.map((item, index) => (
                <ProductSummaryItem
                  key={item.id}
                  item={item}
                  priority={index === 0}
                  onRemove={onRemoveItem}
                />
              ))
            ) : (
              <Item variant="muted" size="sm" role="listitem">
                <ItemContent className="gap-0.5">
                  <ItemTitle>Your Bag Is Empty</ItemTitle>
                  <ItemDescription>
                    Add products before placing an order.
                  </ItemDescription>
                </ItemContent>
              </Item>
            )}
          </ItemGroup>

          <Separator />

          <Field data-invalid={promoStatus === "invalid"} className="gap-2">
            <FieldLabel htmlFor="checkout-5-promo">Promo Code</FieldLabel>
            <div className="flex gap-2">
              <Input
                id="checkout-5-promo"
                value={values.promoCode}
                className="min-w-0"
                aria-invalid={promoStatus === "invalid"}
                onChange={(event) =>
                  onValueChange("promoCode", event.target.value)
                }
              />
              <Button type="button" variant="outline" onClick={onApplyPromo}>
                Apply
              </Button>
            </div>
            {promoStatus === "applied" ? (
              <FieldDescription>
                <strong>{PROMO_CODE}</strong> applied for{" "}
                {formatCurrency(PROMO_DISCOUNT)} off.
              </FieldDescription>
            ) : null}
            <ErrorLine>
              {promoStatus === "invalid" ? (
                <>
                  Use <strong>{PROMO_CODE}</strong> to apply the demo discount.
                </>
              ) : undefined}
            </ErrorLine>
          </Field>

          <Separator />

          <ItemGroup className="gap-0">
            <SummaryLine
              label="Subtotal"
              value={formatCurrency(summary.subtotal)}
            />
            <SummaryLine
              label="Delivery"
              value={
                summary.delivery === 0
                  ? "Free"
                  : formatCurrency(summary.delivery)
              }
            />
            <SummaryLine
              label="Estimated Tax"
              value={formatCurrency(summary.tax)}
            />
            {summary.discount > 0 ? (
              <SummaryLine
                label="Discount"
                value={`-${formatCurrency(summary.discount)}`}
                tone="success"
                strong
              />
            ) : null}
          </ItemGroup>
        </FramePanel>

        <FrameFooter>
          <TotalSummaryPanel
            total={summary.total}
            currentStep={currentStep}
            totalSteps={totalSteps}
            orderComplete={orderComplete}
          />
        </FrameFooter>
      </Frame>
    </aside>
  )
}

export function Checkout() {
  const [currentStep, setCurrentStep] = useState(1)
  const [values, setValues] = useState<CheckoutValues>(copyCheckoutValues)
  const [cartItems, setCartItems] = useState<CheckoutItem[]>(CHECKOUT_ITEMS)
  const [errors, setErrors] = useState<CheckoutErrors>({})
  const [promoStatus, setPromoStatus] = useState<PromoStatus>("applied")
  const [isSubmitting, setIsSubmitting] = useState(false)
  const [orderComplete, setOrderComplete] = useState(false)
  const shouldReduceMotion = useReducedMotion()

  const currentStepConfig =
    CHECKOUT_STEPS.find((step) => step.step === currentStep) ??
    CHECKOUT_STEPS[0]
  const summary = getOrderSummary(values, promoStatus, cartItems)
  const isLastStep = currentStep === TOTAL_STEPS

  function updateValue<TField extends keyof CheckoutValues>(
    field: TField,
    value: CheckoutValues[TField]
  ) {
    setValues((current) => ({ ...current, [field]: value }))
    setErrors((current) => {
      if (!current[field]) return current

      const nextErrors = { ...current }
      delete nextErrors[field]
      return nextErrors
    })

    if (field === "promoCode") {
      setPromoStatus("idle")
    }
    if (field !== "acceptTerms") {
      setOrderComplete(false)
    }
  }

  function handleApplyPromo() {
    setPromoStatus(
      values.promoCode.trim().toUpperCase() === PROMO_CODE
        ? "applied"
        : "invalid"
    )
  }

  function handlePrevious() {
    setCurrentStep((step) => Math.max(1, step - 1))
  }

  function handleRemoveItem(item: CheckoutItem) {
    setCartItems((current) =>
      current.filter((currentItem) => currentItem.id !== item.id)
    )
    setOrderComplete(false)
    toast.message("Removed from bag", {
      description: item.name,
    })
  }

  function handleSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()

    const stepErrors = getStepErrors(currentStepConfig.id, values)

    if (Object.keys(stepErrors).length > 0) {
      setErrors((current) => ({ ...current, ...stepErrors }))
      return
    }

    if (!isLastStep) {
      setCurrentStep((step) => Math.min(TOTAL_STEPS, step + 1))
      return
    }

    const invalidStep = getFirstInvalidStep(values)

    if (invalidStep) {
      const invalidStepId = CHECKOUT_STEPS[invalidStep - 1]?.id
      setErrors(invalidStepId ? getStepErrors(invalidStepId, values) : {})
      setCurrentStep(invalidStep)
      return
    }

    setIsSubmitting(true)
    window.setTimeout(() => {
      setIsSubmitting(false)
      setOrderComplete(true)
      toast.success("Order placed", {
        description: `${formatCurrency(summary.total)} charged to ${getSelectedPaymentMethod(values.paymentMethodId).label}.`,
      })
    }, 650)
  }

  return (
    <div className="mx-auto flex w-full max-w-6xl flex-col gap-0 px-4 py-6 sm:px-6 lg:px-8">
      <CheckoutHeader currentStep={currentStep} />

      <form
        id={FORM_ID}
        onSubmit={handleSubmit}
        className="grid min-w-0 gap-8 lg:grid-cols-[minmax(0,1fr)_23rem] lg:items-start"
        aria-label="Ecommerce checkout"
      >
        <div className="min-w-0">
          <FieldSet className="gap-0">
            <FieldLegend className="sr-only">Checkout Steps</FieldLegend>
            <FieldDescription className="sr-only">
              Enter customer details, choose delivery, select payment, and
              review the order.
            </FieldDescription>

            <AnimatePresence mode="wait" initial={false}>
              <motion.div
                key={currentStepConfig.id}
                className="flex min-w-0 flex-col gap-7"
                initial={
                  shouldReduceMotion
                    ? { opacity: 1 }
                    : { opacity: 0, y: 8, scale: 0.998 }
                }
                animate={{ opacity: 1, y: 0, scale: 1 }}
                exit={
                  shouldReduceMotion
                    ? { opacity: 0 }
                    : { opacity: 0, y: -8, scale: 0.998 }
                }
                transition={
                  shouldReduceMotion
                    ? { duration: 0 }
                    : { duration: 0.18, ease: "easeOut" }
                }
              >
                {currentStepConfig.id === "contact" ? (
                  <ContactStep
                    values={values}
                    errors={errors}
                    onValueChange={updateValue}
                  />
                ) : null}
                {currentStepConfig.id === "delivery" ? (
                  <DeliveryStep
                    values={values}
                    errors={errors}
                    onValueChange={updateValue}
                  />
                ) : null}
                {currentStepConfig.id === "payment" ? (
                  <PaymentStep
                    values={values}
                    errors={errors}
                    onValueChange={updateValue}
                  />
                ) : null}
                {currentStepConfig.id === "review" ? (
                  <ReviewStep
                    values={values}
                    errors={errors}
                    orderTotal={summary.total}
                    orderComplete={orderComplete}
                    onEditStep={setCurrentStep}
                    onValueChange={updateValue}
                  />
                ) : null}
              </motion.div>
            </AnimatePresence>
          </FieldSet>

          <div
            className={cn(
              "mt-7 flex items-center gap-3 border-t pt-5",
              currentStep > 1 ? "justify-between" : "justify-end"
            )}
          >
            {currentStep > 1 ? (
              <Button
                type="button"
                variant="ghost"
                size="lg"
                disabled={isSubmitting}
                onClick={handlePrevious}
              >
                <ArrowLeftIcon data-icon="inline-start" aria-hidden="true" />
                Back
              </Button>
            ) : null}

            <Button
              type="submit"
              size="lg"
              disabled={isSubmitting || orderComplete}
            >
              {isSubmitting ? (
                <Spinner data-icon="inline-start" aria-hidden="true" />
              ) : null}
              {orderComplete
                ? "Order Placed"
                : isLastStep
                  ? "Place Order"
                  : "Continue"}
              {!isSubmitting && !orderComplete ? (
                <ArrowRightIcon data-icon="inline-end" aria-hidden="true" />
              ) : null}
            </Button>
          </div>
        </div>

        <OrderSummary
          items={cartItems}
          values={values}
          promoStatus={promoStatus}
          currentStep={currentStep}
          totalSteps={TOTAL_STEPS}
          orderComplete={orderComplete}
          onValueChange={updateValue}
          onApplyPromo={handleApplyPromo}
          onRemoveItem={handleRemoveItem}
        />
      </form>
    </div>
  )
}