import { Badge } from "@/components/reui/badge"
import {
  Timeline,
  TimelineContent,
  TimelineHeader,
  TimelineIndicator,
  TimelineItem,
  TimelineSeparator,
  TimelineTitle,
} from "@/components/reui/timeline"
import { cn } from "cn"

import { Button } from "@/components/ui/button"
import {
  Card,
  CardContent,
  CardDescription,
  CardFooter,
  CardHeader,
  CardTitle,
} from "@/components/ui/card"
import { Textarea } from "@/components/ui/textarea"
import {
  poActivityStatusDotClass,
  poActivityToneBadgeVariant,
  poActivityToneDotClass,
  type IPoActivityEvent,
} from "./data"
import { MessageSquareIcon } from "lucide-react"

// ── PO activity timeline (reused from application/timeline/timeline-1) ──
// Reuses timeline-1's Timeline + TimelineItem composition, its separator and
// indicator offset grammar, with the tighter dot treatment from solution-inventory-9.
// Adapted to short purchase-order events with a note composer in the footer.

const TL_ITEM_CLASS = "group-data-[orientation=vertical]/timeline:ms-5"
const TL_SEPARATOR_CLASS =
  "bg-border group-data-[orientation=vertical]/timeline:-left-3 group-data-[orientation=vertical]/timeline:-translate-x-1/2 group-data-[orientation=vertical]/timeline:h-[calc(100%-1rem)] group-data-[orientation=vertical]/timeline:translate-y-4.5"
const TL_INDICATOR_CLASS =
  "size-2 border-0 ring-4 ring-background group-data-[orientation=vertical]/timeline:-left-3 group-data-[orientation=vertical]/timeline:-translate-x-1/2 group-data-[orientation=vertical]/timeline:top-1.5"

export function PoActivity({
  events,
  note,
  onNoteChange,
  onAddNote,
  className,
}: {
  events: IPoActivityEvent[]
  note: string
  onNoteChange: (value: string) => void
  onAddNote: () => void
  className?: string
}) {
  return (
    <Card className={cn("w-full gap-0 p-0", className)}>
      <CardHeader className="gap-1 px-5 py-4 sm:px-6">
        <div className="flex items-center justify-between gap-3">
          <CardTitle>Activity Log</CardTitle>
          <Badge variant="secondary" radius="full">
            {events.length} Events
          </Badge>
        </div>
        <CardDescription>Dock scans and receiving notes.</CardDescription>
      </CardHeader>

      <CardContent className="flex grow flex-col px-5 pb-1 sm:px-6">
        <Timeline defaultValue={0} aria-label="Purchase order activity">
          {events.map((event, index) => (
            <TimelineItem
              key={event.id}
              step={event.id}
              className={cn(
                TL_ITEM_CLASS,
                index === events.length - 1
                  ? "group-data-[orientation=vertical]/timeline:pb-0"
                  : "group-data-[orientation=vertical]/timeline:not-last:pb-6"
              )}
            >
              <TimelineHeader>
                {index === events.length - 1 ? null : (
                  <TimelineSeparator className={TL_SEPARATOR_CLASS} />
                )}
                <div className="flex flex-wrap items-center gap-2">
                  <TimelineTitle className="text-sm font-semibold">
                    {event.title}
                  </TimelineTitle>
                  <Badge
                    variant={poActivityToneBadgeVariant[event.tone]}
                    className="gap-1.5"
                  >
                    <span
                      className={cn(
                        "size-1.5 shrink-0 rounded-full",
                        poActivityToneDotClass[event.tone]
                      )}
                      aria-hidden="true"
                    />
                    {event.tone}
                  </Badge>
                </div>
                <TimelineIndicator
                  className={cn(
                    TL_INDICATOR_CLASS,
                    poActivityStatusDotClass[event.status],
                    event.status === "active" && "ring-info/20"
                  )}
                />
              </TimelineHeader>
              <TimelineContent className="mt-1.5 pb-0.5">
                <div className="text-muted-foreground flex min-w-0 flex-wrap items-center gap-1.5 text-xs">
                  <span className="font-medium">{event.actor}</span>
                  <span
                    aria-hidden="true"
                    className="bg-muted-foreground/40 size-1 shrink-0 rounded-full"
                  />
                  <span className="tabular-nums">{event.time}</span>
                </div>
                <p className="text-muted-foreground mt-1 text-xs leading-5">
                  {event.description}
                </p>
              </TimelineContent>
            </TimelineItem>
          ))}
        </Timeline>
      </CardContent>

      <CardFooter className="flex-col items-stretch gap-2 px-5 py-4 sm:px-6">
        <Textarea
          value={note}
          onChange={(event) => onNoteChange(event.target.value)}
          aria-label="Add receiving note"
          placeholder="Add a receiving note..."
          className="min-h-16"
        />
        <Button
          type="button"
          size="sm"
          className="self-end"
          disabled={note.trim().length === 0}
          onClick={onAddNote}
        >
          <MessageSquareIcon data-icon="inline-start" aria-hidden="true" />
          Add note
        </Button>
      </CardFooter>
    </Card>
  )
}