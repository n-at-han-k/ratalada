# frozen_string_literal: true

# The page behind the login. `require_user!` is the whole guard: anything that
# should be private calls it, and the login it bounces to comes back here.
get "/" do
  require_user!

  inertia("index", props: {
    last_login_at: current_user[:last_login_at],
  })
end

__END__

import { Head, router, usePage } from "@inertiajs/react"
import { LogOut } from "lucide-react"

import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Field, FieldLabel } from "@/components/ui/field"

export default function Index({ last_login_at }: { last_login_at: number | null }) {
  const { auth } = usePage<{ auth: { user: { id: number; email: string } | null } }>().props

  return (
    <main className="mx-auto w-full max-w-xl p-6">
      <Head title="Account" />

      <Card>
        <CardHeader>
          <CardTitle>Signed in</CardTitle>
          <CardDescription>This page is behind require_user!.</CardDescription>
        </CardHeader>

        <CardContent className="flex flex-col gap-4">
          <Field>
            <FieldLabel>Email</FieldLabel>
            <p className="text-sm">{auth.user?.email}</p>
          </Field>

          <Field>
            <FieldLabel>Last login</FieldLabel>
            <p className="text-sm">
              {last_login_at ? new Date(last_login_at * 1000).toLocaleString() : "just now"}
            </p>
          </Field>

          <Button variant="outline" onClick={() => router.delete("/session")}>
            <LogOut />
            Log out
          </Button>
        </CardContent>
      </Card>
    </main>
  )
}
