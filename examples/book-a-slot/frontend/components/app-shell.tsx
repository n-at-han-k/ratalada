"use client"

import type { PropsWithChildren } from "react"
import { Link, usePage } from "@inertiajs/react"
import { CalendarClock, CalendarPlus } from "lucide-react"

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
          <CalendarClock className="size-4" />
          book-a-slot
        </SidebarHeader>

        <SidebarContent>
          <SidebarGroup>
            <SidebarGroupLabel>Scheduling</SidebarGroupLabel>
            <SidebarMenu>
              <SidebarMenuItem>
                <SidebarMenuButton isActive={url === "/"} render={<Link href="/" />}>
                  <CalendarPlus />
                  Book a slot
                </SidebarMenuButton>
              </SidebarMenuItem>
              <SidebarMenuItem>
                <SidebarMenuButton
                  isActive={url.startsWith("/bookings")}
                  render={<Link href="/bookings" />}
                >
                  <CalendarClock />
                  Booked slots
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
          <span className="font-medium">Schedule</span>
        </header>
        {children}
      </SidebarInset>
    </SidebarProvider>
  )
}
