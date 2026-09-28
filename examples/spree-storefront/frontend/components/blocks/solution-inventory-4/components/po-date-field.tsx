import { format } from "date-fns"

import { Button } from "@/components/ui/button"
import { Calendar } from "@/components/ui/calendar"
import {
  Popover,
  PopoverContent,
  PopoverTrigger,
} from "@/components/ui/popover"
import { CalendarIcon } from "lucide-react"

export function PoDateField({
  id,
  label,
  date,
  onSelect,
}: {
  id: string
  label: string
  date: Date
  onSelect: (date: Date) => void
}) {
  return (
    <Popover>
      <PopoverTrigger
        render={
          <Button
            type="button"
            id={id}
            variant="outline"
            className="w-full justify-between font-normal"
            aria-label={label}
          >
            <span className="truncate">{format(date, "LLL dd, y")}</span>
            <CalendarIcon data-icon="inline-end" aria-hidden="true" className="text-muted-foreground/80" />
          </Button>
        }
      />
      <PopoverContent className="w-auto p-0" align="start">
        <Calendar
          mode="single"
          selected={date}
          defaultMonth={date}
          onSelect={(nextDate) => {
            if (nextDate) {
              onSelect(nextDate)
            }
          }}
        />
      </PopoverContent>
    </Popover>
  )
}