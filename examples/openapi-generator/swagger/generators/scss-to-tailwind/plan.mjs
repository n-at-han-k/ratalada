// Passes 2, 3 and 4.
//
//   node plan.mjs <stylesheet> <out dir>
//
// 2. Resolution. Each selector's rightmost compound picks candidate JSX nodes
//    out of the render graph; the compounds to its left are conditions on
//    that node's ancestry.
//
// 3. Soundness, by dominance. A condition is VACUOUS when every path from the
//    app root to the node passes through an element satisfying it -- then the
//    rule can be inlined unconditionally. That is dominance, computed here as
//    backward reachability over parents: a node is always under `.a` if it
//    carries `.a`, or if all of its parents are. Cycles, dynamic classNames
//    and unresolved components make it unprovable, and unprovable means NO --
//    the rule stays a runtime variant rather than being inlined wrongly.
//
// 4. Cascade reduction. A node collects every declaration that reaches it with
//    its (specificity, source order). CSS keeps the last winner per property;
//    so does this, before a single utility is generated. That is what turns
//    .dark-mode's 304 declarations into the 2 that actually land on it.
import { readFileSync, writeFileSync } from "node:fs"
import path from "node:path"
import postcss from "postcss"
import { createRequire } from "node:module"
const { gen } = createRequire(import.meta.url)("tailwind-generator")

const [SHEET, OUT] = process.argv.slice(2)
const ROOT_CLASS = "swagger-ui"
const graph = JSON.parse(readFileSync(path.join(OUT, "graph.json"), "utf8"))
const nodes = graph.nodes
const roots = new Map(graph.roots)

// callers of a file: nodes whose component edge points at it
const callers = new Map()
for (const n of nodes) {
  if (!n.component) continue
  if (!callers.has(n.component)) callers.set(n.component, [])
  callers.get(n.component).push(n.id)
}

// every way control can arrive at a node
const parentsOf = (n) => {
  if (n.parent !== null) return [n.parent]
  return callers.get(n.file) ?? []
}

// ── pass 3: is `cls` on every path from the root to this node? ─────────
const memo = new Map()
const alwaysUnder = (id, cls, seen = new Set()) => {
  const key = `${id}\u0000${cls}`
  if (memo.has(key)) return memo.get(key)
  if (seen.has(id)) return false              // a cycle proves nothing
  const n = nodes[id]
  if (n.classes.includes(cls)) { memo.set(key, true); return true }
  const ps = parentsOf(n)
  if (ps.length === 0) { memo.set(key, false); return false }  // an entry point: not under anything
  seen.add(id)
  const all = ps.every((p) => alwaysUnder(p, cls, seen))
  seen.delete(id)
  memo.set(key, all)
  return all
}

// A computed className ADDS classes; it does not remove the literals beside
// it. `cx("opblock-tag", {...})` carries opblock-tag whatever the object says,
// so a positive match is sound. What a dynamic className can hide is a class
// we never see at all -- that risk is counted separately, below.

// ── pass 2: selectors ──────────────────────────────────────────────────
const PSEUDO_OK = { hover: "hover", focus: "focus", active: "active", visited: "visited",
  disabled: "disabled", checked: "checked", "focus-within": "focus-within",
  "focus-visible": "focus-visible", "first-child": "first", "last-child": "last" }

const esc = (s) => s.replace(/_/g, "\\_")

const compound = (text) => ({
  classes: (text.match(/\.[-\w]+/g) ?? []).map((c) => c.slice(1)),
  tag: (text.match(/^([a-z][a-z0-9]*)/) ?? [])[1] ?? null,
  pseudos: (text.match(/:[-\w]+/g) ?? []).map((p) => p.slice(1)),
  attr: text.includes("["),
})

