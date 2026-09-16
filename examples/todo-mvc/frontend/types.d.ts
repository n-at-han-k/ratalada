declare module "virtual:pages" {
  const pages: Record<string, () => Promise<{ default: React.ComponentType }>>
  export default pages
}
