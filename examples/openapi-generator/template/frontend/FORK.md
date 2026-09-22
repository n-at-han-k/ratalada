# swagger-ui, forked

Not a vendored dependency: this is the source, ours to change. Taken from
[swagger-api/swagger-ui](https://github.com/swagger-api/swagger-ui) at
`c7aafd279b9662fe0956cb65418d36f5c1f5e61f` (Apache-2.0 — `LICENSE` and `NOTICE` beside this file are
upstream's and stay).

`src/` was moved, not rewritten. Every import is an `@/` alias, so nothing
depends on where a file sits any more:

| upstream | here |
|---|---|
| `src/core/components/**` | `components/swagger/**` |
| `src/core/containers/**` | `components/swagger/containers/**` |
| `src/core/plugins/<p>/components/**` | `components/swagger/<p>/**` |
| `src/core/plugins/**` | `lib/swagger/plugins/**` |
| `src/core/**` | `lib/swagger/**` |
| `src/standalone/**` | `lib/swagger/standalone/**` |
| `src/style/**` | `styles/swagger/**` |
| `src/index.js` | `lib/swagger/swagger-ui.js` |

Filenames under `components/swagger/` are kebab-case; everything else keeps
upstream's spelling. 462 files, 738 imports respelled, no relative import left.

`.svg` imports are React components, as upstream's `@svgr/webpack` made them
(`vite-plugin-svgr` here, `../vite.config.ts`).

## No SCSS

Upstream's 40 stylesheets are gone. `styles/swagger.css` is what sass made of
them, minus tachyons -- 2,056 utility classes carried for four usages, which
are now `mx-auto`, `italic` and `no-underline` -- and minus the rules whose
classes became tailwind utilities in the JSX.

`../generators/scss-to-tailwind/` is how, and it still runs against
`swagger.css` as that file shrinks: `pnpm scss:map` writes the class ->
utilities map, `pnpm scss:apply --write` inlines the ones that are safe to
inline. A class is safe only when one rule mentions it, that rule is
unconditional, and every use of the name is a `className="..."` literal.
What is left is conditional on an ancestor -- `.opblock.opblock-post
.opblock-summary-method` colours the method badge by verb, 20 selectors for
one class name -- and a className cannot carry that. Those are variants:
`class-variance-authority` is already a dependency, and the component that
renders the badge already knows the verb.

## The seam worth knowing

`lib/swagger/presets/base/plugins/form-components/index.js` is six lines: it
maps every form primitive the whole UI renders through
(`components/swagger/layout-utils.jsx` — Input, Select, TextArea, Button, Col,
Row, Link, Collapse, Container, 265 lines). Point it at shadcn/ReUI components
and the UI re-skins without touching the other 27,000 lines.
