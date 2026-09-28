import { type CSSProperties } from "react"
import {
  Frame,
  FrameFooter,
  FramePanel,
} from "@/components/reui/frame"
import { IconStack } from "@/components/reui/icon-stack"

import { Button } from "@/components/ui/button"
import {
  Empty,
  EmptyContent,
  EmptyDescription,
  EmptyHeader,
  EmptyMedia,
  EmptyTitle,
} from "@/components/ui/empty"
import { Separator } from "@/components/ui/separator"
import {
  Tooltip,
  TooltipContent,
  TooltipProvider,
  TooltipTrigger,
} from "@/components/ui/tooltip"
import { Building2Icon, InfoIcon } from "lucide-react"

export function EmptyState() {
  return (
    <section
      className="flex w-full max-w-5xl flex-col gap-8"
      aria-labelledby="organizations-heading"
    >
      <div className="flex flex-col gap-6">
        <h2
          id="organizations-heading"
          className="text-2xl font-semibold tracking-tight"
        >
          Organizations
        </h2>
        <Separator />
      </div>

      <TooltipProvider delay={200}>
        <Frame spacing="xs" className="w-full" aria-label="Organizations setup">
          <FramePanel className="flex min-h-[274px] items-center justify-center px-6 py-12">
            <Empty className="max-w-md flex-none bg-transparent p-0">
              <EmptyHeader className="gap-5">
                <EmptyMedia className="mb-0">
                  <IconStack
                    aria-hidden="true"
                    className="h-20 w-18"
                    style={
                      {
                        "--icon-stack-content-x": "70%",
                        "--icon-stack-content-y": "57%",
                      } as CSSProperties
                    }
                  >
                    <Building2Icon className="size-4.5" strokeWidth="1.8" aria-hidden="true" />
                  </IconStack>
                </EmptyMedia>

                <div className="flex flex-col items-center gap-2">
                  <EmptyTitle className="text-base font-semibold tracking-tight">
                    Enable organizations
                  </EmptyTitle>
                  <EmptyDescription className="max-w-sm text-sm/relaxed">
                    Enable your users to create organizations, manage team
                    members, and control access with role-based permissions.
                  </EmptyDescription>
                </div>
              </EmptyHeader>

              <EmptyContent className="mt-5 max-w-none gap-0">
                <Button type="button">Enable organizations</Button>
              </EmptyContent>
            </Empty>
          </FramePanel>

          <FrameFooter className="flex-row items-center justify-start">
            <Tooltip>
              <TooltipTrigger
                render={
                  <a
                    href="#organizations-docs"
                    className="text-muted-foreground hover:text-foreground focus-visible:ring-ring/50 inline-flex items-center gap-1.5 rounded-sm text-xs font-medium transition-colors outline-none focus-visible:ring-[3px]"
                  />
                }
              >
                <InfoIcon className="size-3.5" aria-hidden="true" />
                <span>
                  Learn more about{" "}
                  <span className="text-primary">Organizations</span>
                </span>
              </TooltipTrigger>
              <TooltipContent side="top" className="max-w-64">
                Organizations group users, teams, roles, and permissions under
                one account boundary.
              </TooltipContent>
            </Tooltip>
          </FrameFooter>
        </Frame>
      </TooltipProvider>
    </section>
  )
}