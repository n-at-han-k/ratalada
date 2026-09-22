// Step three: the part that really is a find and replace.
//
//   node apply.mjs <project root> <out dir> [--write]
//
// A class is SAFE to inline only when all three hold:
//
//   1. map.json has utilities for it -- its rule was unconditional;
//   2. exactly one rule in the whole stylesheet mentions it, so inlining the
//      utilities and deleting that rule loses nothing. A class mentioned by a
//      second rule is styled by context somewhere, and the context does not
//      travel into a className;
//   3. every appearance of the name in the source is inside a
//      `className="..."` literal this script rewrites. One in a
//      `classnames({...})` key, a template literal or a variable would keep
//      the name after its rule was deleted, and lose its styling silently.
//
// Everything else stays in swagger.css and is somebody's afternoon with
// class-variance-authority.
import { readFileSync, writeFileSync } from "node:fs"
import { globSync } from "node:fs"
import postcss from "postcss"

const [root, out, write] = process.argv.slice(2)
const map = JSON.parse(readFileSync(`${out}/map.json`, "utf8"))
const mentions = JSON.parse(readFileSync(`${out}/mentions.json`, "utf8"))

const files = globSync("frontend/{components,lib}/**/*.{jsx,tsx,js,ts}", { cwd: root })
const sources = new Map(files.map((f) => [f, readFileSync(`${root}/${f}`, "utf8")]))

const CLASSNAME = /className\s*=\s*"([^"]*)"/g

// Every class name in a className literal, and every bare word anywhere else.
const inAttr = new Set()
const anywhere = new Map()
for (const [file, text] of sources) {
  const attrs = []
  for (const m of text.matchAll(CLASSNAME)) {
    attrs.push(m[0])
    m[1].split(/\s+/).filter(Boolean).forEach((c) => inAttr.add(c))
  }
  const outside = attrs.reduce((acc, a) => acc.replace(a, ""), text)
  for (const name of Object.keys(map)) {
    if (new RegExp(`\\b${name.replace(/[$]/g, "\\$")}\\b`).test(outside)) {
      anywhere.set(name, [...(anywhere.get(name) ?? []), file])
    }
  }
}

const safe = Object.keys(map).filter(
  (name) => inAttr.has(name) && mentions[name] === 1 && !anywhere.has(name),
)
const blocked = Object.keys(map).filter((name) => inAttr.has(name) && !safe.includes(name))

// ── rewrite the JSX ────────────────────────────────────────────────────
const safeSet = new Set(safe)
let touched = 0
for (const [file, text] of sources) {
  const next = text.replace(CLASSNAME, (whole, list) => {
    const names = list.split(/\s+/).filter(Boolean)
    if (!names.some((n) => safeSet.has(n))) return whole
    const swapped = names.flatMap((n) => (safeSet.has(n) ? map[n] : [n]))
    return `className="${[...new Set(swapped)].join(" ")}"`
  })
  if (next !== text) {
    touched++
    if (write === "--write") writeFileSync(`${root}/${file}`, next)
  }
}

// ── and drop those rules from the stylesheet ───────────────────────────
const css = postcss.parse(readFileSync(`${out}/compiled.css`, "utf8"))
let dropped = 0
css.walkRules((rule) => {
  if (rule.parent.type === "atrule") return
  const names = (rule.selector.match(/\.[a-zA-Z][-a-zA-Z0-9_\\$]*/g) ?? []).map((c) => c.slice(1))
  const target = names.filter((n) => n !== "swagger-ui")
  if (target.length === 1 && safeSet.has(target[0])) {
    rule.remove()
    dropped++
  }
})
if (write === "--write") writeFileSync(`${root}/frontend/styles/swagger.css`, css.toString())

console.log(`mapped classes used by the jsx  ${Object.keys(map).filter((n) => inAttr.has(n)).length}`)
console.log(`  safe to inline                ${safe.length}`)
console.log(`  held back                     ${blocked.length}`)
console.log(`jsx files rewritten             ${touched}`)
console.log(`rules dropped from the css      ${dropped}`)
if (write !== "--write") console.log("\n(dry run -- pass --write)")
