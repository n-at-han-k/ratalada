// The second pass: selectors a flat class->utilities map cannot express, but
// tailwind's variant syntax can.
//
//   .opblock-tag:hover        -> on .opblock-tag   hover:...
//   .opblock-tag svg          -> on .opblock-tag   [&_svg]:...
//   .opblock-tag .info__x     -> on .opblock-tag   [&_.info\_\_x]:...
//   .opblock.opblock-post     -> on .opblock       a CVA variant keyed opblock-post
//   @media (max-width:768px)  -> prefix            max-md:
//
// The KEY is the outermost class of the selector -- the element that already
// carries a className in the JSX -- and everything to its right becomes the
// variant that reaches the rest.
import postcss from "postcss"
import { createRequire } from "node:module"
import { readFileSync, writeFileSync } from "node:fs"
const { gen } = createRequire(import.meta.url)("tailwind-generator")

const [file, out] = process.argv.slice(2)
const ROOT = "swagger-ui"

const REPAIRS = [[/,,/g, ","], [/^font-\[bold\]$/, "font-bold"], [/^font-\[normal\]$/, "font-normal"], [/^rounded$/, "rounded-sm"]]
const repair = (u) => REPAIRS.reduce((c, [f, t]) => c.replace(f, t), u)

// tailwind escapes: `.info__x` is `[&_.info\_\_x]`
const esc = (s) => s.replace(/_/g, "\\_")

const PSEUDO = /^(hover|focus|active|visited|disabled|checked|first-child|last-child|focus-within|focus-visible)$/
const pseudoPrefix = (p) => ({ "first-child": "first", "last-child": "last" })[p] ?? p

const mediaPrefix = (params) => {
  const max = params.match(/max-width:\s*(\d+)px/)
  const min = params.match(/min-width:\s*(\d+)px/)
  const bp = (n) => (n <= 640 ? "sm" : n <= 768 ? "md" : n <= 1024 ? "lg" : n <= 1280 ? "xl" : "2xl")
  if (max) return `max-${bp(+max[1])}:`
  if (min) return `${bp(+min[1])}:`
  return null
}

// selector -> { key, variant } or null
const translate = (selector) => {
  const s = selector.trim().replace(/^\.swagger-ui\s*/, "")
  if (!s || s.startsWith("@") || s === `.${ROOT}`) return null

  // split on descendant combinators only; `>` `+` `~` keep their meaning
  const parts = s.split(/\s+/).filter(Boolean)
  const head = parts[0]

  // the element the className sits on must be a single class, optionally
  // with a pseudo or a second class of its own
  const headClasses = head.match(/\.[-\w]+/g) ?? []
  if (headClasses.length === 0) return null
  const key = headClasses[0].slice(1)
  if (key === ROOT) return null

  const prefixes = []

  // a second class on the head element is a variant of it
  for (const extra of headClasses.slice(1)) prefixes.push(`[&.${esc(extra.slice(1))}]:`)

  const pseudo = head.match(/:([-\w]+)/g)
  for (const p of pseudo ?? []) {
    const name = p.slice(1)
    if (!PSEUDO.test(name)) return null
    prefixes.push(`${pseudoPrefix(name)}:`)
  }

  // everything to the right is reached with an arbitrary descendant variant
  if (parts.length > 1) {
    const rest = parts.slice(1).join(" ")
    if (/[:[]/.test(rest)) return null // pseudo/attr inside the descendant: skip
    prefixes.push(`[&_${esc(rest.replace(/\s+/g, "_"))}]:`)
  }

  return { key, variant: prefixes.join("") }
}

const css = postcss.parse(readFileSync(file, "utf8"))
const map = {}
const skipped = []
let translated = 0

css.walkRules((rule) => {
  const media = rule.parent.type === "atrule" ? mediaPrefix(rule.parent.params) : ""
  if (media === null) { skipped.push(rule.selector); return }

  const decls = {}
  rule.nodes.forEach((n) => { if (n.type === "decl" && !n.important) decls[n.prop] = n.value })
  const { success, failed } = gen(decls)
  const base = success ? success.split(/\s+/).filter(Boolean).map(repair) : []
  if (!base.length) { if (failed.length) skipped.push(rule.selector); return }

  for (const one of rule.selector.split(",")) {
    const hit = translate(one)
    if (!hit) { skipped.push(one.trim()); continue }
    const prefix = media + hit.variant
    map[hit.key] = [...(map[hit.key] ?? []), ...base.map((u) => prefix + u)]
    translated++
  }
})

writeFileSync(`${out}/variant-map.json`, JSON.stringify(map, null, 2))
writeFileSync(`${out}/untranslatable.txt`, skipped.join("\n"))
console.log(`selectors translated  ${translated}`)
console.log(`classes touched       ${Object.keys(map).length}`)
console.log(`untranslatable        ${skipped.length}`)
const sizes = Object.entries(map).map(([k, v]) => [k, v.length]).sort((a, b) => b[1] - a[1])
console.log(`\nlongest classNames this would produce:`)
sizes.slice(0, 6).forEach(([k, n]) => console.log(`  ${String(n).padStart(4)} utilities  .${k}`))
console.log(`\nsample -- .opblock-tag:`)
console.log("  " + (map["opblock-tag"] ?? []).slice(0, 10).join(" "))
