# frozen_string_literal: true

get "/" do
  inertia("bookings", props: { host: HOST, bookings: bookings })
end

post "/" do
  date  = params["date"].to_s
  time  = params["time"].to_s
  name  = params["name"].to_s.strip
  email = params["email"].to_s.strip

  errors = {}
  errors[:slot]  = "That slot is no longer open" unless bookable?(date, time)
  errors[:name]  = "Give us a name for the booking" if name.empty?
  errors[:email] = "We need an email to send the invite" unless email.include?("@")

  if errors.any?
    page_errors(errors)
    redirect("/", 303)
  else
    begin
      DB.execute(
        "insert into bookings (date, time, name, email) values (?, ?, ?, ?)",
        date, time, name, email
      )
      redirect("/bookings", 303)
    rescue Extralite::Error
      # The unique index caught a slot someone else confirmed first.
      page_errors(slot: "Someone just took that slot")
      redirect("/", 303)
    end
  end
end

__END__

import { Head, Link, router } from "@inertiajs/react"
import { CalendarIcon, Trash2 } from "lucide-react"

import { Button } from "@/components/ui/button"
import { Card, CardAction, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Empty, EmptyDescription, EmptyHeader, EmptyMedia, EmptyTitle } from "@/components/ui/empty"
import { Item, ItemActions, ItemContent, ItemDescription, ItemGroup, ItemTitle } from "@/components/ui/item"
type Booking = { id: number; date: string; time: string; name: string; email: string }

type Host = { name: string; title: string }

export default function Bookings({ host, bookings }: { host: Host; bookings: Booking[] }) {
  return (
    <main className="mx-auto w-full max-w-xl p-6">
      <Head title="Booked slots" />

      <Card>
        <CardHeader>
          <CardTitle>Booked slots</CardTitle>
          <CardDescription>
            {bookings.length === 0
              ? `Nobody has booked ${host.name} yet.`
              : `${bookings.length} upcoming ${host.title.toLowerCase()}${bookings.length === 1 ? "" : "s"}.`}
          </CardDescription>
          <CardAction>
            <Button variant="outline" nativeButton={false} render={<Link href="/" />}>
              Book another
            </Button>
          </CardAction>
        </CardHeader>

        <CardContent>
          {bookings.length === 0 ? (
            <Empty>
              <EmptyHeader>
                <EmptyMedia variant="icon">
                  <CalendarIcon />
                </EmptyMedia>
                <EmptyTitle>No bookings</EmptyTitle>
                <EmptyDescription>Pick a slot on the booking page.</EmptyDescription>
              </EmptyHeader>
            </Empty>
          ) : (
            <ItemGroup>
              {bookings.map((booking) => (
                <Item key={booking.id} variant="outline" size="sm">
                  <ItemContent>
                    <ItemTitle>
                      {new Date(`${booking.date}T${booking.time}`).toLocaleString("en-US", {
                        weekday: "short",
                        day: "numeric",
                        month: "short",
                        hour: "2-digit",
                        minute: "2-digit",
                      })}
                    </ItemTitle>
                    <ItemDescription>
                      {booking.name} · {booking.email}
                    </ItemDescription>
                  </ItemContent>
                  <ItemActions>
                    <Button
                      variant="ghost"
                      size="icon-sm"
                      aria-label={`Cancel ${booking.name}'s slot`}
                      onClick={() => router.delete(`/bookings/${booking.id}`, { preserveScroll: true })}
                    >
                      <Trash2 />
                    </Button>
                  </ItemActions>
                </Item>
              ))}
            </ItemGroup>
          )}
        </CardContent>
      </Card>
    </main>
  )
}
