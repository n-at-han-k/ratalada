import type { BadgeProps } from "@/components/reui/badge"

export type Offer = {
  /** Short label shown in the eyebrow Badge. */
  eyebrow: string
  eyebrowVariant: BadgeProps["variant"]
  /** Discount headline. */
  headline: string
  /** Single-sentence subhead describing what the offer applies to. */
  subheadline: string
  /** Promo code the buyer copies. */
  code: string
  /** Primary CTA copy. */
  ctaLabel: string
  ctaHref: string
  /** Plain English expiry summary. */
  expiresLabel: string
  /** Optional minimum spend. Renders as written. */
  minimumSpend?: string
  /** Three short fineprint lines. */
  fineprint: string[]
}

export const OFFER: Offer = {
  eyebrow: "Member offer",
  eyebrowVariant: "secondary",
  headline: "15% off your next order",
  subheadline:
    "Apply the code at checkout and the discount lands automatically on every eligible item in your cart.",
  code: "WELCOME15",
  ctaLabel: "Shop now",
  ctaHref: "#shop",
  expiresLabel: "Expires Aug 15",
  minimumSpend: "$50",
  fineprint: [
    "Valid on regular-price items.",
    "One use per customer.",
    "Cannot stack with other percentage discounts.",
  ],
}