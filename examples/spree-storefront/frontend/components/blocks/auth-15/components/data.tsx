import type { ReactNode } from "react"

import { Apple } from "@/components/ui/svgs/apple"
import { AppleDark } from "@/components/ui/svgs/appleDark"
import { GithubDark } from "@/components/ui/svgs/githubDark"
import { GithubLight } from "@/components/ui/svgs/githubLight"
import { Google } from "@/components/ui/svgs/google"

export type AuthProvider = {
  id: string
  label: string
  logo: ReactNode
}

export type FooterLink = {
  id: string
  label: string
  href: string
}

function ThemeLogo({ light, dark }: { light: ReactNode; dark: ReactNode }) {
  return (
    <>
      <span aria-hidden="true" className="dark:hidden">
        {light}
      </span>
      <span aria-hidden="true" className="hidden dark:block">
        {dark}
      </span>
    </>
  )
}

export const AUTH15_SOCIAL_PROVIDERS: AuthProvider[] = [
  {
    id: "google",
    label: "Continue with Google",
    logo: <Google aria-hidden="true" data-icon="inline-start" />,
  },
  {
    id: "apple",
    label: "Continue with Apple",
    logo: (
      <ThemeLogo
        light={<Apple aria-hidden="true" data-icon="inline-start" />}
        dark={<AppleDark aria-hidden="true" data-icon="inline-start" />}
      />
    ),
  },
  {
    id: "github",
    label: "Continue with GitHub",
    logo: (
      <ThemeLogo
        light={<GithubLight aria-hidden="true" data-icon="inline-start" />}
        dark={<GithubDark aria-hidden="true" data-icon="inline-start" />}
      />
    ),
  },
]

export const AUTH15_FOOTER_LINKS: FooterLink[] = [
  {
    id: "privacy",
    label: "Privacy Policy",
    href: "#",
  },
  {
    id: "docs",
    label: "Docs",
    href: "#",
  },
  {
    id: "support",
    label: "Support",
    href: "#",
  },
]