const specificity = (sel) => {
  const ids = (sel.match(/#[-\w]+/g) ?? []).length
  const cls = (sel.match(/\.[-\w]+|\[[^\]]*\]|:[-\w]+/g) ?? []).length
  const els = (sel.match(/(^|[\s>+~])[a-z][a-z0-9]*/g) ?? []).length
  return ids * 10000 + cls * 100 + els
}

const mediaPrefix = (params) => {
  const max = params.match(/max-width:\s*(\d+)px/)
  const min = params.match(/min-width:\s*(\d+)px/)
  const bp = (n) => (n <= 640 ? "sm" : n <= 768 ? "md" : n <= 1024 ? "lg" : n <= 1280 ? "xl" : "2xl")
  if (max) return `max-${bp(+max[1])}:`
  if (min) return `${bp(+min[1])}:`
  return null
}

// node -> variant -> [{prop, value, spec, order}]
const applied = new Map()
const residue = []
// rule -> set of declaration indexes that found a home in the JSX
const consumed = new Map()
let order = 0
let matched = 0, unprovableCount = 0, noTarget = 0, hoistedCount = 0, unexpressible = 0

const css = postcss.parse(readFileSync(SHEET, "utf8"))

css.walkRules((rule) => {
  const atrule = rule.parent.type === "atrule" ? rule.parent : null
  if (atrule && !/^(media|supports)$/.test(atrule.name)) { residue.push([rule.selector, `@${atrule.name}`]); return }
  const media = atrule ? mediaPrefix(atrule.params) : ""
  if (media === null) { residue.push([rule.selector, `@media ${atrule.params}`]); return }

  const decls = rule.nodes.filter((n) => n.type === "decl")
  if (!decls.length) return

  // All or nothing. A rule whose `transition` or `content` tailwind cannot
  // express has to stay in the stylesheet, and it has to stay WHOLE -- taking
  // half of it into classNames and leaving half behind means two sources of
  // truth for one element.
  const whole = {}
  for (const d of decls) if (!d.important) whole[d.prop] = d.value
  const probe = gen(whole)
  // A utility carrying a quote cannot live in a JSX attribute -- an inline
  // `url("data:image/svg+xml,<svg ...>")` ends the attribute where the quote
  // is. A bracket nested inside an arbitrary variant is not parseable by
  // tailwind either. Both stay as CSS.
  const hostile = (probe.success ?? "").split(/\s+/).some(
    (u) => /["']/.test(u) || /\[[^\]]*\[/.test(u)
  )
  if (hostile) {
    for (const raw of rule.selector.split(",")) residue.push([raw.trim(), "not expressible in a className"])
    unexpressible++
    return
  }
  if (probe.failed.length || decls.some((d) => d.important)) {
    for (const raw of rule.selector.split(",")) residue.push([raw.trim(), `cannot express: ${probe.failed.join(" ") || "!important"}`])
    unexpressible++
    return
  }

  for (const raw of rule.selector.split(",")) {
    order++
    const sel = raw.trim().replace(/^\.swagger-ui\s*/, "")
    if (!sel || sel === `.${ROOT_CLASS}`) { residue.push([raw.trim(), "root element"]); continue }

    // Split into the element a className can sit on, and the rest of the
    // selector. The HOST is the leftmost compound carrying a class, because
    // that is the one findable in the JSX. Everything after it is ordinary
    // CSS and goes inside tailwind's arbitrary variant verbatim -- which is
    // what makes combinators, attributes and `:not()` fall out for free.
    const m = sel.match(/^([a-z0-9]*(?:\.[-\w]+)+(?::[-\w()]+)*)\s*(.*)$/i)
    if (!m) { residue.push([raw.trim(), "no class to hang it on"]); continue }
    const hostText = m[1]
    const rest = m[2].trim()
    const host = compound(hostText)
    if (!host.classes.length) { residue.push([raw.trim(), "no class to hang it on"]); continue }

    const variantBits = []
    let bad = null
    for (const p of host.pseudos) {
      if (PSEUDO_OK[p]) variantBits.push(`${PSEUDO_OK[p]}:`)
      else if (/^(before|after)$/.test(p)) variantBits.push(`${p}:`)
      else bad = `pseudo :${p}`
    }
    if (bad) { residue.push([raw.trim(), bad]); continue }

    // a second class on the host is a condition on the host itself
    for (const extra of host.classes.slice(1)) variantBits.push(`[&.${esc(extra)}]:`)

    const hostClass = host.classes[0]
    const hosts = nodes.filter((n) => n.classes.includes(hostClass))
    if (!hosts.length) { noTarget++; residue.push([raw.trim(), `no jsx node for .${hostClass}`]); continue }

    let targets = hosts
    let hoisted = false

    if (rest) {
      // Prefer pushing the declarations DOWN to the element they style: the
      // className is short and local. Only sound when the host dominates
      // every candidate -- otherwise the condition is real.
      const tail = compound(rest.split(/\s+/).pop())
      const down = (!/[>+~[]/.test(rest) && rest.split(/\s+/).length === 1 && !tail.pseudos.length)
        ? nodes.filter((n) => {
            if (tail.classes.length && !tail.classes.every((c) => n.classes.includes(c))) return false
            if (tail.tag && n.tag.toLowerCase() !== tail.tag) return false
            return tail.classes.length || tail.tag
          })
        : []

      if (down.length && down.every((n) => alwaysUnder(n.id, hostClass))) {
        targets = down
      } else {
        // The condition survives as a condition, on the host.
        variantBits.push(`[&${rest.startsWith(">") || rest.startsWith("+") || rest.startsWith("~") ? "" : "_"}${esc(rest).replace(/\s+/g, "_")}]:`)
        hoisted = true
        unprovableCount++
      }
    }

    matched++
    if (hoisted) hoistedCount++
    if (!consumed.has(rule)) consumed.set(rule, new Set())
    consumed.get(rule).add(raw.trim())
    const variant = media + variantBits.join("")
    const spec = specificity(raw)
    for (const n of targets) {
      if (!applied.has(n.id)) applied.set(n.id, new Map())
      const buckets = applied.get(n.id)
      if (!buckets.has(variant)) buckets.set(variant, [])
      for (const d of decls) buckets.get(variant).push({ prop: d.prop, value: d.value, spec, order, important: d.important })
    }
  }
})

// ── pass 4: cascade, then utilities ────────────────────────────────────
const plan = {}          // file -> [{ nodeId, tag, classes, add: [...] }]
let utilities = 0, failedProps = {}
for (const [id, buckets] of applied) {
  const n = nodes[id]
  const add = []
  for (const [variant, list] of buckets) {
    // CSS order: specificity, then source order; !important beats both
    list.sort((a, b) => (a.important - b.important) || (a.spec - b.spec) || (a.order - b.order))
    const winner = new Map()
    for (const d of list) winner.set(d.prop, d.value)
    const { success, failed } = gen(Object.fromEntries(winner))
    for (const f of failed) failedProps[f] = (failedProps[f] ?? 0) + 1
    const us = (success ? success.split(/\s+/).filter(Boolean) : []).map((u) => variant + u)
    add.push(...us)
    utilities += us.length
  }
  if (!add.length) continue
  ;(plan[n.file] = plan[n.file] ?? []).push({ nodeId: id, tag: n.tag, classes: n.classes, add: [...new Set(add)] })
}

// ── what still has to ship as css ──────────────────────────────────────
// A rule keeps the selectors that found no JSX home, and every declaration
// tailwind-generator could not express. A rule with nothing left is removed.
const keptProps = new Set()
for (const [id, buckets] of applied) {
  for (const [, list] of buckets) for (const d of list) keptProps.add(`${d.prop}\u0000${d.value}`)
}
css.walkRules((rule) => {
  const done = consumed.get(rule)
  const selectors = rule.selector.split(",").map((s) => s.trim())
  const left = done ? selectors.filter((s) => !done.has(s)) : selectors
  if (!left.length) {
    // every selector was placed; keep only declarations nothing could express
    const unexpressible = rule.nodes.filter((n) => n.type === "decl" && !keptProps.has(`${n.prop}\u0000${n.value}`))
    if (!unexpressible.length) { rule.remove(); return }
    rule.nodes = unexpressible
    return
  }
  rule.selector = left.join(",\n")
})
css.walkAtRules((at) => { if (!at.nodes?.length && /^(media|supports|container)$/.test(at.name)) at.remove() })
writeFileSync(path.join(OUT, "remaining.css"), css.toString())

writeFileSync(path.join(OUT, "plan.json"), JSON.stringify(plan, null, 1))
writeFileSync(path.join(OUT, "residue.txt"), residue.map(([s, why]) => `${why.padEnd(38)} ${s}`).join("\n"))

const sizes = Object.values(plan).flat().map((e) => e.add.length).sort((a, b) => b - a)
console.log(`selectors inlined        ${matched}`)
console.log(`  no jsx node            ${noTarget}`)
console.log(`  of which hoisted to an ancestor variant  ${hoistedCount}`)
console.log(`  ancestry unprovable, unhoistable         ${unprovableCount - hoistedCount}`)
console.log(`residue (stays as css)   ${residue.length}`)
console.log(`\nelements receiving utilities ${sizes.length} in ${Object.keys(plan).length} files`)
console.log(`utilities emitted            ${utilities}`)
console.log(`className length: max ${sizes[0] ?? 0}, median ${sizes[Math.floor(sizes.length / 2)] ?? 0}`)
const before = readFileSync(SHEET, "utf8").length
const after = readFileSync(path.join(OUT, "remaining.css"), "utf8").length
console.log(`stylesheet      ${before.toLocaleString()} -> ${after.toLocaleString()} bytes (${Math.round(100 - 100 * after / before)}% gone)`)
const worst = Object.entries(failedProps).sort((a, b) => b[1] - a[1]).slice(0, 6)
if (worst.length) console.log(`unconvertible properties: ${worst.map(([p, n]) => `${p} x${n}`).join(", ")}`)
