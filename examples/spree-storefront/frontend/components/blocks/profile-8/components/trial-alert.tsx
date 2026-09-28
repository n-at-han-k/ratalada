import {
  Alert,
  AlertAction,
  AlertDescription,
  AlertTitle,
} from "@/components/reui/alert"

import { Button } from "@/components/ui/button"
import type { TrialNotice } from "./data"
import { ShieldAlertIcon } from "lucide-react"

interface TrialAlertProps {
  notice: TrialNotice
}

export function TrialAlert({ notice }: TrialAlertProps) {
  return (
    <Alert variant="destructive">
      <ShieldAlertIcon aria-hidden="true" />
      <AlertTitle>Renewal is blocked.</AlertTitle>
      {/* Description */}
      <AlertDescription>{notice.message}</AlertDescription>
      <AlertAction>
        <Button type="button">{notice.actionLabel}</Button>
      </AlertAction>
    </Alert>
  )
}