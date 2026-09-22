import { resolve } from "node:path"
import { defineConfig } from "vite"
import RubyPlugin from "vite-plugin-ruby"
import react from "@vitejs/plugin-react"
import tailwindcss from "@tailwindcss/vite"
import svgr from "vite-plugin-svgr"

export default defineConfig({
  plugins: [
    RubyPlugin(),
    react(),
    tailwindcss(),
    // The fork imports .svg as components, the way upstream's @svgr/webpack
    // gave it them -- so every .svg is one, no `?react` suffix.
    svgr({ include: "**/*.svg" }),
  ],
  resolve: {
    alias: {
      "@": resolve(import.meta.dirname, "frontend"),
      // swagger-ui's deps still reach for node: `xml` wants stream and util,
      // swagger-client wants buffer, sha.js and randombytes want crypto.
      // Upstream's webpack had a `fallback` map (webpack/_config-builder.js).
      //
      // The trailing slash matters. `util: "util"` resolves back to node's
      // OWN util -- the alias names itself -- and vite externalises it, which
      // is the "Module has been externalized" error. `util/` can only be the
      // package. `stream-browserify` needs no slash because nothing in node
      // is called that.
      stream: "stream-browserify",
      events: "events/",
      util: "util/",
      buffer: "buffer/",
      crypto: "crypto-browserify",
    },
  },
  // `deep-extend` and friends read `global`. The other node globals are set
  // at runtime in frontend/lib/node-globals.ts -- `define` does not reach the
  // dependency pre-bundle that dev serves from.
  define: { global: "globalThis" },

  // Relative to `root`, which vite-plugin-ruby sets to frontend/ -- so
  // todo-mvc's "frontend/**/*.tsx" globs frontend/frontend and matches
  // nothing (vite's globEntries uses `cwd: config.root`). Harmless there,
  // fatal here: with no entry to crawl the scanner pre-bundles react and
  // nothing else, and the fork's other ~120 packages are then discovered one
  // importer at a time, each discovery re-optimizing and reloading the page.
  optimizeDeps: { entries: ["entrypoints/*.tsx"] },
})
