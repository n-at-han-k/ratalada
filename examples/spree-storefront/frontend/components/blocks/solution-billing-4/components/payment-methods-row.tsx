import { type ReactNode } from "react"

import {
  Field,
  FieldContent,
  FieldDescription,
  FieldGroup,
  FieldSeparator,
  FieldTitle,
} from "@/components/ui/field"

interface SettingRowProps {
  title: string
  description?: ReactNode
  children: ReactNode
  titleAddon?: ReactNode
  last?: boolean
}

export function SettingRow({
  title,
  description,
  children,
  titleAddon,
  last,
}: SettingRowProps) {
  return (
    <>
      <Field
        orientation="responsive"
        className="gap-3 px-4 py-3 @md/field-group:gap-5 @md/field-group:has-[>[data-slot=field-content]]:items-center"
      >
        <div className="flex w-full min-w-0 flex-col gap-0.5 @md/field-group:w-3/5 @md/field-group:basis-3/5 @md/field-group:pr-2">
          <div className="flex min-w-0 flex-wrap items-center gap-2">
            <FieldTitle>{title}</FieldTitle>
            {titleAddon}
          </div>

          {description ? (
            <FieldDescription className="max-w-[28rem] text-sm leading-5">
              {description}
            </FieldDescription>
          ) : null}
        </div>

        <FieldContent className="w-full min-w-0 @md/field-group:w-2/5 @md/field-group:basis-2/5">
          <div className="flex w-full justify-start @md/field-group:justify-end">
            {children}
          </div>
        </FieldContent>
      </Field>

      {!last ? <FieldSeparator /> : null}
    </>
  )
}

export function SettingRowGroup({ children }: { children: ReactNode }) {
  return <FieldGroup className="gap-0">{children}</FieldGroup>
}