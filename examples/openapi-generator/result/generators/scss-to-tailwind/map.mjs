// SCSS out, tailwind in -- step one and two.
//
//   node map.mjs <entry.scss> <project root> <out dir>
//
// 1. sass compiles the fork's stylesheets to flat CSS. $variables, @include
//    and &-nesting all resolve HERE, before anything else looks at them --
//    postcss parses SCSS but does not evaluate it, so a map built off the
//    source would see `padding: $pad-sm` and give up.
// 2. every rule whose selector names ONE class with no condition on it
//    becomes an entry in map.json: the class, and the tailwind utilities
//    `tailwind-generator` says are the same declarations.
//
// A rule that is conditional on anything else -- a pseudo-class, an element,
// a real ancestor, a media query -- is NOT a map entry, because a class name
// cannot carry the condition. `.opblock.opblock-post .opblock-summary-method`
// colours the method badge by verb: 20 selectors, one class name. Those are
// variants (class-variance-authority), and they are left in leftover.css for
// a person to move into the component that already knows the verb.
import { compile } from "sass-embedded"
import postcss from "postcss"
import Tokenizer from "css-selector-tokenizer"
import { createRequire } from "node:module"
import { readFileSync, writeFileSync } from "node:fs"

const { gen } = createRequire(import.meta.url)("tailwind-generator")

// tailwind-generator is a scrape of the v3 docs, and it gets three things
// wrong for us. Each is checked against the map it actually produces, not
// guessed at -- run `pnpm scss:map` and grep before adding a fourth.
const REPAIRS = [
  // `color: rgb(50%, 50%, 50%)`: the space inside the value becomes a second
  // comma, and `rgb(50%,,50%,,50%)` is not a colour.
  [/,,/g, ","],
  // `font-[x]` is arbitrary font-FAMILY. Correct for `monospace`, nonsense
  // for a weight -- `font-family: bold` is not a rule.
  [/^font-\[bold\]$/, "font-bold"],
  [/^font-\[normal\]$/, "font-normal"],
  // v3 `rounded` is 0.25rem; in v4 that scale step is `rounded-sm`.
  [/^rounded$/, "rounded-sm"],
]

const repair = (utility) => REPAIRS.reduce((c, [from, to]) => c.replace(from, to), utility)
const [entry, root, out] = process.argv.slice(2)

// The root class every component renders inside, so `.swagger-ui .x` is a
// condition on nothing.
const ROOT = "swagger-ui"

// Once the SCSS is gone the entry is the flat stylesheet itself, and there is
// nothing to compile -- the rest of the pipeline is the same either way, so
// it keeps working against a swagger.css that shrinks rule by rule.
const css = entry.endsWith(".css")
  ? readFileSync(entry, "utf8")
  : compile(entry, {
      loadPaths: [`${root}/node_modules`, `${root}/frontend`],
      style: "expanded",
      silenceDeprecations: ["import", "slash-div", "global-builtin"],
    }).css

writeFileSync(`${out}/compiled.css`, css)

// The one class a selector targets, or null when it targets anything else.
const targetOf = (selector) => {
  const parsed = Tokenizer.parse(selector)
  if (parsed.nodes.length !== 1) return null // a comma list is several rules
  const nodes = parsed.nodes[0].nodes
  if (!nodes.every((node) => ["class", "spacing"].includes(node.type))) return null
  const names = nodes.filter((node) => node.type === "class").map((node) => node.name)
  const target = names.filter((name) => name !== ROOT)
  return target.length === 1 ? target[0] : null
}

const map = {}
const mentions = {} // class -> how many rules mention it at all
const leftover = []
const failures = {}
let rules = 0

const root_ = postcss.parse(css)

root_.walkRules((rule) => {
  ;(rule.selector.match(/\.[a-zA-Z][-a-zA-Z0-9_\\$]*/g) ?? []).forEach((c) => {
    const name = c.slice(1)
    mentions[name] = (mentions[name] ?? 0) + 1
  })
})

root_.walkRules((rule) => {
  rules++
  const conditional = rule.parent.type === "atrule"
  const target = conditional ? null : targetOf(rule.selector)

  if (!target) {
    leftover.push(rule)
    return
  }

  const decls = {}
  const important = []
  rule.nodes.forEach((node) => {
    if (node.type !== "decl") return
    if (node.important) important.push(node)
    else decls[node.prop] = node.value
  })

  const { success, failed } = gen(decls)
  failed.forEach((prop) => (failures[prop] = (failures[prop] ?? 0) + 1))

  const utilities = success ? success.split(/\s+/).filter(Boolean).map(repair) : []
  // Source order is cascade order, so a class named twice appends.
  if (utilities.length) map[target] = [...(map[target] ?? []), ...utilities]

  if (failed.length || important.length) {
    const kept = rule.clone()
    kept.nodes = kept.nodes.filter(
      (node) => node.type !== "decl" || failed.includes(node.prop) || node.important,
    )
    leftover.push(kept)
  }
})

writeFileSync(`${out}/map.json`, JSON.stringify(map, null, 2))
writeFileSync(`${out}/mentions.json`, JSON.stringify(mentions, null, 2))
writeFileSync(`${out}/leftover.css`, leftover.map((rule) => rule.toString()).join("\n\n"))

const worst = Object.entries(failures).sort((a, b) => b[1] - a[1]).slice(0, 8)
console.log(`rules           ${rules}`)
console.log(`mapped          ${Object.keys(map).length} classes`)
console.log(`leftover rules  ${leftover.length}`)
console.log(`unconverted props: ${worst.map(([p, n]) => `${p} x${n}`).join(", ")}`)
