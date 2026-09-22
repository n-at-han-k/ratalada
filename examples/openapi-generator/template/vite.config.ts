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
    // swagger-ui's forked source imports .svg as components (upstream builds
    // with @svgr/webpack), so every .svg is one here -- no `?react` suffix.
    svgr({ include: "**/*.svg" }),
  ],
  resolve: {
    alias: { "@": resolve(import.meta.dirname, "frontend") },
  },
  css: {
    // main.scss pulls tachyons out of node_modules; sass has no bundler
    // resolution of its own.
    preprocessorOptions: { scss: { loadPaths: ["node_modules"] } },
  },
  // swagger-client and immutable both expect node globals in the browser.
  define: { global: "globalThis" },
})
