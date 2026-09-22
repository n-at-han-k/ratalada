// Pass 1: the render graph.
//
//   node graph.mjs <frontend dir> <out dir>
//
// A CSS selector matches a DOM tree. Utilities go on JSX. To move one to the
// other soundly we need to know, statically, which JSX nodes can appear where
// -- so this builds the tree the components would render, as far as it can be
// known without running them.
//
// Nodes are JSX elements: tag, the classes they carry, whether any of those
// classes are decided at runtime, and their children. Edges also run THROUGH
// components: <Operation/> in one file continues into the elements
// operation.jsx returns. swagger-ui resolves most of its children by string
// through a registry (`getComponent("Operation")`), and the registry is static
// data, so those edges resolve too.
//
// What cannot be resolved is recorded rather than guessed: a computed
// component name, a className built from a variable. Every later pass reads
// those flags and refuses to inline through them.
import { readFileSync, writeFileSync, globSync } from "node:fs"
import path from "node:path"
import { createRequire } from "node:module"
const { parseSync } = createRequire(import.meta.url)("oxc-parser")

const [DIR, OUT] = process.argv.slice(2)
const EXT = [".tsx", ".ts", ".jsx", ".js"]

const files = globSync("**/*.{js,jsx,ts,tsx}", { cwd: DIR }).sort()
const source = new Map(files.map((f) => [f, readFileSync(path.join(DIR, f), "utf8")]))
const ast = new Map()
for (const f of files) {
  try { ast.set(f, parseSync(f, source.get(f)).program) } catch { /* unparsed: reported below */ }
}

const resolve = (spec, from) => {
  let base
  if (spec.startsWith("@/")) base = spec.slice(2)
  else if (spec.startsWith(".")) base = path.normalize(path.join(path.dirname(from), spec))
  else return null
  for (const c of [...EXT.map((e) => base + e), ...EXT.map((e) => `${base}/index${e}`)]) {
    if (ast.has(c)) return c
  }
  return null
}

const walk = (node, visit, parent = null) => {
  if (!node || typeof node !== "object") return
  if (Array.isArray(node)) { node.forEach((n) => walk(n, visit, parent)); return }
  if (node.type) visit(node, parent)
  for (const k of Object.keys(node)) {
    if (k === "type" || k === "start" || k === "end") continue
    walk(node[k], visit, node.type ? node : parent)
  }
}

// ── imports, so <Foo/> and getComponent("Foo") can be followed ──────────
const imports = new Map() // file -> { localName: targetFile }
for (const [f, tree] of ast) {
  const m = {}
  for (const s of tree.body) {
    if (s.type !== "ImportDeclaration" || !s.specifiers) continue
    const target = resolve(s.source.value, f)
    if (!target) continue
    for (const sp of s.specifiers) m[sp.local.name] = target
  }
  imports.set(f, m)
}

// ── the component registry: name -> file ───────────────────────────────
// Plugins and presets declare `components: { Name: Component }`; the value is
// an identifier this file imported, so the import table resolves it.
const registry = {}
let registryEntries = 0
for (const [f, tree] of ast) {
  const local = imports.get(f) ?? {}
  walk(tree, (n) => {
    if (n.type !== "Property" && n.type !== "ObjectProperty") return
    const key = n.key?.name ?? n.key?.value
    if (key !== "components") return
    const obj = n.value
    if (!obj || obj.type !== "ObjectExpression") return
    for (const p of obj.properties) {
      const name = p.key?.name ?? p.key?.value
      const val = p.value
      if (!name) continue
      if (val?.type === "Identifier" && local[val.name]) { registry[name] = local[val.name]; registryEntries++ }
      else if (p.type === "SpreadElement" || p.type === "RestElement") { /* ...LayoutUtils: handled below */ }
    }
  })
}
// `components: { ...LayoutUtils }` -- every export of that module is a component
for (const [f, tree] of ast) {
  const local = imports.get(f) ?? {}
  walk(tree, (n) => {
    if (n.type !== "Property" && n.type !== "ObjectProperty") return
    if ((n.key?.name ?? n.key?.value) !== "components") return
    for (const p of n.value?.properties ?? []) {
      if (p.type !== "SpreadElement") continue
      const arg = p.argument
      const target = arg?.type === "Identifier" ? local[arg.name] : null
      if (!target) continue
      for (const s of ast.get(target)?.body ?? []) {
        if (s.type === "ExportNamedDeclaration" && s.declaration) {
          const d = s.declaration
          const names = d.type === "ClassDeclaration" || d.type === "FunctionDeclaration"
            ? [d.id?.name]
            : (d.declarations ?? []).map((x) => x.id?.name)
          for (const nm of names) if (nm) { registry[nm] = target; registryEntries++ }
        }
      }
    }
  })
}

