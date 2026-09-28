export type GoalValue = "pipeline" | "support" | "reporting"

export type SourceValue = "crm" | "helpdesk" | "warehouse" | "csv"

export type SelectOption<TValue extends string = string> = {
  value: TValue
  label: string
  description: string
}

export type Stakeholder = {
  id: string
  name: string
  email: string
  role: string
}

export const GOAL_OPTIONS: SelectOption<GoalValue>[] = [
  {
    value: "pipeline",
    label: "Pipeline",
    description: "Accounts and follow-up work.",
  },
  {
    value: "support",
    label: "Support",
    description: "Tickets and customer signals.",
  },
  {
    value: "reporting",
    label: "Reporting",
    description: "Dashboards from trusted data.",
  },
]

export const TEAM_SIZE_OPTIONS: SelectOption[] = [
  {
    value: "small",
    label: "2-10 people",
    description: "Pilot team.",
  },
  {
    value: "growth",
    label: "11-50 people",
    description: "Department rollout.",
  },
  {
    value: "enterprise",
    label: "51+ people",
    description: "Multi-team launch.",
  },
]

export const TIMELINE_OPTIONS: SelectOption[] = [
  {
    value: "this-week",
    label: "This week",
    description: "Fast pilot.",
  },
  {
    value: "two-weeks",
    label: "Next 2 weeks",
    description: "Standard setup.",
  },
  {
    value: "quarter",
    label: "This quarter",
    description: "Managed rollout.",
  },
]

export const TEMPLATE_OPTIONS: SelectOption[] = [
  {
    value: "blank",
    label: "Blank workspace",
    description: "Core objects only.",
  },
  {
    value: "revops",
    label: "Revenue operations",
    description: "Accounts, deals, and handoffs.",
  },
  {
    value: "customer-success",
    label: "Customer success",
    description: "Health and renewal workflows.",
  },
]

export const SOURCE_OPTIONS: SelectOption<SourceValue>[] = [
  {
    value: "crm",
    label: "CRM",
    description: "Accounts and contacts.",
  },
  {
    value: "helpdesk",
    label: "Help Desk",
    description: "Tickets and escalations.",
  },
  {
    value: "warehouse",
    label: "Warehouse",
    description: "Product and revenue tables.",
  },
  {
    value: "csv",
    label: "CSV Import",
    description: "One-time upload.",
  },
]

export const STAKEHOLDERS: Stakeholder[] = [
  {
    id: "maya",
    name: "Maya Chen",
    email: "maya.chen@northstar.dev",
    role: "Implementation",
  },
  {
    id: "ethan",
    name: "Ethan Brooks",
    email: "ethan.brooks@northstar.dev",
    role: "Operations",
  },
  {
    id: "sofia",
    name: "Sofia Duarte",
    email: "sofia.duarte@northstar.dev",
    role: "Success",
  },
  {
    id: "kai",
    name: "Kai Morgan",
    email: "kai.morgan@northstar.dev",
    role: "Data",
  },
]

export const DEFAULT_STAKEHOLDERS = [STAKEHOLDERS[0], STAKEHOLDERS[3]]