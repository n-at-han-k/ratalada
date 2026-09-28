import { Badge } from "@/components/reui/badge"

import { Button } from "@/components/ui/button"
import { Card, CardContent, CardFooter } from "@/components/ui/card"
import {
  Field,
  FieldDescription,
  FieldGroup,
  FieldLabel,
} from "@/components/ui/field"
import { Input } from "@/components/ui/input"
import {
  InputGroup,
  InputGroupAddon,
  InputGroupButton,
  InputGroupInput,
  InputGroupText,
} from "@/components/ui/input-group"
import { Separator } from "@/components/ui/separator"
import { TooltipProvider } from "@/components/ui/tooltip"

import {
  LANGUAGE_OPTIONS,
  PROFILE_IDENTITY,
  ROLE_OPTIONS,
  START_WEEK_OPTIONS,
  TIME_FORMAT_OPTIONS,
} from "./data"
import { FieldLabelWithHint } from "./field-label-with-hint"
import { ImageUploadField } from "./image-upload-field"
import {
  CompactSelectField,
  ProfilePhoneField,
  TimezoneComboboxField,
} from "./profile-form-fields"
import { ProfileSyncAlert } from "./profile-sync-alert"

const DEFAULT_ROLE_OPTION =
  ROLE_OPTIONS.find((option) => option.value === PROFILE_IDENTITY.role) ??
  ROLE_OPTIONS[0]!

const DEFAULT_LANGUAGE_OPTION =
  LANGUAGE_OPTIONS.find(
    (option) => option.value === PROFILE_IDENTITY.language
  ) ?? LANGUAGE_OPTIONS[0]!

const DEFAULT_START_WEEK_OPTION =
  START_WEEK_OPTIONS.find(
    (option) => option.value === PROFILE_IDENTITY.startWeek
  ) ?? START_WEEK_OPTIONS[0]!

const DEFAULT_TIME_FORMAT_OPTION =
  TIME_FORMAT_OPTIONS.find(
    (option) => option.value === PROFILE_IDENTITY.timeFormat
  ) ?? TIME_FORMAT_OPTIONS[0]!

