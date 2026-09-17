"use client"

import type { PropsWithChildren } from "react"
import { Link, router, usePage } from "@inertiajs/react"
import { LogOut, User } from "lucide-react"

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
  const { props, url } = usePage<{ auth: { user: { email: string } | null } }>()
  const user = props.auth?.user

  // Signed out means the login or signup page, which brings its own centred
  // layout: a chrome of navigation nobody can use yet would only be in the way.
  if (!user) return <>{children}</>

  return (
    <SidebarProvider>
      <Sidebar>
        <SidebarHeader className="flex-row items-center gap-2 px-3 py-2 font-semibold">
          <User className="size-4" />
          user-auth
        </SidebarHeader>

        <SidebarContent>
          <SidebarGroup>
            <SidebarGroupLabel>Account</SidebarGroupLabel>
            <SidebarMenu>
              <SidebarMenuItem>
                <SidebarMenuButton isActive={url === "/"} render={<Link href="/" />}>
                  <User />
                  Profile
                </SidebarMenuButton>
              </SidebarMenuItem>
              <SidebarMenuItem>
                <SidebarMenuButton onClick={() => router.delete("/session")}>
                  <LogOut />
                  Log out
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
          <span className="font-medium">{user.email}</span>
        </header>
        {children}
      </SidebarInset>
    </SidebarProvider>
  )
}
