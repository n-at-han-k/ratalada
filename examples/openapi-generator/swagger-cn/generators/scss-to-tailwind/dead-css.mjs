// Which rules in swagger.css can no longer match anything?
//
//   node generators/scss-to-tailwind/dead-css.mjs [--write]
//
// A rule is dead when every one of its selectors names a class that appears
// nowhere in the source. Class names are collected from EVERY string literal,
// not just className attributes, because swagger-ui assembles some in code
// (`let classes = ["model-box"]`) -- a lesson from deleting .model-box's rule
// and watching every nested model go unstyled.
import { readFileSync, writeFileSync, globSync, statSync } from "node:fs"
import postcss from "postcss"

const write = process.argv.includes("--write")
const SHEET = "frontend/styles/swagger.css"

const files = globSync("frontend/**/*.{js,jsx,ts,tsx}").filter(
  (f) => !f.includes("/components/ui/") && !f.includes("/components/reui/")
)

// The whole source as one blob. Parsing out "which strings are class names"
// kept mis-reading nested template literals and reporting live rules as dead,
// so the test is deliberately blunt: does this class name appear anywhere in
// the source? It over-keeps, which is the safe direction -- a rule wrongly
// kept costs bytes, a rule wrongly deleted costs styling.
const blob = files.map((f) => readFileSync(f, "utf8")).join("\n")
// Class names are also COMPOSED: `opblock-${method}` never appears in the
// source as "opblock-post", but every verb class is real at runtime. Collect
// the text that precedes an interpolation and treat anything starting with it
// as present -- deleting `.opblock.opblock-post` would strip the colour from
// every POST block on the page.
const prefixes = [...blob.matchAll(/([-\w]+)\$\{/g)].map((m) => m[1]).filter(Boolean)

const present = new Map()
const isPresent = (cls) => {
  if (present.has(cls)) return present.get(cls)
  // A composed name only counts when what follows the prefix looks like an
  // interpolated value -- one lowercase word, as in `opblock-${method}` ->
  // opblock-get. Accepting anything after the prefix marks the whole
  // `opblock-*` family present and reports nothing as dead, which is how this
  // check first returned 0.
  if (prefixes.some((p) => cls.startsWith(p) && /^[a-z]+$/.test(cls.slice(p.length)))) {
    present.set(cls, true)
    return true
  }
  const hit = new RegExp(`(^|[^-\\w])${cls.replace(/[.*+?^${}()|[\]\\]/g, "\\$&")}([^-\\w]|$)`).test(blob)
  present.set(cls, hit)
  return hit
}

const css = postcss.parse(readFileSync(SHEET, "utf8"))
let total = 0, dead = 0, deadBytes = 0
const samples = []

css.walkRules((rule) => {
  total++
  const sels = rule.selector.split(",").map((s) => s.trim())
  const isDead = sels.every((sel) => {
    const classes = (sel.match(/\.[-\w\\$]+/g) ?? []).map((c) => c.slice(1).replace(/\\/g, ""))
    if (!classes.length) return false           // element-only rules stay
    return classes.some((c) => !isPresent(c))
  })
  if (!isDead) return
  dead++
  deadBytes += rule.toString().length
  if (samples.length < 10) samples.push(sels[0])
  if (write) rule.remove()
})

if (write) {
  css.walkAtRules((a) => { if (!a.nodes?.length && /media|supports|container/.test(a.name)) a.remove() })
  writeFileSync(SHEET, css.toString())
}

const size = statSync(SHEET).size
console.log(`distinct classes tested       ${present.size}`)
console.log(`composed-name prefixes       ${[...new Set(prefixes)].length}`)
console.log(`rules                        ${total}`)
console.log(`  dead                       ${dead}  (~${deadBytes.toLocaleString()} bytes)`)
console.log(`  still matching             ${total - dead}`)
console.log(`swagger.css now              ${size.toLocaleString()} bytes`)
if (!write) {
  console.log("\nsample dead selectors:")
  samples.forEach((s) => console.log("  " + s.slice(0, 70)))
  console.log("\n(dry run -- pass --write)")
}
