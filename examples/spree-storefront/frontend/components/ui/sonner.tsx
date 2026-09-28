import { Toaster as Sonner, type ToasterProps } from "sonner"

// reui has no sonner in its registry and next-themes isn't installed, so the
// toaster reads the same CSS variables the rest of the app themes with.
function Toaster(props: ToasterProps) {
  return (
    <Sonner
      className="toaster group"
      style={
        {
          "--normal-bg": "var(--popover)",
          "--normal-text": "var(--popover-foreground)",
          "--normal-border": "var(--border)",
        } as React.CSSProperties
      }
      {...props}
    />
  )
}

export { Toaster }