// ── local bindings: `const Operation = getComponent("Operation")` ──────
// The dominant way a swagger-ui component names its children. The tag <Operation/>
// then resolves through the registry rather than through an import.
const bindings = new Map() // file -> { localName: targetFile }
for (const [f, tree] of ast) {
  const m = {}
  walk(tree, (n) => {
    if (n.type !== "VariableDeclarator") return
    const init = n.init
    if (init?.type !== "CallExpression") return
    const callee = init.callee
    const name = callee?.type === "Identifier" ? callee.name
      : callee?.type === "MemberExpression" ? callee.property?.name : null
    // `getComponent("X")` and the hook form `useComponent("X")` name the
    // same registry.
    if (name !== "getComponent" && name !== "useComponent") return
    const arg = init.arguments?.[0]
    if (arg?.type !== "Literal" && arg?.type !== "StringLiteral") return
    const target = registry[arg.value]
    if (!target) return
    // const X = getComponent("Y")   |   const { a, b } = getComponent("Y")
    if (n.id?.type === "Identifier") m[n.id.name] = target
    else if (n.id?.type === "ObjectPattern") {
      for (const p2 of n.id.properties) {
        const nm = p2.value?.name ?? p2.key?.name
        if (nm) m[nm] = target
      }
    }
  })
  bindings.set(f, m)
}

// ── the elements each file renders ─────────────────────────────────────
const classesOf = (attr) => {
  // className="a b"  |  className={"a"}  |  className={cx("a", {...})}
  const out = { fixed: [], dynamic: false }
  const v = attr.value
  if (!v) return out
  if (v.type === "Literal" || v.type === "StringLiteral") {
    out.fixed.push(...String(v.value).split(/\s+/).filter(Boolean))
    return out
  }
  if (v.type === "JSXExpressionContainer") {
    walk(v.expression, (n) => {
      if (n.type === "Literal" || n.type === "StringLiteral") {
        if (typeof n.value === "string") out.fixed.push(...n.value.split(/\s+/).filter(Boolean))
      } else if (n.type === "Identifier" || n.type === "MemberExpression") {
        out.dynamic = true
      }
    })
  }
  return out
}

const nodes = []          // { id, file, tag, classes, dynamic, children:[ids], component }
const byFile = new Map()  // file -> root node ids
let unresolvedComponent = 0
let dynamicClassName = 0
const unresolvedTags = {}
let transparentNodes = 0

