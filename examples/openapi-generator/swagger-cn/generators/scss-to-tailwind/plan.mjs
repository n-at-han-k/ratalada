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

// tailwind-generator is a scrape of the v3 docs and gets three things wrong.
// These live here as well as in map.mjs because this is the pass that ships:
// `rgba(59,,65,,81,,0.3)` is not a colour, and every border that used one was
// silently lost.
const REPAIRS = [
  [/,,/g, ","],                       // a space inside a value became a comma
  [/^font-\[bold\]$/, "font-bold"],   // font-[x] is arbitrary font-FAMILY
  [/^font-\[normal\]$/, "font-normal"],
]
const repair = (u) => REPAIRS.reduce((c, [from, to]) => c.replace(from, to), u)

const [SHEET, OUT] = process.argv.slice(2)
const ROOT_CLASS = "swagger-ui"
const graph = JSON.parse(readFileSync(path.join(OUT, "graph.json"), "utf8"))
const nodes = graph.nodes
const roots = new Map(graph.roots)
// Classes assembled in code rather than written in a className attribute.
// `oas3/wrap-components/model.jsx` does `let classes = ["model-box"]`, so the
// extractor never sees that element carry it. Utilities can still be added to
// the elements we DID find, but the rule cannot leave the stylesheet -- the
// ones we did not find would lose their styling, which is exactly what turned
// every nested .model-box inline.
const inCode = new Set(graph.classesInCode ?? [])

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
// Every rule, with what it sets and how strongly, so the cascade can be
// checked for closure once the first pass has decided what converts.
const converted = []   // { selector, spec, props:Set, classes:Set, rule, raw }
const kept = []        // the same, for rules that stay in the stylesheet
// rule -> set of declaration indexes that found a home in the JSX
const consumed = new Map()
let order = 0
let matched = 0, unprovableCount = 0, noTarget = 0, hoistedCount = 0, unexpressible = 0, namedInCode = 0

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
  const ruleClasses = new Set((rule.selector.match(/\.[-\w]+/g) ?? []).map((c) => c.slice(1)))
  // The classes on the element a selector actually styles -- its rightmost
  // compound. Two rules can only fight over an element that satisfies both.
  const targetClassesOf = (sel) => new Set(
    ((sel.trim().split(/\s+|[>+~]/).filter(Boolean).pop() ?? "").match(/\.[-\w]+/g) ?? []).map((c) => c.slice(1)))
  const ruleProps = new Set(decls.map((d) => d.prop))
  const probe = gen(whole)
  // A utility carrying a quote cannot live in a JSX attribute -- an inline
  // `url("data:image/svg+xml,<svg ...>")` ends the attribute where the quote
  // is. A bracket nested inside an arbitrary variant is not parseable by
  // tailwind either. Both stay as CSS.
  const hostile = (probe.success ?? "").split(/\s+/).map(repair).some(
    (u) => /["']/.test(u) || /\[[^\]]*\[/.test(u)
  )
  if (hostile) {
    for (const raw of rule.selector.split(",")) { residue.push([raw.trim(), "not expressible in a className"]); kept.push({ raw: raw.trim(), spec: specificity(raw), props: ruleProps, target: targetClassesOf(raw) }) }
    unexpressible++
    return
  }
  if (probe.failed.length || decls.some((d) => d.important)) {
    for (const raw of rule.selector.split(",")) { residue.push([raw.trim(), `cannot express: ${probe.failed.join(" ") || "!important"}`]); kept.push({ raw: raw.trim(), spec: specificity(raw), props: ruleProps, target: targetClassesOf(raw) }) }
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

    // Conditions on the host element. These are only valid while the
    // utilities STAY on the host -- `[&.opblock-post]` asks whether THIS
    // element carries the class. If the declarations are later pushed down to
    // a descendant they have to be re-expressed from the descendant's point
    // of view, as an ancestor selector; see `hostSideBits` below.
    const hostSideBits = host.classes.slice(1).map((extra) => `[&.${esc(extra)}]:`)
    variantBits.push(...hostSideBits)

    if (/[[\]]/.test(hostText)) { residue.push([raw.trim(), "attribute selector on the host"]); continue }

    const hostClass = host.classes[0]
    const hosts = nodes.filter((n) => n.classes.includes(hostClass))
    if (!hosts.length) { noTarget++; residue.push([raw.trim(), `no jsx node for .${hostClass}`]); continue }
    if (inCode.has(hostClass)) {
      namedInCode++
      residue.push([raw.trim(), `.${hostClass} is built in code -- carriers unknown`])
      continue
    }

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
        // Moving down means the host's own conditions are now conditions on an
        // ANCESTOR. `.opblock.opblock-post .opblock-summary-method` becomes
        // `[.opblock.opblock-post_&]:` on the badge -- not `[&.opblock-post]:`,
        // which asks whether the badge itself carries the verb class and is
        // never true. That mistake painted every method badge black.
        if (hostSideBits.length || host.pseudos.length) {
          variantBits.length = 0
          for (const p of host.pseudos) variantBits.push(PSEUDO_OK[p] ? `${PSEUDO_OK[p]}:` : `${p}:`)
          variantBits.push(`[${esc(hostText.replace(/:[-\w()]+/g, ""))}_&]:`)
        }
      } else if (/[[\]]/.test(rest)) {
        // `[&_input[type=text]]:` -- a bracket inside an arbitrary variant is
        // not parseable by tailwind, so the utility compiles to nothing and
        // the declaration is silently lost. That emptied the auth modal's
        // inputs of their min-width.
        residue.push([raw.trim(), "attribute selector cannot be a variant"])
        continue
      } else {
        // The condition survives as a condition, on the host.
        variantBits.push(`[&${rest.startsWith(">") || rest.startsWith("+") || rest.startsWith("~") ? "" : "_"}${esc(rest).replace(/\s+/g, "_")}]:`)
        hoisted = true
        unprovableCount++
      }
    }

    converted.push({ raw: raw.trim(), spec: specificity(raw), props: ruleProps, target: targetClassesOf(raw), rule })
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
      for (const d of decls) buckets.get(variant).push({ prop: d.prop, value: d.value, spec, order, important: d.important, from: raw.trim() })
    }
  }
})

