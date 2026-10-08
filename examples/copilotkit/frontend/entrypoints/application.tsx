import "@/styles/application.css"

import { createInertiaApp } from "@inertiajs/react"
import { createRoot } from "react-dom/client"
import pages from "virtual:pages"

import { Copilot } from "@/components/copilot-chat"

// Every _layout.rb on the way down to the page wraps it, outermost first.
const layoutsFor = (name: string) => {
  const segments = name.split("/")
  segments.pop()
  return segments
    .map((_, index) => [...segments.slice(0, index), "_layout"].join("/"))
    .concat([...segments, "_layout"].join("/"))
    .filter((layout) => layout in pages)
}

createInertiaApp({
  resolve: async (name) => {
    const page = pages[name]
    if (!page) throw new Error(`No __END__ template in app/${name}.rb`)
    const module = await page()

    const layouts = await Promise.all(
      layoutsFor(name).map(async (layout) => (await pages[layout]!()).default),
    )

    if (layouts.length && module.default.layout === undefined) {
      module.default.layout = (child: React.ReactNode) =>
        layouts.reduceRight((inner, Layout) => <Layout>{inner}</Layout>, child)
    }

    return module
  },
  // THE COPILOT PROVIDER GOES HERE, around <App />, because CopilotKit's tools
  // and context only exist for components rendered inside it -- mount it in a
  // layout and no page could register its own. `copilot` is a shared prop from
  // server.rb; read off the initial page object because this is outside the
  // Inertia tree, and it is a server-wide fact that does not change per visit.
  setup: ({ el, App, props }) =>
    createRoot(el).render(
      <Copilot enabled={Boolean(props.initialPage.props.copilot)}>
        <App {...props} />
      </Copilot>,
    ),
})
