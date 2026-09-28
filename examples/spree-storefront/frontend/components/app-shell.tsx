"use client"

import type { PropsWithChildren } from "react"
import { Link, usePage } from "@inertiajs/react"
import { ListChecks, Plus } from "lucide-react"

import {
  Sidebar,
  SidebarContent,
  SidebarFooter,
  SidebarGroup,
  SidebarGroupLabel,
  SidebarHeader,
  SidebarInset,
  SidebarMenu,
  SidebarMenuButton,
  SidebarMenuItem,
  SidebarProvider,
  SidebarTrigger,
} from "@/components/ui/sidebar"

export function AppShell({ children }: PropsWithChildren) {
  const { url } = usePage()

  return (
    <SidebarProvider>
      <Sidebar>
        <SidebarHeader className="flex-row items-center gap-2 px-3 py-2 font-semibold">
          <ListChecks className="size-4" />
          todo-mvc
        </SidebarHeader>

        <SidebarContent>
          <SidebarGroup>
            <SidebarGroupLabel>Lists</SidebarGroupLabel>
            <SidebarMenu>
              <SidebarMenuItem>
                <SidebarMenuButton isActive={url === "/"} render={<Link href="/" />}>
                  <ListChecks />
                  All tasks
                </SidebarMenuButton>
              </SidebarMenuItem>
              <SidebarMenuItem>
                <SidebarMenuButton render={<Link href="/tasks/new" />}>
                  <Plus />
                  New task
                </SidebarMenuButton>
              </SidebarMenuItem>
            </SidebarMenu>
          </SidebarGroup>
        </SidebarContent>

        <SidebarFooter className="px-3 py-2 text-muted-foreground">ratalada</SidebarFooter>
      </Sidebar>

      <SidebarInset>
        <header className="flex h-12 items-center gap-2 border-b px-3">
          <SidebarTrigger />
          <span className="font-medium">Tasks</span>
        </header>
        {children}
      </SidebarInset>
    </SidebarProvider>
  )
}
