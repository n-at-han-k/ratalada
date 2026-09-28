import { type ReactNode } from "react"
import { Badge, type BadgeProps } from "@/components/reui/badge"
import { cn } from "cn"

export function InvoiceSection({
  title,
  description,
  badge,
  badgeVariant = "secondary",
  action,
  className,
  children,
}: {
  title: string
  description?: string
  badge?: string
  badgeVariant?: BadgeProps["variant"]
  action?: ReactNode
  className?: string
  children: ReactNode
}) {
  return (
    <section className={cn("flex flex-col gap-4 sm:gap-5", className)}>
      <div className="flex min-w-0 flex-col gap-3 sm:flex-row sm:items-start sm:justify-between">
        <div className="flex min-w-0 flex-col gap-0.5">
          <div className="flex flex-wrap items-center gap-2">
            <h2 className="text-foreground text-base leading-6 font-semibold">
              {title}
            </h2>
            {badge ? <Badge variant={badgeVariant}>{badge}</Badge> : null}
          </div>
          {description ? (
            <p className="text-muted-foreground text-sm">{description}</p>
          ) : null}
        </div>
        {action ? <div className="shrink-0">{action}</div> : null}
      </div>

      {children}
    </section>
  )
}