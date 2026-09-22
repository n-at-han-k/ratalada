# scss-to-tailwind

How `frontend/` stopped having any SCSS in it, and how the rest of it will.

```bash
pnpm scss:map              # frontend/styles/swagger.css -> tmp/scss/map.json
pnpm scss:apply            # what would be inlined, and what is held back
pnpm scss:apply --write    # do it
```

`map.mjs` turns every unconditional rule into `class -> [tailwind utilities]`,
using `tailwind-generator` for the declaration arithmetic and a small `REPAIRS`
table for the three things that package gets wrong (`font-[bold]` is arbitrary
font-FAMILY, `rgb(50%, 50%, 50%)` loses its spaces to commas, and v3's
`rounded` is v4's `rounded-sm`). Everything it cannot map stays in
`tmp/scss/leftover.css`.

`apply.mjs` inlines a class only when all three hold:

1. the map has utilities for it,
2. exactly one rule in the stylesheet mentions it,
3. every use of the name is a `className="..."` literal it rewrites.

Anything else is held back. The held-back ones are not a gap in the tooling:
`.opblock.opblock-post .opblock-summary-method` is one of twenty selectors
colouring the method badge by verb, and a class name cannot carry which verb
it is. Those are `class-variance-authority` variants, moved by hand into the
component that already knows -- and `swagger.css` shrinks as they go.

## The passes

| | |
|---|---|
| `graph.mjs` | the render graph -- every JSX element, its classes, and what renders it. `getComponent("X")` and `useComponent("X")` resolve through the static registry |
| `plan.mjs` | selector resolution, dominance, cascade reduction. Decides what can be inlined, what must stay a variant, and what stays CSS |
| `apply.mjs` | writes the classNames and the reduced stylesheet. Parses every file back before writing it -- an offset that is off by one turns source into rubble |
| `verify-styles.js` | the proof: computed styles from a real render, before against after |
| `map.mjs`, `variants.mjs` | earlier, simpler attempts, kept because their numbers are the argument for the current design |

## Verifying

Nothing here is trustworthy without `verify-styles.js`. Paste it into the page
once per build, same origin both times:

```
converted tree      -> verify("after")
git checkout HEAD   -> verify("before")   # prints the diff
```

Run it twice on ONE build first. That control should report 0 differing (or 1
mid-animation `opacity`); more than that means the page had not settled and
the comparison is noise, not a finding.

`style-diff.md` is the last run: 0 of 701 elements visibly differ.

`run.sh` does the whole thing, and resets to the `swagger-fork-pristine` tag
first -- running the passes over an already-converted tree finds nothing and
reports 0%, which wasted an afternoon. `--baseline-only` stops after the
reset, which is how the "before" capture is taken.

`fork.py` is separate: it is how the vendored source was laid out in the first
place. Read its docstring before running it.
