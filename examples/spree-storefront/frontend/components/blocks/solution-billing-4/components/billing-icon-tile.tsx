import type { ReactNode } from "react"
import { cn } from "cn"

export function BillingIconTile({
  children,
  className,
}: {
  children: ReactNode
  className?: string
}) {
  return (
    <span
      aria-hidden="true"
      className={cn(
        "bg-muted/40 flex size-10 shrink-0 items-center justify-center border",
        "rounded-md",
        "[&_svg]:size-4.5 [&_svg]:opacity-80",
        className
      )}
    >
      {children}
    </span>
  )
}