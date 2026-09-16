"use client"

import { useState } from "react"
import type { DayButton } from "react-day-picker"

import { cn } from "cn"
import { Button } from "@/components/ui/button"
import { Calendar, CalendarDayButton } from "@/components/ui/calendar"
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select"
import { ChevronLeftIcon, ChevronRightIcon } from "lucide-react"

const MONTHS = Array.from({ length: 12 }, (_, i) =>
  new Date(2000, i, 1).toLocaleString("en-US", { month: "long" }),
)

// Local calendar day, not UTC: toISOString() shifts the key a day west of GMT.
export const dateKey = (date: Date) =>
  `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, "0")}-${String(
    date.getDate(),
  ).padStart(2, "0")}`

export function BookingCalendar({
  selected,
  onSelect,
  availableDates,
}: {
  selected: Date
  onSelect: (date: Date | undefined) => void
  availableDates: Set<string>
}) {
  const today = new Date()
  const [month, setMonth] = useState<Date>(selected)

  const years = Array.from({ length: 2 }, (_, i) => today.getFullYear() + i)

  const stepMonth = (delta: number) =>
    setMonth((prev) => new Date(prev.getFullYear(), prev.getMonth() + delta, 1))

  return (
    <div className="flex flex-col gap-4 p-5 select-none">
      <div className="flex items-center justify-between gap-1">
        <Button
          variant="ghost"
          size="sm"
          className="size-7 shrink-0 p-0"
          onClick={() => stepMonth(-1)}
          aria-label="Previous month"
        >
          <ChevronLeftIcon className="size-3.5" aria-hidden="true" />
        </Button>

        <Select
          value={MONTHS[month.getMonth()]}
          onValueChange={(value) => {
            const i = MONTHS.indexOf(value as string)
            if (i >= 0) setMonth(new Date(month.getFullYear(), i, 1))
          }}
        >
          <SelectTrigger size="sm" className="min-w-0 flex-1">
            <SelectValue />
          </SelectTrigger>
          <SelectContent>
            {MONTHS.map((m) => (
              <SelectItem key={m} value={m}>
                {m}
              </SelectItem>
            ))}
          </SelectContent>
        </Select>

        <Select
          value={String(month.getFullYear())}
          onValueChange={(value) =>
            setMonth(new Date(Number(value), month.getMonth(), 1))
          }
        >
          <SelectTrigger size="sm" className="w-22 shrink-0">
            <SelectValue />
          </SelectTrigger>
          <SelectContent>
            {years.map((y) => (
              <SelectItem key={y} value={String(y)}>
                {y}
              </SelectItem>
            ))}
          </SelectContent>
        </Select>

        <Button
          variant="ghost"
          size="sm"
          className="size-7 shrink-0 p-0"
          onClick={() => stepMonth(1)}
          aria-label="Next month"
        >
          <ChevronRightIcon className="size-3.5" aria-hidden="true" />
        </Button>
      </div>

      <Calendar
        mode="single"
        selected={selected}
        onSelect={onSelect}
        month={month}
        onMonthChange={setMonth}
        showOutsideDays
        hideNavigation
        disabled={(date) => !availableDates.has(dateKey(date))}
        className="w-full bg-transparent p-0 [--cell-size:--spacing(10.5)]"
        formatters={{
          formatWeekdayName: (date) =>
            date.toLocaleString("en-US", { weekday: "short" }).toUpperCase(),
        }}
        classNames={{
          month_caption: "hidden",
          nav: "hidden",
          weekdays: "flex gap-1",
          weekday:
            "flex-1 flex items-center justify-center h-6 text-[0.65rem] font-medium text-muted-foreground",
          week: "flex gap-1 mt-1",
          day: "flex-1 aspect-square p-0",
          day_button: cn(
            "bg-muted/50 hover:bg-muted rounded-md",
            "data-[selected-single=true]:bg-primary data-[selected-single=true]:text-primary-foreground data-[selected-single=true]:hover:bg-primary data-[selected-single=true]:hover:text-primary-foreground!",
          ),
          outside: "opacity-60",
          disabled: "opacity-40",
          today: "bg-accent text-foreground rounded-md",
        }}
        components={{
          // The availability dot: a day the server still has a free slot on.
          DayButton: ({
            children,
            modifiers,
            day,
            ...props
          }: React.ComponentProps<typeof DayButton>) => {
            const free = !modifiers.outside && availableDates.has(dateKey(day.date))
            return (
              <CalendarDayButton day={day} modifiers={modifiers} {...props}>
                <span
                  className={cn(
                    "size-1 rounded-full",
                    free && "bg-primary in-data-[selected-single=true]:bg-primary-foreground!",
                  )}
                  aria-hidden
                />
                {children}
              </CalendarDayButton>
            )
          },
        }}
      />
    </div>
  )
}
