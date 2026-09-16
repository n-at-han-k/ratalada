# frozen_string_literal: true

# The booking page. Everything it needs for the whole window goes down in one
# payload — sixty days of slot times is a few kilobytes, so picking a date is
# the client's business and needs no round trip.
get "/" do
  taken = booked

  inertia(
    "index",
    props: {
      host:           HOST,
      slotTimes:      SLOT_TIMES,
      availableDates: available_dates(taken),
      booked:         taken,
    },
  )
end

__END__

import { useState } from "react"
import { Form, Head } from "@inertiajs/react"
import { CalendarCheckIcon, ClockIcon, GlobeIcon, LayoutDashboardIcon, VideoIcon } from "lucide-react"

import { BookingCalendar, dateKey } from "@/components/booking-calendar"
import { Frame, FrameFooter, FramePanel } from "@/components/reui/frame"
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar"
import { Button } from "@/components/ui/button"
import { Field, FieldError } from "@/components/ui/field"
import { Input } from "@/components/ui/input"
import { Item, ItemContent, ItemMedia, ItemTitle } from "@/components/ui/item"
import { ScrollArea } from "@/components/ui/scroll-area"

export type Host = {
  name: string
  role: string
  avatar: string
  title: string
  platform: string
  duration: number
}

type Props = {
  host: Host
  slotTimes: string[]
  availableDates: string[]
  booked: Record<string, string[]>
}

const timezone = Intl.DateTimeFormat().resolvedOptions().timeZone.replace("_", " ")

export default function Index({ host, slotTimes, availableDates, booked }: Props) {
  const available = new Set(availableDates)
  const [date, setDate] = useState<Date>(() => {
    const first = availableDates[0]
    return first ? new Date(`${first}T00:00:00`) : new Date()
  })
  const [time, setTime] = useState<string | null>(null)

  const key = dateKey(date)
  const taken = new Set(booked[key] ?? [])
  const open = available.has(key)

  const details = [
    { key: "title", icon: <LayoutDashboardIcon />, value: host.title },
    { key: "platform", icon: <VideoIcon />, value: host.platform },
    { key: "duration", icon: <ClockIcon />, value: `${host.duration} minutes` },
    { key: "timezone", icon: <GlobeIcon />, value: timezone },
  ]

  return (
    <main className="flex w-full justify-center p-6 md:p-10">
      <Head title="Book a slot" />

      <Frame className="w-full max-w-3xl overflow-hidden">
        <FramePanel className="divide-border flex divide-x p-0! max-lg:flex-col max-lg:divide-x-0 max-lg:divide-y">
          {/* Who and what is being booked. */}
          <div className="flex flex-1 shrink-0 flex-col gap-5 p-5 max-lg:w-full">
            <div className="flex flex-col items-center gap-2 text-center">
              <Avatar className="size-14!">
                <AvatarImage src={host.avatar} alt={host.name} />
                <AvatarFallback className="size-14!">
                  {host.name.split(" ").map((part) => part[0]).join("")}
                </AvatarFallback>
              </Avatar>
              <div className="flex flex-col">
                <span className="text-sm font-semibold">{host.name}</span>
                <span className="text-muted-foreground text-xs">{host.role}</span>
              </div>
            </div>

            <div className="flex flex-col gap-2.5">
              {details.map((detail) => (
                <Item key={detail.key} size="sm" className="min-h-0 p-0">
                  <ItemMedia
                    variant="icon"
                    className="size-4 [&_svg]:text-muted-foreground [&_svg:not([class*='size-'])]:size-4"
                  >
                    {detail.icon}
                  </ItemMedia>
                  <ItemContent>
                    <ItemTitle className="text-accent-foreground text-sm">{detail.value}</ItemTitle>
                  </ItemContent>
                </Item>
              ))}
            </div>
          </div>

          <div className="flex flex-wrap justify-center">
            <BookingCalendar
              selected={date}
              onSelect={(next) => {
                if (!next) return
                setDate(next)
                setTime(null)
              }}
              availableDates={available}
            />

            {/* Slots for the selected day; the ones already booked are out. */}
            <div className="border-border min-h-[395px] min-w-[150px] shrink-0 grow border-s p-5">
              <p className="text-foreground pt-1.5 text-sm font-semibold">
                {date.toLocaleDateString("en-US", { weekday: "long", day: "numeric" })}
              </p>

              {open ? (
                <ScrollArea className="-mr-3.5 max-h-[320px] pt-3 pr-3.5">
                  <div className="grid gap-1.5">
                    {slotTimes.map((slot) => (
                      <Button
                        key={slot}
                        disabled={taken.has(slot)}
                        onClick={() => setTime(slot)}
                        variant={time === slot ? "default" : "outline"}
                      >
                        {slot}
                      </Button>
                    ))}
                  </div>
                </ScrollArea>
              ) : (
                <div className="flex flex-col items-center gap-3 pt-10 text-center">
                  <span className="bg-muted flex size-10 items-center justify-center rounded-full">
                    <ClockIcon className="text-muted-foreground size-5" aria-hidden="true" />
                  </span>
                  <p className="text-muted-foreground text-xs">No slots available</p>
                </div>
              )}
            </div>
          </div>
        </FramePanel>

        <FrameFooter className="flex flex-col gap-3 px-3! py-2!">
          <Form action="/bookings" method="post" className="contents">
            {({ processing, errors }) => (
              <>
                <input type="hidden" name="date" value={key} />
                <input type="hidden" name="time" value={time ?? ""} />

                <div className="flex flex-col items-center gap-2 md:flex-row">
                  <div className="text-muted-foreground flex flex-1 items-center gap-1.5 text-xs">
                    <CalendarCheckIcon className="size-3.5 shrink-0" aria-hidden="true" />
                    {time ? (
                      <span className="text-foreground">
                        {date.toLocaleDateString("en-US", {
                          weekday: "long",
                          day: "numeric",
                          month: "long",
                        })}{" "}
                        at <strong className="font-semibold">{time}</strong>
                      </span>
                    ) : (
                      "Select a date and time to continue"
                    )}
                  </div>

                  <div className="flex w-full gap-2 md:w-auto">
                    <Input name="name" placeholder="Your name" aria-label="Your name" disabled={!time} />
                    <Input
                      type="email"
                      name="email"
                      placeholder="you@example.com"
                      aria-label="Your email"
                      disabled={!time}
                    />
                    <Button type="submit" disabled={!time || processing}>
                      Book
                    </Button>
                  </div>
                </div>

                {Object.values(errors).length > 0 && (
                  <Field>
                    <FieldError
                      errors={Object.values(errors).map((message) => ({ message: String(message) }))}
                    />
                  </Field>
                )}
              </>
            )}
          </Form>
        </FrameFooter>
      </Frame>
    </main>
  )
}
