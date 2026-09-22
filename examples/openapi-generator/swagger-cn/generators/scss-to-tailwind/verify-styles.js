// Ground truth for the conversion: what the browser actually computes.
//
// Paste into the page (devtools console, or the browser-automation js tool)
// once per build. It keeps state in localStorage, so both captures must come
// from the SAME ORIGIN -- run them against one dev server, swapping the
// source between them:
//
//   1. converted tree checked out   -> verify(  "after" )
//   2. git checkout HEAD -- frontend-> verify(  "before" )   prints the diff
//
// Why computed style and not a comparison of declarations: a declaration
// comparison cannot see specificity or cascade order. If `.opblock .btn` used
// to beat `.btn` and the utilities now resolve the other way round, only the
// computed value shows it.
//
// Elements are keyed by structural path from <body> ("3/0/2/1"). That holds
// because the conversion only edits className -- it never adds or removes an
// element. If the counts differ between runs the page had not settled; the
// settle loop below waits for the count to stop moving, then lets animations
// finish. A control run (same build twice) should report 0 differing, or 1
// mid-animation opacity -- anything more means the method, not the
// conversion, is at fault.
(() => {
  const PROPS = ["display","position","top","right","bottom","left","float","clear","z-index",
  "width","height","min-width","max-width","min-height","max-height","box-sizing",
  "margin-top","margin-right","margin-bottom","margin-left",
  "padding-top","padding-right","padding-bottom","padding-left",
  "border-top-width","border-right-width","border-bottom-width","border-left-width",
  "border-top-style","border-right-style","border-bottom-style","border-left-style",
  "border-top-color","border-right-color","border-bottom-color","border-left-color",
  "border-top-left-radius","border-top-right-radius","border-bottom-left-radius","border-bottom-right-radius",
  "color","background-color","background-image","background-position","background-size","background-repeat",
  "font-family","font-size","font-weight","font-style","line-height","letter-spacing","text-align",
  "text-decoration-line","text-transform","text-overflow","white-space","word-break","vertical-align",
  "opacity","visibility","overflow-x","overflow-y","cursor","box-shadow","outline-width","outline-style",
  "flex-direction","flex-wrap","flex-grow","flex-shrink","flex-basis","justify-content","align-items",
  "align-self","align-content","gap","order","grid-template-columns","grid-template-rows",
  "list-style-type","table-layout","border-collapse","transform","transition-property"]

  const pathOf = (el) => {
    const parts = []
    let n = el
    while (n && n !== document.body) { parts.unshift([...(n.parentNode?.children ?? [])].indexOf(n)); n = n.parentNode }
    return parts.join("/")
  }

  const capture = () => {
    const out = {}
    for (const el of document.querySelectorAll("body *")) {
      const cs = getComputedStyle(el)
      const rec = { t: el.tagName.toLowerCase(), c: el.className?.baseVal ?? String(el.className ?? "") }
      for (const p of PROPS) rec[p] = cs.getPropertyValue(p)
      out[pathOf(el)] = rec
    }
    return out
  }

  const settle = async () => {
    let last = -1, stable = 0
    for (let i = 0; i < 40; i++) {
      const n = document.querySelectorAll("body *").length
      if (n === last) { if (++stable >= 3) break } else { stable = 0; last = n }
      await new Promise((r) => setTimeout(r, 300))
    }
    await new Promise((r) => setTimeout(r, 1500))
    return last
  }

  window.verify = async (which) => {
    const settledAt = await settle()
    const now = capture()
    if (which === "after") {
      localStorage.setItem("styles-after", JSON.stringify(now))
      return { stored: "after", settledAt, elements: Object.keys(now).length }
    }

    const after = JSON.parse(localStorage.getItem("styles-after") ?? "null")
    if (!after) return { error: "capture the converted build first: verify('after')" }

    const before = now
    const common = Object.keys(before).filter((k) => k in after)
    const byProp = {}, perElement = []
    for (const k of common) {
      const d = PROPS.filter((p) => before[k][p] !== after[k][p])
      if (!d.length) continue
      for (const p of d) byProp[p] = (byProp[p] ?? 0) + 1
      perElement.push({ path: k, tag: before[k].t, cls: before[k].c.slice(0, 60),
                        d: d.map((p) => `${p}: ${before[k][p]} -> ${after[k][p]}`) })
    }
    const byClass = {}
    for (const e of perElement) {
      const key = (e.cls || `<${e.tag}>`).split(" ").slice(0, 2).join(" ") || `<${e.tag}>`
      byClass[key] = byClass[key] ?? { elements: 0, props: {} }
      byClass[key].elements++
      for (const d of e.d) { const p = d.split(":")[0]; byClass[key].props[p] = (byClass[key].props[p] ?? 0) + 1 }
    }
    const report = {
      capturedAt: new Date().toISOString(),
      settledAt,
      counts: { before: Object.keys(before).length, after: Object.keys(after).length, common: common.length },
      identical: common.length - perElement.length,
      differing: perElement.length,
      byProperty: Object.entries(byProp).sort((a, b) => b[1] - a[1]),
      byClass: Object.entries(byClass).sort((a, b) => b[1].elements - a[1].elements)
        .map(([cls, v]) => ({ cls, elements: v.elements, properties: Object.keys(v.props) })),
      elements: perElement,
    }
    localStorage.setItem("styles-diff", JSON.stringify(report))
    return report
  }

  return "verify('after') on the converted build, then verify('before') on the original"
})()
