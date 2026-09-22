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

`fork.py` is separate: it is how the vendored source was laid out in the first
place. Read its docstring before running it.
