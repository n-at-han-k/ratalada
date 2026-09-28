"use client"

import { useState } from "react"
import {
  Alert,
  AlertAction,
  AlertDescription,
  AlertTitle,
} from "@/components/reui/alert"

import { Button } from "@/components/ui/button"
import { ShieldCheckIcon } from "lucide-react"

export function ProfileSyncAlert() {
  const [dismissed, setDismissed] = useState(false)

  if (dismissed) {
    return null
  }

  return (
    <Alert variant="warning">
      <ShieldCheckIcon aria-hidden="true" />
      <AlertTitle>Profile updates are shared</AlertTitle>
      {/* Description */}
      <AlertDescription>
        Changes sync to mentions, approvals, and people directories in every
        workspace you join.
      </AlertDescription>
      <AlertAction>
        <Button
          type="button"
          variant="outline"
          size="xs"
          onClick={() => setDismissed(true)}
        >
          Dismiss
        </Button>
        <Button
          type="button"
          size="xs"
          onClick={() => {
            document
              .getElementById("profile-3-basic-details")
              ?.scrollIntoView({ behavior: "smooth", block: "start" })
          }}
        >
          Review Details
        </Button>
      </AlertAction>
    </Alert>
  )
}