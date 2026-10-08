import "@copilotkit/react-core/v2/styles.css"

import type { PropsWithChildren } from "react"
import { CopilotKit, CopilotPopup } from "@copilotkit/react-core/v2"

// THE CLIENT HALF of the copilot. The runtime is this app's own
// /api/copilotkit -- the ag-ui gem in ../../copilot.rb, in the same process --
// so the chat talks to this server and to nothing else.
//
// useSingleEndpoint={false}: the client uses the multi-route surface
// (/info, /agent/:id/run, /connect, /stop) the mount serves.
//
// MOUNTED AT THE INERTIA ROOT, around <App /> (frontend/entrypoints/
// application.tsx) -- NOT inside a layout or a shell component. That is the
// whole point: CopilotKit's tools and context are REACT-TREE SCOPED, so only
// what renders INSIDE this provider can register any. Put it around the app
// and every page can call useFrontendTool / useAgentContext, and what it
// registers lives exactly as long as the page is mounted -- so the agent's
// toolset is always what the current screen can actually do. See app/index.rb.
export function Copilot({ enabled, children }: PropsWithChildren<{ enabled?: boolean }>) {
  return (
    // THE PROVIDER IS UNCONDITIONAL, and that is not a style choice. A page
    // registers through hooks, and a hook cannot be skipped: drop the provider
    // when there is no model key and every page that registers a tool dies on
    // "useCopilotKit must be used within CopilotKitProvider" -- the whole
    // screen, not just the chat. So only the CHAT is conditional; with no
    // launcher there is nothing to start a run with anyway.
    <CopilotKit runtimeUrl="/api/copilotkit" useSingleEndpoint={false}>
      {children}
      {enabled && <CopilotPopup />}
    </CopilotKit>
  )
}
