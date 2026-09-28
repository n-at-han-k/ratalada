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
import { CheckIcon, CircleIcon, TriangleAlertIcon } from "lucide-react"

import { Spinner } from "@/components/ui/spinner"

import { type ActivityEvent, type ActivityStatus } from "./data"

const indicatorStatusClass: Record<ActivityStatus, string> = {
  completed: "border-primary/30 bg-primary/10 text-primary",
  active: "border-primary bg-primary text-primary-foreground",
  pending: "border-border bg-muted/40 text-muted-foreground",
  issue:
    "border-destructive/40 bg-destructive/10 text-destructive dark:bg-destructive/20",
}

function StatusIcon({ status }: { status: ActivityStatus }) {
  if (status === "active") {
    return <Spinner className="size-3" />
  }

  if (status === "completed") {
    return <CheckIcon className="size-3" />
  }

  if (status === "issue") {
    return <TriangleAlertIcon className="size-3" />
  }

  return <CircleIcon className="size-2.5" />
}

interface AccountActivityRailProps {
  events: ActivityEvent[]
}

export function AccountActivityRail({ events }: AccountActivityRailProps) {
  return (
    <Timeline defaultValue={0} className="pl-2">
      {events.map((event, index) => (
        <TimelineItem
          key={event.id}
          step={index + 1}
          className={cn(index === events.length - 1 ? "pb-1" : "pb-4")}
        >
          <TimelineHeader>
            <TimelineSeparator className="group-data-[orientation=vertical]/timeline:h-[calc(100%-1.25rem-0.25rem)] group-data-[orientation=vertical]/timeline:translate-y-6" />
            <div className="flex flex-wrap items-center gap-x-2 gap-y-1">
              <TimelineTitle className="text-sm font-semibold">
                {event.title}
              </TimelineTitle>
              <span className="text-muted-foreground text-xs">{event.at}</span>
            </div>
            <TimelineIndicator
              className={cn(
                "flex size-5 items-center justify-center border",
                indicatorStatusClass[event.status],
                event.status === "active" && "ring-2 ring-current/20"
              )}
            >
              <StatusIcon status={event.status} />
            </TimelineIndicator>
          </TimelineHeader>

          <TimelineContent className="mt-1.5 space-y-1.5 pb-0.5">
            <p className="text-foreground text-sm leading-5">{event.summary}</p>

            <div className="flex flex-wrap items-center gap-1.5">
              {event.labels.map((label) => (
                <Badge
                  key={label.id}
                  variant={label.variant}
                  className="gap-1.5"
                >
                  <span>{label.label}</span>
                  {label.hint ? (
                    <span className="font-normal opacity-75">{label.hint}</span>
                  ) : null}
                </Badge>
              ))}
            </div>
          </TimelineContent>
        </TimelineItem>
      ))}
    </Timeline>
  )
}