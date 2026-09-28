import { type ReactNode } from "react"

import { Button } from "@/components/ui/button"
import {
  Field,
  FieldContent,
  FieldDescription,
  FieldGroup,
  FieldSeparator,
  FieldTitle,
} from "@/components/ui/field"
import {
  Tooltip,
  TooltipContent,
  TooltipTrigger,
} from "@/components/ui/tooltip"
import { InfoIcon } from "lucide-react"

interface SettingRowProps {
  title: string
  description?: ReactNode
  hint?: ReactNode
  children: ReactNode
  titleAddon?: ReactNode
  last?: boolean
}

function SettingHintTooltip({
  label,
  children,
}: {
  label: string
  children: ReactNode
}) {
  return (
    <Tooltip>
      <TooltipTrigger
        render={
          <Button
            type="button"
            variant="ghost"
            size="icon-xs"
            className="text-muted-foreground hover:text-foreground"
            aria-label={label}
          />
        }
      >
        <InfoIcon aria-hidden="true" />
      </TooltipTrigger>
      <TooltipContent side="top" className="max-w-60 text-xs leading-relaxed">
        {children}
      </TooltipContent>
    </Tooltip>
  )
}

export function SettingRow({
  title,
  description,
  hint,
  children,
  titleAddon,
  last,
}: SettingRowProps) {
  return (
    <>
      <Field
        orientation="responsive"
        className="gap-4 px-5 py-4 @md/field-group:gap-8 @md/field-group:has-[>[data-slot=field-content]]:items-start"
      >
        <div className="flex w-full min-w-0 flex-col gap-0.5 @md/field-group:w-3/5 @md/field-group:basis-3/5 @md/field-group:pr-2">
          <div className="flex min-w-0 flex-wrap items-center gap-2">
            <FieldTitle>{title}</FieldTitle>
            {titleAddon}
            {hint ? (
              <SettingHintTooltip label={`${title} details`}>
                {hint}
              </SettingHintTooltip>
            ) : null}
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