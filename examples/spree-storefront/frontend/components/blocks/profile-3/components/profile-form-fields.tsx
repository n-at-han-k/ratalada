import { useState } from "react"
import { PhoneInput } from "@/components/reui/phone-input"

import {
  Combobox,
  ComboboxCollection,
  ComboboxContent,
  ComboboxEmpty,
  ComboboxGroup,
  ComboboxInput,
  ComboboxItem,
  ComboboxLabel,
  ComboboxList,
} from "@/components/ui/combobox"
import { Field } from "@/components/ui/field"
import {
  Select,
  SelectContent,
  SelectGroup,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select"

import { TIMEZONE_GROUPS, type SelectOption } from "./data"

export function CompactSelectField({
  id,
  options,
  defaultValue,
}: {
  id: string
  options: SelectOption[]
  defaultValue: SelectOption
}) {
  return (
    <Field className="w-full">
      <Select defaultValue={defaultValue} items={options}>
        <SelectTrigger id={id} className="w-full">
          <SelectValue>
            {(item: SelectOption | null) => item?.label ?? null}
          </SelectValue>
        </SelectTrigger>

        <SelectContent className="w-(--anchor-width)">
          <SelectGroup>
            {options.map((option) => (
              <SelectItem key={option.value} value={option}>
                {option.label}
              </SelectItem>
            ))}
          </SelectGroup>
        </SelectContent>
      </Select>
    </Field>
  )
}

export function TimezoneComboboxField({
  id,
  defaultValue,
  placeholder = "Select a timezone",
}: {
  id: string
  defaultValue: string
  placeholder?: string
}) {
  return (
    <Field className="w-full">
      <Combobox items={TIMEZONE_GROUPS} defaultValue={defaultValue}>
        <ComboboxInput id={id} placeholder={placeholder} className="w-full" />
        <ComboboxContent className="w-(--anchor-width) min-w-(--anchor-width)">
          <ComboboxEmpty>No timezones found.</ComboboxEmpty>
          <ComboboxList>
            {(group) => (
              <ComboboxGroup key={group.value} items={group.items}>
                <ComboboxLabel>{group.value}</ComboboxLabel>
                <ComboboxCollection>
                  {(item) => (
                    <ComboboxItem key={item} value={item}>
                      {item}
                    </ComboboxItem>
                  )}
                </ComboboxCollection>
              </ComboboxGroup>
            )}
          </ComboboxList>
        </ComboboxContent>
      </Combobox>
    </Field>
  )
}

export function ProfilePhoneField({
  id,
  defaultValue,
  defaultCountry = "US",
}: {
  id: string
  defaultValue: string
  defaultCountry?: "US" | "DE" | "GB" | "AE" | "UZ"
}) {
  const [value, setValue] = useState(defaultValue)

  return (
    <PhoneInput
      id={id}
      className="w-full"
      defaultCountry={defaultCountry}
      value={value}
      onChange={(nextValue) => setValue(nextValue || "")}
      placeholder="Enter phone number"
    />
  )
}