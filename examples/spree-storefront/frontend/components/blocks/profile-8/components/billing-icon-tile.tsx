"use client"

import type { ReactNode } from "react"
import { cn } from "cn"

import { Item, ItemMedia } from "@/components/ui/item"

export function BillingIconTile({
  children,
  className,
}: {
  children: ReactNode
  className?: string
}) {
  return (
    <Item
      aria-hidden="true"
      className={cn(
        "border-background bg-muted [&_svg]:text-accent-foreground flex size-10.5 shrink-0 items-center justify-center border-2 p-0 shadow-[0_1px_3px_0_rgba(0,0,0,0.14)] dark:border [&_svg]:size-5",
        className
      )}
    >
      <ItemMedia variant="icon" className="size-auto">
        {children}
      </ItemMedia>
    </Item>
  )
}