export function Profile() {
  return (
    <TooltipProvider delay={200}>
      {/* Heading */}
      <div className="w-full max-w-4xl space-y-6">
        <header className="space-y-1 px-1">
          <h1 className="text-2xl font-semibold tracking-tight">Profile</h1>
          <p className="text-muted-foreground max-w-2xl text-sm leading-relaxed">
            Manage the identity and regional details shared across your
            workspace memberships.
          </p>
        </header>

        <ProfileSyncAlert />

        <Card className="overflow-hidden p-0">
          <CardContent className="px-6 py-7 sm:px-8">
            <div>
              <div className="space-y-4">
                <ImageUploadField
                  ariaLabel="Upload profile image"
                  inputId="profile-3-avatar"
                  defaultImage={PROFILE_IDENTITY.avatar}
                  alt={`${PROFILE_IDENTITY.firstName} ${PROFILE_IDENTITY.lastName}`.trim()}
                />
              </div>

              <Separator className="my-6" />

              <div id="profile-3-basic-details" className="space-y-5">
                <SectionHeading
                  title="Basic Details"
                  description="Keep your contact and identity fields current."
                />

                <FieldGroup className="grid gap-x-6 gap-y-6 md:grid-cols-2">
                  <Field className="gap-2.5">
                    <FieldLabel htmlFor="profile-3-first-name">
                      First Name
                    </FieldLabel>
                    <Input
                      id="profile-3-first-name"
                      defaultValue={PROFILE_IDENTITY.firstName}
                    />
                  </Field>

                  <Field className="gap-2.5">
                    <FieldLabel htmlFor="profile-3-last-name">
                      Last Name
                    </FieldLabel>
                    <Input
                      id="profile-3-last-name"
                      defaultValue={PROFILE_IDENTITY.lastName}
                      placeholder="Optional"
                    />
                  </Field>

                  <Field className="gap-2.5">
                    <FieldLabelWithHint
                      htmlFor="profile-3-email"
                      label="Primary Email Address"
                      hint="This stays tied to sign-in and recovery. Use the edit action if your account allows email changes."
                      addon={
                        <Badge variant="success-light" size="sm">
                          Verified
                        </Badge>
                      }
                    />
                    <InputGroup className="w-full">
                      <InputGroupInput
                        id="profile-3-email"
                        type="email"
                        defaultValue={PROFILE_IDENTITY.email}
                      />
                      <InputGroupAddon align="inline-end">
                        <InputGroupButton type="button" variant="outline">
                          Edit
                        </InputGroupButton>
                      </InputGroupAddon>
                    </InputGroup>
                    <FieldDescription>
                      Used for sign-in, recovery, and workspace notices.
                    </FieldDescription>
                  </Field>

                  <Field className="gap-2.5">
                    <FieldLabelWithHint
                      htmlFor="profile-3-preferred-name"
                      label="Preferred Name"
                      hint="Shown in compact comments, activity rows, and mention previews."
                    />
                    <Input
                      id="profile-3-preferred-name"
                      defaultValue={PROFILE_IDENTITY.preferredName}
                    />
                  </Field>

                  <Field className="gap-2.5">
                    <FieldLabelWithHint
                      htmlFor="profile-3-username"
                      label="Username"
                      hint="Used in mentions, shared profile links, and compact owner labels."
                    />
                    <InputGroup className="w-full">
                      <InputGroupAddon align="inline-start">
                        <InputGroupText>@</InputGroupText>
                      </InputGroupAddon>
                      <InputGroupInput
                        id="profile-3-username"
                        defaultValue={PROFILE_IDENTITY.username}
                      />
                    </InputGroup>
                  </Field>

                  <Field className="gap-2.5">
                    <FieldLabel htmlFor="profile-3-role">Role</FieldLabel>
                    <CompactSelectField
                      id="profile-3-role"
                      options={ROLE_OPTIONS}
                      defaultValue={DEFAULT_ROLE_OPTION}
                    />
                  </Field>

                  <Field className="gap-2.5">
                    <FieldLabel htmlFor="profile-3-phone">
                      Phone Number
                    </FieldLabel>
                    <ProfilePhoneField
                      id="profile-3-phone"
                      defaultValue={PROFILE_IDENTITY.phone}
                    />
                    <FieldDescription>
                      Used only for urgent verification and recovery.
                    </FieldDescription>
                  </Field>

                  <Field className="gap-2.5">
                    <FieldLabel htmlFor="profile-3-website">Website</FieldLabel>
                    <InputGroup className="w-full">
                      <InputGroupAddon align="inline-start">
                        <InputGroupText>https://</InputGroupText>
                      </InputGroupAddon>
                      <InputGroupInput
                        id="profile-3-website"
                        defaultValue={PROFILE_IDENTITY.website}
                      />
                    </InputGroup>
                  </Field>
                </FieldGroup>
              </div>

              <Separator className="my-6" />

              <div className="space-y-5">
                <SectionHeading
                  title="Regional Preferences"
                  description="Choose how time and scheduling fields appear."
                />

                <FieldGroup className="grid gap-x-6 gap-y-6 md:grid-cols-2">
                  <Field className="gap-2.5">
                    <FieldLabelWithHint
                      htmlFor="profile-3-timezone"
                      label="Preferred Timezone"
                      hint="Used for due times, reminder delivery, and schedule previews."
                    />
                    <TimezoneComboboxField
                      id="profile-3-timezone"
                      defaultValue={PROFILE_IDENTITY.timezone}
                    />
                  </Field>

                  <Field className="gap-2.5">
                    <FieldLabelWithHint
                      htmlFor="profile-3-start-week"
                      label="Start Week On"
                      hint="Changes how calendars and weekly summaries open by default."
                    />
                    <CompactSelectField
                      id="profile-3-start-week"
                      options={START_WEEK_OPTIONS}
                      defaultValue={DEFAULT_START_WEEK_OPTION}
                    />
                  </Field>

                  <Field className="gap-2.5">
                    <FieldLabel htmlFor="profile-3-language">
                      Language
                    </FieldLabel>
                    <CompactSelectField
                      id="profile-3-language"
                      options={LANGUAGE_OPTIONS}
                      defaultValue={DEFAULT_LANGUAGE_OPTION}
                    />
                  </Field>

                  <Field className="gap-2.5">
                    <FieldLabel htmlFor="profile-3-time-format">
                      Time Format
                    </FieldLabel>
                    <CompactSelectField
                      id="profile-3-time-format"
                      options={TIME_FORMAT_OPTIONS}
                      defaultValue={DEFAULT_TIME_FORMAT_OPTION}
                    />
                  </Field>
                </FieldGroup>
              </div>
            </div>
          </CardContent>

          <CardFooter className="border-t px-6 py-4 sm:px-8">
            <div className="flex w-full flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
              <p className="text-muted-foreground text-sm">
                Save once to update your shared profile across every workspace.
              </p>

              <div className="flex items-center gap-2">
                <Button type="button" variant="outline">
                  Reset
                </Button>
                <Button type="button">Save Changes</Button>
              </div>
            </div>
          </CardFooter>
        </Card>
      </div>
    </TooltipProvider>
  )
}

function SectionHeading({
  title,
  description,
}: {
  title: string
  description: string
}) {
  return (
    <div className="space-y-1">
      <h2 className="text-base font-semibold tracking-tight">{title}</h2>
      <p className="text-muted-foreground text-sm leading-relaxed">
        {description}
      </p>
    </div>
  )
}