// ── cascade closure ───────────────────────────────────────────────────
//
// A converted rule becomes a utility, in `layer(utilities)`. Everything that
// stays behind sits in `layer(components)`, which loses to utilities whatever
// its specificity. So a rule that USED to be overridden by a stronger one
// will now win, if the stronger one could not be converted.
//
// `.swagger-ui .copy-to-clipboard { position: absolute }` is 0-2-0 and was
// overridden by `.swagger-ui .opblock .opblock-summary .view-line-link`
// at 0-3-0 -- which carries a `transition` and cannot be expressed. Converting
// the weaker rule alone moved the copy link to the top right of the page.
//
// So the cascade has to be closed: a rule may only convert when no rule that
// stayed behind, could match the same element, and sets the same property,
// is stronger than it. Sharing a class is a loose test for "could match the
// same element", and loose in the safe direction -- it demotes more than
// strictly necessary, never less.
const collisionCache = new Map()
const canCollide = (a, b) => {
  if (!a.size || !b.size) return true            // an untargeted rule might hit anything
  const key = [...a].sort().join(".") + "|" + [...b].sort().join(".")
  if (collisionCache.has(key)) return collisionCache.get(key)
  const hit = nodes.some((n) => {
    for (const c of a) if (!n.classes.includes(c)) return false
    for (const c of b) if (!n.classes.includes(c)) return false
    return true
  })
  collisionCache.set(key, hit)
  return hit
}

const demoted = new Set()
for (const c of converted) {
  for (const k of kept) {
    if (k.spec <= c.spec) continue
    // Could one element satisfy both rules' target compounds? Ask the JSX,
    // rather than guessing from a shared class name -- `.copy-to-clipboard`
    // and `.view-line-link` do land on one element, `.opblock` and
    // `.model-box` never do.
    if (!canCollide(c.target, k.target)) continue
    let overlaps = false
    for (const prop of c.props) if (k.props.has(prop)) { overlaps = true; break }
    if (!overlaps) continue
    demoted.add(c.raw)
    residue.push([c.raw, `overridden by a rule that stays: ${k.raw.slice(0, 40)}`])
    break
  }
}

// Undo their utilities, and put their selectors back in the stylesheet.
for (const c of converted) {
  if (!demoted.has(c.raw)) continue
  const done = consumed.get(c.rule)
  if (done) done.delete(c.raw)
  matched--
}
for (const [id, buckets] of applied) {
  for (const [variant, list] of buckets) {
    const survivors = list.filter((d) => !demoted.has(d.from))
    if (survivors.length) buckets.set(variant, survivors)
    else buckets.delete(variant)
  }
  if (!buckets.size) applied.delete(id)
}

// ── pass 4: cascade, then utilities ────────────────────────────────────
const plan = {}          // file -> [{ nodeId, tag, classes, add: [...] }]
let utilities = 0, failedProps = {}, malformed = 0
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
    const wellFormed = (u) => {
      let depth = 0
      for (const ch of u) {
        if (ch === "[") { if (++depth > 1) return false }
        else if (ch === "]") depth--
      }
      return depth === 0
    }
    const us = (success ? success.split(/\s+/).filter(Boolean) : [])
      .map((u) => variant + repair(u))
      .filter((u) => { if (wellFormed(u)) return true; malformed++; return false })
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
console.log(`  class built in code    ${namedInCode}`)
console.log(`  of which hoisted to an ancestor variant  ${hoistedCount}`)
console.log(`  ancestry unprovable, unhoistable         ${unprovableCount - hoistedCount}`)
console.log(`  demoted for cascade    ${demoted.size}`)
console.log(`residue (stays as css)   ${residue.length}`)
console.log(`\nelements receiving utilities ${sizes.length} in ${Object.keys(plan).length} files`)
console.log(`utilities emitted            ${utilities}${malformed ? `  (${malformed} malformed, dropped)` : ""}`)
console.log(`className length: max ${sizes[0] ?? 0}, median ${sizes[Math.floor(sizes.length / 2)] ?? 0}`)
const before = readFileSync(SHEET, "utf8").length
const after = readFileSync(path.join(OUT, "remaining.css"), "utf8").length
console.log(`stylesheet      ${before.toLocaleString()} -> ${after.toLocaleString()} bytes (${Math.round(100 - 100 * after / before)}% gone)`)
const worst = Object.entries(failedProps).sort((a, b) => b[1] - a[1]).slice(0, 6)
if (worst.length) console.log(`unconvertible properties: ${worst.map(([p, n]) => `${p} x${n}`).join(", ")}`)
