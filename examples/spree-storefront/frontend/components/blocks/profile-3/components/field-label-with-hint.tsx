import { type ReactNode } from "react"

import { FieldLabel } from "@/components/ui/field"
import {
  Tooltip,
  TooltipContent,
  TooltipTrigger,
} from "@/components/ui/tooltip"
import { InfoIcon } from "lucide-react"

export function FieldLabelWithHint({
  htmlFor,
  label,
  hint,
  addon,
}: {
  htmlFor: string
  label: string
  hint?: string
  addon?: ReactNode
}) {
  return (
    <div className="flex items-center gap-1.5">
      <FieldLabel htmlFor={htmlFor}>{label}</FieldLabel>
      {hint ? (
        <Tooltip>
          <TooltipTrigger
            render={
              <button
                type="button"
                className="text-muted-foreground hover:text-foreground focus-visible:ring-ring focus-visible:ring-offset-background inline-flex rounded-sm p-0.5 transition-colors focus-visible:ring-2 focus-visible:ring-offset-2"
                aria-label={`${label} info`}
              />
            }
          >
            <InfoIcon aria-hidden="true" className="size-4" />
          </TooltipTrigger>
          <TooltipContent side="top" className="max-w-xs p-3">
            <p className="text-sm leading-5">{hint}</p>
          </TooltipContent>
        </Tooltip>
      ) : null}
      {addon}
    </div>
  )
}