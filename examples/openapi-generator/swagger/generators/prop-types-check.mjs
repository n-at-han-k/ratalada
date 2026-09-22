// Upstream strips propTypes in production, so a malformed one never runs
// there. We keep them, so each is a live crash at module load. Evaluate every
// propTypes expression against the real PropTypes object and report.
import { createRequire } from "node:module"
import { readFileSync, globSync } from "node:fs"
const require_ = createRequire(process.cwd() + "/x.js")
const PropTypes = require_("prop-types")
const ImPropTypes = require_("react-immutable-proptypes")

const MEMBER = /\b(PropTypes|ImPropTypes)((?:\.[A-Za-z_$][\w$]*)+)/g
const bad = []
let checked = 0

for (const file of globSync("frontend/**/*.{js,jsx,ts,tsx}")) {
  const src = readFileSync(file, "utf8")
  for (const m of src.matchAll(MEMBER)) {
    checked++
    const root = m[1] === "PropTypes" ? PropTypes : ImPropTypes
    let node = root
    const parts = m[2].slice(1).split(".")
    let path = m[1]
    for (const part of parts) {
      path += "." + part
      if (node == null || !(part in node)) {
        const line = src.slice(0, m.index).split("\n").length
        bad.push(`${file}:${line}  ${m[0]}   -- "${part}" is not on ${path.slice(0, path.lastIndexOf("."))}`)
        node = null
        break
      }
      node = node[part]
    }
  }
}
console.log(`propTypes expressions checked: ${checked}`)
console.log(`malformed: ${bad.length}`)
bad.forEach((b) => console.log("  " + b))
