import { type ReactNode } from "react"
import { cn } from "cn"

type SettingsHeadingProps = {
  title: string
  description: string
  action?: ReactNode
  className?: string
}

export function SettingsHeading({
  title,
  description,
  action,
  className,
}: SettingsHeadingProps) {
  return (
    <header
      className={cn(
        "flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between",
        className
      )}
    >
      <div className="flex min-w-0 flex-col gap-px">
        <h2 className="text-foreground text-base font-semibold tracking-tight capitalize">
          {title}
        </h2>
        <p className="text-muted-foreground text-sm">{description}</p>
      </div>

      {action ? <div className="shrink-0">{action}</div> : null}
    </header>
  )
}