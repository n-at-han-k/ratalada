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

Two things upstream's webpack did that vite is told to do instead
(`../vite.config.ts`): `.svg` imports are React components (`@svgr/webpack`
there, `vite-plugin-svgr` here), and `main.scss` loads tachyons from
`node_modules` (`~tachyons-sass` there, a sass `loadPath` here).

## The seam worth knowing

`lib/swagger/presets/base/plugins/form-components/index.js` is six lines: it
maps every form primitive the whole UI renders through
(`components/swagger/layout-utils.jsx` — Input, Select, TextArea, Button, Col,
Row, Link, Collapse, Container, 265 lines). Point it at shadcn/ReUI components
and the UI re-skins without touching the other 27,000 lines.
