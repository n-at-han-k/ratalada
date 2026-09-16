import { globSync, readFileSync } from "node:fs"
import { resolve } from "node:path"
import { defineConfig, transformWithOxc, type Plugin } from "vite"
import RubyPlugin from "vite-plugin-ruby"
import react from "@vitejs/plugin-react"
import tailwindcss from "@tailwindcss/vite"

const APP = resolve(import.meta.dirname, "app")
const MAILERS = resolve(import.meta.dirname, "lib", "mailers")

// Everything after __END__ in a .rb file: the page or email template it carries.
const endBlock = (file: string) => {
  const source = readFileSync(file, "utf8")
  const end = source.match(/^__END__\n/m)
  return end ? source.slice(end.index! + end[0].length) : null
}

// Pages live in the __END__ block of their route file: app/login.rb serves
// GET /login and carries the Login component after __END__. This exposes each
// one to Vite as a .tsx module, and `virtual:pages` as the name -> import map
// the Inertia resolver reads.
function rubyPages(): Plugin {
  const names = () =>
    globSync("**/*.rb", { cwd: APP })
      .map((file) => file.slice(0, -3))
      .filter((name) => template(name) !== null)

  const template = (name: string) => endBlock(resolve(APP, `${name}.rb`))

  return {
    name: "ruby-pages",
    // app/ sits outside the Vite root (frontend/), so it isn't watched.
    configureServer: (server) => void server.watcher.add(APP),
    handleHotUpdate({ file, server }) {
      if (!file.startsWith(APP)) return
      // Nothing in the module graph points at the .rb file: the page is a
      // virtual module keyed by name, so a reload alone re-serves the module
      // vite already loaded. Invalidate the page and the name -> import map
      // (a new app/*.rb belongs in it) before asking the client to reload.
      const graph = server.environments.client.moduleGraph
      for (const id of [
        `\0virtual:page/${file.slice(APP.length + 1, -3)}.tsx`,
        "\0virtual:pages",
      ]) {
        const module = graph.getModuleById(id)
        if (module) graph.invalidateModule(module)
      }
      server.hot.send({ type: "full-reload" })
    },
    // "\0" marks these as virtual so nothing tries to read them off disk.
    resolveId: (id) => (id.startsWith("virtual:page") ? `\0${id}` : null),
    load(id) {
      if (id === "\0virtual:pages") {
        const entries = names()
          .map((name) => `  ${JSON.stringify(name)}: () => import("virtual:page/${name}.tsx"),`)
          .join("\n")
        return `export default {\n${entries}\n}\n`
      }
      if (id.startsWith("\0virtual:page/")) {
        const name = id.slice("\0virtual:page/".length, -".tsx".length)
        const tsx = template(name)
        // Virtual ids skip vite's own TSX transform in dev, so run it here.
        return tsx && transformWithOxc(tsx, `${name}.tsx`, { lang: "tsx" })
      }
      return null
    },
  }
}

// Mailers have the same shape as pages: Ruby above __END__, a React Email
// template below. bin/emails loads `virtual:emails` and renders each one to the
// .html.erb / .text.erb pair that hanami-mailer actually sends.
function rubyEmails(): Plugin {
  const template = (name: string) => endBlock(resolve(MAILERS, `${name}.rb`))

  return {
    name: "ruby-emails",
    resolveId: (id) => (id.startsWith("virtual:email") ? `\0${id}` : null),
    load(id) {
      if (id === "\0virtual:emails") {
        const entries = globSync("*.rb", { cwd: MAILERS })
          .map((file) => file.slice(0, -3))
          .filter((name) => template(name) !== null)
          .map((name) => `  ${JSON.stringify(name)}: () => import("virtual:email/${name}.tsx"),`)
          .join("\n")
        return `export default {\n${entries}\n}\n`
      }
      if (id.startsWith("\0virtual:email/")) {
        const name = id.slice("\0virtual:email/".length, -".tsx".length)
        const tsx = template(name)
        return tsx && transformWithOxc(tsx, `${name}.tsx`, { lang: "tsx" })
      }
      return null
    },
  }
}

export default defineConfig({
  plugins: [RubyPlugin(), react(), tailwindcss(), rubyPages(), rubyEmails()],
  resolve: {
    alias: { "@": resolve(import.meta.dirname, "frontend") },
  },
  server: {
    // The page comes from http://tradeportal.local:8080 — traefik in the k3s
    // VM, routed back to bin/serve on the host — so the module and HMR URLs it
    // writes carry that Host. Vite answers only for hosts it knows, and 403s
    // every asset otherwise, which reads in the browser as a blank page.
    // The bind address is config/vite.json's development.host: tradeportal.local
    // resolves to 127.0.0.1 with no AAAA record, and vite's default "localhost"
    // binds ::1 only.
    allowedHosts: ["tradeportal.local"],
    // Without this the client infers the HMR socket from the page's origin and
    // tries tradeportal.local:8080, where traefik has no /vite-dev/ route: it
    // fails, logs, and only then falls back to a direct connection. Name the
    // dev server's own address and the first attempt is the right one.
    hmr: { host: "tradeportal.local", port: 3036, protocol: "ws" },
  },
})
