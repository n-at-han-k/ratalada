"use client"

import {
  Sidebar,
  SidebarHeader,
  SidebarFooter,
  SidebarProvider,
} from "@/components/ui/sidebar"

export function AppShell() {
  return (
    <SidebarProvider>
      <Sidebar>
        <SidebarHeader>
          Header
        </SidebarHeader>

        <SidebarContent>
          Content
        </SidebarContent>

        <SidebarFooter>
          Footer
        </SidebarFooter>
      </Sidebar>
    </SidebarProvider>
  )
}
