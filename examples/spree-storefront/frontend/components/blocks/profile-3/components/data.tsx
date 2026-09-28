export type SelectOption = {
  value: string
  label: string
  description?: string
}

// ── Data ──

export const PROFILE_IDENTITY = {
  firstName: "Shandc",
  lastName: "",
  preferredName: "Shandc",
  email: "shandc@reui.dev",
  username: "shandc",
  phone: "+12065551243",
  role: "product-ops",
  language: "english",
  timeFormat: "24-hour",
  startWeek: "monday",
  timezone: "(GMT-5) New York",
  avatar: "https://github.com/shadcn.png",
  website: "shandc.dev",
} as const

export const ROLE_OPTIONS: SelectOption[] = [
  {
    value: "product-ops",
    label: "Product Operations",
    description: "Owns launch, enablement, and process design.",
  },
  {
    value: "growth-lead",
    label: "Growth Lead",
    description: "Shapes lifecycle messaging and experiment rollout.",
  },
  {
    value: "customer-ops",
    label: "Customer Operations",
    description: "Handles escalations, handoff quality, and support workflows.",
  },
]

export const LANGUAGE_OPTIONS: SelectOption[] = [
  {
    value: "english",
    label: "English",
  },
  {
    value: "german",
    label: "German",
  },
  {
    value: "spanish",
    label: "Spanish",
  },
]

export const START_WEEK_OPTIONS: SelectOption[] = [
  {
    value: "monday",
    label: "Monday",
  },
  {
    value: "sunday",
    label: "Sunday",
  },
  {
    value: "saturday",
    label: "Saturday",
  },
]

export const TIME_FORMAT_OPTIONS: SelectOption[] = [
  {
    value: "24-hour",
    label: "24-hour",
  },
  {
    value: "12-hour",
    label: "12-hour",
  },
]

export const TIMEZONE_GROUPS = [
  {
    value: "Americas",
    items: [
      "(GMT-8) Los Angeles",
      "(GMT-7) Denver",
      "(GMT-6) Chicago",
      "(GMT-5) New York",
      "(GMT-5) Toronto",
    ],
  },
  {
    value: "Europe",
    items: [
      "(GMT+0) London",
      "(GMT+1) Berlin",
      "(GMT+1) Paris",
      "(GMT+1) Amsterdam",
      "(GMT+2) Athens",
    ],
  },
  {
    value: "Asia Pacific",
    items: [
      "(GMT+4) Dubai",
      "(GMT+5) Tashkent",
      "(GMT+8) Singapore",
      "(GMT+9) Tokyo",
      "(GMT+11) Sydney",
    ],
  },
] as const