"use client"

import { useState } from "react"
import { Badge } from "@/components/reui/badge"

import { Button } from "@/components/ui/button"
import { Card } from "@/components/ui/card"
import {
  Item,
  ItemActions,
  ItemContent,
  ItemTitle,
} from "@/components/ui/item"
import { OFFER } from "./data"
import { TicketPercentIcon, CheckIcon, ClockIcon, ShoppingBagIcon, ArrowRightIcon } from "lucide-react"

export function Coupon() {
  const [copied, setCopied] = useState(false)

  function handleCopy() {
    if (typeof navigator !== "undefined" && navigator.clipboard) {
      navigator.clipboard.writeText(OFFER.code).catch(() => {
        // Clipboard API can fail in iframes / unsupported browsers.
      })
    }
    setCopied(true)
    window.setTimeout(() => setCopied(false), 2000)
  }

  return (
    <section
      className="mx-auto w-full max-w-lg px-4 py-6 sm:px-6 lg:px-8 lg:py-8"
      aria-labelledby="coupon-4-heading"
    >
      <Card className="flex flex-col gap-6 p-6 sm:p-8">
        <div className="flex flex-wrap items-center gap-2">
          <Badge variant={OFFER.eyebrowVariant}>
            <TicketPercentIcon className="size-3" aria-hidden="true" />
            {OFFER.eyebrow}
          </Badge>
        </div>

        <div className="flex flex-col gap-2">
          <h1
            id="coupon-4-heading"
            className="text-foreground text-2xl font-semibold tracking-tight text-balance sm:text-3xl"
          >
            {OFFER.headline}
          </h1>
          <p className="text-muted-foreground max-w-prose text-sm leading-6">
            {OFFER.subheadline}
          </p>
        </div>

        <Item
          variant="muted"
          size="sm"
          className="border-border bg-muted/25 border border-dashed"
        >
          <ItemContent className="min-w-0 gap-0.5">
            <span className="text-muted-foreground text-[0.625rem] font-semibold tracking-wider uppercase">
              Promo code
            </span>
            <ItemTitle className="text-foreground font-mono text-xl font-semibold tracking-[0.18em] uppercase select-all sm:text-2xl">
              {OFFER.code}
            </ItemTitle>
          </ItemContent>
          <ItemActions>
            <Button
              type="button"
              variant={copied ? "secondary" : "default"}
              size="sm"
              onClick={handleCopy}
              aria-label={copied ? "Code copied" : `Copy code ${OFFER.code}`}
            >
              {copied ? (
                <CheckIcon data-icon="inline-start" className="text-success size-3.5" aria-hidden="true" />
              ) : (
                <TicketPercentIcon data-icon="inline-start" className="size-3.5" aria-hidden="true" />
              )}
              {copied ? "Copied" : "Copy"}
            </Button>
          </ItemActions>
        </Item>

        <div className="text-muted-foreground flex flex-wrap items-center gap-x-2.5 gap-y-1.5 text-xs">
          <span className="inline-flex items-center gap-1.5">
            <ClockIcon className="size-3.5" aria-hidden="true" />
            <strong className="text-foreground font-medium">
              {OFFER.expiresLabel}
            </strong>
          </span>
          {OFFER.minimumSpend ? (
            <>
              <span
                aria-hidden="true"
                className="bg-muted-foreground/40 size-1 shrink-0 rounded-full"
              />
              <span className="inline-flex items-center gap-1.5">
                <ShoppingBagIcon className="size-3.5" aria-hidden="true" />
                Min spend{" "}
                <strong className="text-foreground font-medium tabular-nums">
                  {OFFER.minimumSpend}
                </strong>
              </span>
            </>
          ) : null}
        </div>

        <ul
          className="text-muted-foreground flex flex-col gap-2 text-sm"
          aria-label="Offer terms"
        >
          {OFFER.fineprint.map((line) => (
            <li key={line} className="flex items-start gap-2 leading-snug">
              <CheckIcon className="text-success mt-0.5 size-4 shrink-0" aria-hidden="true" />
              <span>{line}</span>
            </li>
          ))}
        </ul>

        <div className="flex flex-wrap items-center gap-3">
          <Button type="button" size="lg">
            {OFFER.ctaLabel}
            <ArrowRightIcon data-icon="inline-end" className="size-4" aria-hidden="true" />
          </Button>
          <a
            href="#terms"
            className="text-muted-foreground hover:text-foreground text-sm underline-offset-4 hover:underline"
          >
            Full terms
          </a>
        </div>
      </Card>
    </section>
  )
}