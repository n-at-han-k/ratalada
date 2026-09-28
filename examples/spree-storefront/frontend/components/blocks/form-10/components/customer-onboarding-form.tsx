"use client"

import { Fragment, useState, type FormEvent, type ReactNode } from "react"
import { Badge } from "@/components/reui/badge"
import { cn } from "cn"
import { toast } from "sonner"

import { Button } from "@/components/ui/button"
import {
  Card,
  CardAction,
  CardContent,
  CardDescription,
  CardFooter,
  CardHeader,
  CardTitle,
} from "@/components/ui/card"
import {
  Combobox,
  ComboboxChip,
  ComboboxChips,
  ComboboxChipsInput,
  ComboboxContent,
  ComboboxEmpty,
  ComboboxItem,
  ComboboxList,
  ComboboxValue,
  useComboboxAnchor,
} from "@/components/ui/combobox"
import {
  Field,
  FieldContent,
  FieldDescription,
  FieldGroup,
  FieldLabel,
  FieldLegend,
  FieldSet,
  FieldTitle,
} from "@/components/ui/field"
import {
  InputGroup,
  InputGroupAddon,
  InputGroupInput,
  InputGroupText,
} from "@/components/ui/input-group"
import {
  RadioGroup,
  RadioGroupItem,
} from "@/components/ui/radio-group"
import {
  Select,
  SelectContent,
  SelectGroup,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select"
import { Separator } from "@/components/ui/separator"
import { Spinner } from "@/components/ui/spinner"
import { Switch } from "@/components/ui/switch"
import { Textarea } from "@/components/ui/textarea"
import {
  DEFAULT_STAKEHOLDERS,
  GOAL_OPTIONS,
  SOURCE_OPTIONS,
  STAKEHOLDERS,
  TEAM_SIZE_OPTIONS,
  TEMPLATE_OPTIONS,
  TIMELINE_OPTIONS,
  type GoalValue,
  type SelectOption,
  type SourceValue,
  type Stakeholder,
} from "./data"
import { Building2Icon, RocketIcon } from "lucide-react"

const FORM_ID = "form-10-customer-onboarding"

function getOptionLabel<TValue extends string>(
  options: SelectOption<TValue>[],
  value: TValue
) {
  return options.find((option) => option.value === value)?.label ?? value
}

function FormRow({
  title,
  description,
  htmlFor,
  align = "center",
  children,
}: {
  title: string
  description: string
  htmlFor?: string
  align?: "center" | "start"
  children: ReactNode
}) {
  return (
    <Field
      className={cn(
        "grid gap-3 px-5 py-4 sm:px-6 md:grid-cols-[minmax(0,17rem)_minmax(0,1fr)]",
        align === "start" ? "md:items-start" : "md:items-center"
      )}
    >
      <FieldContent className="gap-0.5 md:pt-0.5">
        {htmlFor ? (
          <FieldLabel htmlFor={htmlFor}>{title}</FieldLabel>
        ) : (
          <FieldTitle>{title}</FieldTitle>
        )}
        <FieldDescription>{description}</FieldDescription>
      </FieldContent>
      <div className="min-w-0">{children}</div>
    </Field>
  )
}

function InsetSeparator() {
  return (
    <div className="px-5 sm:px-6">
      <Separator className="border-t border-dashed bg-transparent" />
    </div>
  )
}

function OptionSelect<TValue extends string>({
  id,
  value,
  options,
  onValueChange,
}: {
  id: string
  value: TValue
  options: SelectOption<TValue>[]
  onValueChange: (value: TValue) => void
}) {
  return (
    <Select
      value={value}
      onValueChange={(nextValue) => nextValue && onValueChange(nextValue)}
    >
      <SelectTrigger id={id} className="w-full [&_small]:hidden">
        <SelectValue>
          {(item: TValue) => getOptionLabel(options, item)}
        </SelectValue>
      </SelectTrigger>
      <SelectContent alignItemWithTrigger={false}>
        <SelectGroup>
          {options.map((option) => (
            <SelectItem key={option.value} value={option.value}>
              <span className="flex min-w-0 flex-col items-start gap-px">
                <span className="font-medium">{option.label}</span>
                <small className="text-muted-foreground line-clamp-1 text-xs">
                  {option.description}
                </small>
              </span>
            </SelectItem>
          ))}
        </SelectGroup>
      </SelectContent>
    </Select>
  )
}

function StakeholderCombobox({
  stakeholders,
  onStakeholdersChange,
}: {
  stakeholders: Stakeholder[]
  onStakeholdersChange: (stakeholders: Stakeholder[]) => void
}) {
  const anchor = useComboboxAnchor()

  return (
    <Combobox
      multiple
      items={STAKEHOLDERS}
      value={stakeholders}
      itemToStringValue={(stakeholder: Stakeholder) => stakeholder.email}
      onValueChange={onStakeholdersChange}
    >
      <ComboboxChips
        ref={anchor}
        className="min-h-10 has-data-[slot=combobox-chip]:pl-1"
      >
        <ComboboxValue>
          {(selectedStakeholders: Stakeholder[]) => (
            <Fragment>
              {selectedStakeholders.map((stakeholder) => (
                <ComboboxChip key={stakeholder.id} className="gap-1.5">
                  {stakeholder.name}
                </ComboboxChip>
              ))}
              <ComboboxChipsInput
                id="form-10-stakeholders"
                placeholder="Add owner"
              />
            </Fragment>
          )}
        </ComboboxValue>
      </ComboboxChips>
      <ComboboxContent
        anchor={anchor}
        className="max-w-(--anchor-width) min-w-(--anchor-width)"
      >
        <ComboboxEmpty>No matching stakeholders.</ComboboxEmpty>
        <ComboboxList>
          {(stakeholder: Stakeholder) => (
            <ComboboxItem key={stakeholder.id} value={stakeholder}>
              <span className="flex min-w-0 flex-col items-start gap-0.5">
                <span className="truncate text-sm font-medium">
                  {stakeholder.name}
                </span>
                <span className="text-muted-foreground inline-flex min-w-0 items-center gap-1.5 text-xs">
                  <span className="truncate">{stakeholder.role}</span>
                  <span
                    className="inline-flex size-1 shrink-0 rounded-full bg-gray-400"
                    aria-hidden="true"
                  />
                  <span className="truncate">{stakeholder.email}</span>
                </span>
              </span>
            </ComboboxItem>
          )}
        </ComboboxList>
      </ComboboxContent>
    </Combobox>
  )
}

export function CustomerOnboardingForm() {
  const [goal, setGoal] = useState<GoalValue>("pipeline")
  const [teamSize, setTeamSize] = useState("growth")
  const [timeline, setTimeline] = useState("two-weeks")
  const [template, setTemplate] = useState("revops")
  const [source, setSource] = useState<SourceValue>("crm")
  const [stakeholders, setStakeholders] =
    useState<Stakeholder[]>(DEFAULT_STAKEHOLDERS)
  const [includeSampleData, setIncludeSampleData] = useState(true)
  const [isSubmitting, setIsSubmitting] = useState(false)

  function handleSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()

    if (isSubmitting) {
      return
    }

    setIsSubmitting(true)

    window.setTimeout(() => {
      setIsSubmitting(false)
      toast.success("Onboarding plan created", {
        description: `${getOptionLabel(
          GOAL_OPTIONS,
          goal
        )} setup is ready with ${getOptionLabel(
          SOURCE_OPTIONS,
          source
        )} as the first data source.`,
      })
    }, 1200)
  }

  return (
    <Card className="w-full max-w-3xl gap-0 p-0">
      {/* Header */}
      <CardHeader className="gap-1 px-5 py-4 sm:px-6">
        <CardTitle>Customer Onboarding</CardTitle>
        <CardDescription>
          Create a focused setup plan for a new workspace.
        </CardDescription>
        <CardAction className="self-center">
          <Badge variant="secondary">Draft</Badge>
        </CardAction>
      </CardHeader>

      <Separator />

      <form id={FORM_ID} onSubmit={handleSubmit}>
        {/* Content */}
        <CardContent className="p-0">
          <FieldSet className="gap-0">
            <FieldLegend className="sr-only">
              Customer onboarding intake
            </FieldLegend>
            <FieldDescription className="sr-only">
              Capture account details, launch intent, source data, owners, and
              notes for a new workspace.
            </FieldDescription>

            <FieldGroup className="gap-0">
              <FormRow
                title="Company Name"
                description="Customer account display name."
                htmlFor="form-10-company"
              >
                <InputGroup>
                  <InputGroupAddon>
                    <Building2Icon aria-hidden="true" />
                  </InputGroupAddon>
                  <InputGroupInput
                    id="form-10-company"
                    defaultValue="Northstar Labs"
                    autoComplete="organization"
                  />
                </InputGroup>
              </FormRow>

              <InsetSeparator />

              <FormRow
                title="Workspace URL"
                description="Short route for the new workspace."
                htmlFor="form-10-slug"
              >
                <InputGroup>
                  <InputGroupAddon className="pr-0 pl-3">
                    <InputGroupText className="text-muted-foreground">
                      app.reui.dev/
                    </InputGroupText>
                  </InputGroupAddon>
                  <InputGroupInput
                    id="form-10-slug"
                    defaultValue="northstar"
                    autoComplete="off"
                  />
                </InputGroup>
              </FormRow>

              <InsetSeparator />

              <FormRow
                title="Intent"
                description="Pick the first success path."
                align="start"
              >
                <RadioGroup
                  name="form-10-goal"
                  value={goal}
                  onValueChange={(nextValue) =>
                    nextValue && setGoal(nextValue as GoalValue)
                  }
                  className="w-fit"
                >
                  {GOAL_OPTIONS.map((option) => (
                    <Field key={option.value} orientation="horizontal">
                      <RadioGroupItem
                        id={`form-10-goal-${option.value}`}
                        value={option.value}
                      />
                      <FieldContent>
                        <FieldLabel htmlFor={`form-10-goal-${option.value}`}>
                          {option.label}
                        </FieldLabel>
                        <FieldDescription>
                          {option.description}
                        </FieldDescription>
                      </FieldContent>
                    </Field>
                  ))}
                </RadioGroup>
              </FormRow>

              <InsetSeparator />

              <FormRow
                title="Team Size"
                description="Expected workspace users."
                htmlFor="form-10-team-size"
              >
                <OptionSelect
                  id="form-10-team-size"
                  value={teamSize}
                  options={TEAM_SIZE_OPTIONS}
                  onValueChange={setTeamSize}
                />
              </FormRow>

              <InsetSeparator />

              <FormRow
                title="Launch Window"
                description="Target first usable workspace."
                htmlFor="form-10-timeline"
              >
                <OptionSelect
                  id="form-10-timeline"
                  value={timeline}
                  options={TIMELINE_OPTIONS}
                  onValueChange={setTimeline}
                />
              </FormRow>

              <InsetSeparator />

              <FormRow
                title="Starter Template"
                description="Initial workspace structure."
                htmlFor="form-10-template"
              >
                <OptionSelect
                  id="form-10-template"
                  value={template}
                  options={TEMPLATE_OPTIONS}
                  onValueChange={setTemplate}
                />
              </FormRow>

              <InsetSeparator />

              <FormRow
                title="First Source"
                description="Primary data source to connect."
                htmlFor="form-10-source"
              >
                <OptionSelect
                  id="form-10-source"
                  value={source}
                  options={SOURCE_OPTIONS}
                  onValueChange={setSource}
                />
              </FormRow>

              <InsetSeparator />

              <FormRow
                title="Owners"
                description="People responsible for setup."
                align="start"
              >
                <StakeholderCombobox
                  stakeholders={stakeholders}
                  onStakeholdersChange={setStakeholders}
                />
              </FormRow>

              <InsetSeparator />

              <FormRow
                title="Include Sample Data"
                description="Seed demo records before import."
                htmlFor="form-10-sample-data"
              >
                <Switch
                  id="form-10-sample-data"
                  checked={includeSampleData}
                  onCheckedChange={setIncludeSampleData}
                />
              </FormRow>

              <InsetSeparator />

              <FormRow
                title="Setup Notes"
                description="Context for the implementation team."
                htmlFor="form-10-notes"
                align="start"
              >
                <Textarea
                  id="form-10-notes"
                  defaultValue="Start with CRM accounts and renewal workflow defaults."
                  className="min-h-20"
                />
              </FormRow>
            </FieldGroup>
          </FieldSet>
        </CardContent>

        {/* Footer */}
        <CardFooter className="justify-between gap-3 px-5 py-4 sm:px-6">
          <div className="text-muted-foreground hidden min-w-0 text-sm sm:block">
            <span className="truncate">
              {getOptionLabel(TEAM_SIZE_OPTIONS, teamSize)} team ·{" "}
              {getOptionLabel(TIMELINE_OPTIONS, timeline)} launch ·{" "}
              {stakeholders.length} owners
            </span>
          </div>
          <div className="flex w-full items-center justify-end gap-2 sm:w-auto">
            <Button type="button" variant="outline" disabled={isSubmitting}>
              Save Draft
            </Button>
            <Button type="submit" disabled={isSubmitting}>
              {isSubmitting ? (
                <Spinner data-icon="inline-start" aria-hidden="true" />
              ) : (
                <RocketIcon data-icon="inline-start" aria-hidden="true" />
              )}
              Create Plan
            </Button>
          </div>
        </CardFooter>
      </form>
    </Card>
  )
}