"use client"

import type { ReactNode } from "react"
import { cn } from "cn"

interface SettingsSectionProps {
  title: string
  description?: string
  action?: ReactNode
  children: ReactNode
  className?: string
}

export function SettingsSection({
  title,
  description,
  action,
  children,
  className,
}: SettingsSectionProps) {
  return (
    <section className={cn("flex flex-col gap-5", className)}>
      {/* Heading */}
      <div className="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
        <div className="flex min-w-0 flex-col gap-px">
          <h2 className="text-base font-semibold">{title}</h2>
          {description ? (
            <p className="text-muted-foreground text-sm">{description}</p>
          ) : null}
        </div>

        {action ? (
          <div className="flex shrink-0 items-center">{action}</div>
        ) : null}
      </div>

      {children}
    </section>
  )
}