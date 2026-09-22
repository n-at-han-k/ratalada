# Computed-style diff: converted vs baseline

Captured from a real render (Chrome, `http://localhost:5100`, Forgejo
document) with `verify-styles.js`.

```
701 elements compared
701 identical, or differing only where it cannot render
  0 visibly differing
```

The converted build is the one measured: 63 elements carry arbitrary
variants, 47 carry plain utilities.

## Getting here

The first run of this comparison read 163 of 543 elements differing. Each was
a real fault, and each is now fixed:

| symptom | cause |
|---|---|
| every method badge black | `[&.opblock-post]:` asks whether THIS element carries the verb class. It is on the ancestor. Pushing declarations down to a descendant has to re-express the host's conditions as `[.opblock.opblock-post_&]:` |
| borders missing | `rgba(59,,65,,81,,0.3)` -- `tailwind-generator` turns a space inside a value into a second comma. The repair table existed in `map.mjs` and had never been copied into the pass that ships |
| nested `.model-box` unstyled | `let classes = ["model-box"]` builds the class in code, so the extractor cannot attribute it to an element. A class it cannot see all the carriers of must keep its rule |
| auth modal inputs collapsed | `[&_input[type=text]]:min-w-[230px]` -- a bracket inside an arbitrary variant does not parse, so the utility compiled to nothing. The check for that ran on the value, before the variant was prefixed |
| copy link flew to the top right | `.copy-to-clipboard` (0-2-0) converted while the rule that overrode it (0-3-0) could not, and utilities beat the layer the stylesheet sits in. The cascade has to be closed: a rule converts only if nothing stronger stays behind |
| server selector lost its row | `block` is a tailwind utility name. `Col` emits it, the fork's stylesheet never defined it, and layering let tailwind's `display:block` win. Renamed `sw-block` |

## What it costs

```
selectors inlined    80        demoted for cascade  250
stylesheet           84,271 -> 77,226 bytes (8%)
className length     median 4, max 25
```

8%, not 100%. The limit is not the analysis -- it is that `transition`,
`content`, `animation` and `outline` have no utility, so rules carrying them
stay in the stylesheet, and cascade closure then refuses to convert anything
weaker that they override. 250 of 330 convertible rules are demoted for that
reason alone. Teaching the generator those four properties is what raises the
ceiling; nothing else here is in the way.
