// Pass 5: write it.
//
//   node apply.mjs <frontend dir> <out dir> [--write]
//
// Every element in plan.json gets its utilities, and the stylesheet becomes
// what plan.mjs could not place. Edits are applied back-to-front so earlier
// offsets stay valid.
//
// Three shapes of className, three edits:
//
//   className="a"        -> className="a <utilities>"
//   className={expr}     -> className={`${expr} <utilities>`}
//   (none)               -> className="<utilities>"  after the tag name
import { readFileSync, writeFileSync } from "node:fs"
import path from "node:path"
import { createRequire } from "node:module"
const { parseSync } = createRequire(import.meta.url)("oxc-parser")

const [DIR, OUT, write] = process.argv.slice(2)
const plan = JSON.parse(readFileSync(path.join(OUT, "plan.json"), "utf8"))
const graph = JSON.parse(readFileSync(path.join(OUT, "graph.json"), "utf8"))
const nodes = graph.nodes

let files = 0, elements = 0
const broken = []
const shapes = { literal: 0, expression: 0, inserted: 0, skipped: 0 }

for (const [file, entries] of Object.entries(plan)) {
  const full = path.join(DIR, file)
  let src = readFileSync(full, "utf8")
  const edits = []

  for (const e of entries) {
    const n = nodes[e.nodeId]
    const add = e.add.join(" ")
    const r = n.attr

    if (r?.literal) {
      // `attr` spans the whole attribute -- `className="foo bar"` -- not the
      // string inside it. Find the quotes rather than assuming the ends.
      const text = src.slice(r.start, r.end)
      const q = text.search(/["\']/)
      const quote = text[q]
      const inner = text.slice(q + 1, text.lastIndexOf(quote))
      edits.push({ start: r.start, end: r.end, text: `className=${quote}${inner} ${add}${quote}` })
      shapes.literal++
    } else if (r) {
      const text = src.slice(r.start, r.end)                 // className={...}
      const open = text.indexOf("{")
      const expr = text.slice(open + 1, text.lastIndexOf("}"))
      edits.push({ start: r.start, end: r.end, text: "className={`${" + expr.trim() + '} ' + add + "`}" })
      shapes.expression++
    } else if (n.insertAt != null) {
      edits.push({ start: n.insertAt, end: n.insertAt, text: ` className="${add}"` })
      shapes.inserted++
    } else {
      shapes.skipped++
      continue
    }
    elements++
  }

  if (!edits.length) continue
  edits.sort((a, b) => b.start - a.start)
  const before = src
  for (const ed of edits) src = src.slice(0, ed.start) + ed.text + src.slice(ed.end)

  // An offset that is off by one turns source into rubble, and rubble that is
  // written is rubble in 109 files. Parse it back before it is allowed out.
  try {
    const res = parseSync(file, src)
    if (res.errors?.length) throw new Error(res.errors[0].message ?? "parse error")
  } catch (err) {
    broken.push(`${file}: ${err.message}`)
    src = before
    continue
  }

  if (write === "--write") writeFileSync(full, src)
  files++
}

if (write === "--write") {
  writeFileSync(path.join(DIR, "styles/swagger.css"), readFileSync(path.join(OUT, "remaining.css"), "utf8"))
}

if (broken.length) {
  console.log(`REFUSED -- ${broken.length} files would not parse back:`)
  broken.slice(0, 5).forEach((b) => console.log(`  ${b}`))
}
console.log(`files rewritten   ${files}`)
console.log(`elements touched  ${elements}`)
console.log(`  className="..."        ${shapes.literal}`)
console.log(`  className={expr}       ${shapes.expression}`)
console.log(`  className added        ${shapes.inserted}`)
console.log(`  no insertion point     ${shapes.skipped}`)
if (write !== "--write") console.log("\n(dry run -- pass --write)")