for (const [f, tree] of ast) {
  const local = { ...(imports.get(f) ?? {}), ...(bindings.get(f) ?? {}) }
  const roots = []

  const mkNode = (el, parent) => {
    const nameNode = el.openingElement?.name ?? el.name
    const tag = nameNode?.type === "JSXIdentifier" ? nameNode.name
      : nameNode?.type === "JSXMemberExpression" ? `${nameNode.object?.name}.${nameNode.property?.name}`
      : "?"
    const attrs = el.openingElement?.attributes ?? []
    let classes = [], dynamic = false
    // Where to edit: the className attribute if there is one, otherwise just
    // after the tag name so one can be inserted.
    let attr = null
    for (const a of attrs) {
      if (a.type !== "JSXAttribute") continue
      if ((a.name?.name ?? "") !== "className") continue
      const c = classesOf(a)
      classes = c.fixed
      dynamic = c.dynamic
      attr = { start: a.start, end: a.end, literal: a.value?.type === "Literal" || a.value?.type === "StringLiteral" }
    }
    const insertAt = nameNode ? nameNode.end : null
    if (dynamic) dynamicClassName++

    let component = null
    let transparent = false
    if (/^[A-Z]/.test(tag)) {
      component = local[tag.split(".")[0]] ?? null
      if (!component) {
        transparent = /\.(Provider|Consumer)$/.test(tag) ||
          /^(Ori|Original|WrappedComponent|Component)$/.test(tag)
        if (transparent) transparentNodes++
        else { unresolvedComponent++; (unresolvedTags[tag] = (unresolvedTags[tag] ?? 0) + 1) }
      }
    }
    const id = nodes.length
    nodes.push({ id, file: f, tag, classes, dynamic, children: [], parent, component, transparent, attr, insertAt })
    if (parent === null) roots.push(id)
    else nodes[parent].children.push(id)

    // recurse into this element's own children only -- nesting is the
    // ancestry every later pass reads.
    for (const child of el.children ?? []) descend(child, id)
    return id
  }

  const descend = (n, parent) => {
    if (!n || typeof n !== "object") return
    if (Array.isArray(n)) { n.forEach((x) => descend(x, parent)); return }
    if (n.type === "JSXElement") { mkNode(n, parent); return }
    if (n.type === "JSXFragment") { (n.children ?? []).forEach((c) => descend(c, parent)); return }
    for (const k of Object.keys(n)) {
      if (k === "type" || k === "start" || k === "end" || k === "parent") continue
      descend(n[k], parent)
    }
  }

  // Top-level elements of the file: anything not already inside another.
  const seen = new Set()
  walk(tree, (n) => {
    if (n.type !== "JSXElement" || seen.has(n)) return
    const mark = (el) => { seen.add(el); for (const c of el.children ?? []) if (c.type === "JSXElement") mark(c); else walk(c, (x) => { if (x.type === "JSXElement") mark(x) }) }
    mark(n)
    mkNode(n, null)
  })
  byFile.set(f, roots)
}

// ── getComponent("Name") edges ─────────────────────────────────────────
let getComponentStatic = 0, getComponentDynamic = 0
const getComponentEdges = new Map() // file -> [target files]
for (const [f, tree] of ast) {
  const targets = new Set()
  walk(tree, (n) => {
    if (n.type !== "CallExpression") return
    const callee = n.callee
    const name = callee?.type === "Identifier" ? callee.name
      : callee?.type === "MemberExpression" ? callee.property?.name : null
    if (name !== "getComponent") return
    const arg = n.arguments?.[0]
    if ((arg?.type === "Literal" || arg?.type === "StringLiteral") && typeof arg.value === "string") {
      const hit = registry[arg.value]
      if (hit) { targets.add(hit); getComponentStatic++ } else getComponentDynamic++
    } else getComponentDynamic++
  })
  if (targets.size) getComponentEdges.set(f, [...targets])
}

const out = {
  files: files.length,
  parsed: ast.size,
  nodes: nodes.length,
  registry: Object.keys(registry).length,
  edges: {
    jsxComponent: nodes.filter((n) => n.component).length,
    unresolvedComponent,
    getComponentStatic,
    getComponentDynamic,
  },
  dynamicClassName,
  classesSeen: new Set(nodes.flatMap((n) => n.classes)).size,
}
writeFileSync(path.join(OUT, "graph.json"), JSON.stringify({
  nodes, registry,
  roots: [...byFile],
  getComponentEdges: [...getComponentEdges],
}, null, 1))

console.log(`files parsed            ${out.parsed} / ${out.files}`)
console.log(`jsx elements            ${out.nodes}`)
console.log(`  nested (have a parent) ${nodes.filter((n) => n.parent !== null).length}`)
console.log(`  file roots             ${nodes.filter((n) => n.parent === null).length}`)
console.log(`distinct classNames     ${out.classesSeen}`)
console.log(`registry entries        ${out.registry}`)
console.log(`<Component/> edges      ${out.edges.jsxComponent} resolved, ${transparentNodes} transparent, ${out.edges.unresolvedComponent} unresolved`)
console.log(`getComponent("x") edges ${out.edges.getComponentStatic} resolved, ${out.edges.getComponentDynamic} dynamic`)
console.log(`dynamic classNames      ${out.dynamicClassName}`)
console.log(`\nunresolved tags, most common:`)
Object.entries(unresolvedTags).sort((a, b) => b[1] - a[1]).slice(0, 15)
  .forEach(([tag, n]) => console.log(`  ${String(n).padStart(4)}  <${tag}/>`))
