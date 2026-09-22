# Computed-style diff: converted vs original

Captured from a real render (Chrome, `http://localhost:5100`, Forgejo document),
`generators/scss-to-tailwind/verify-styles.js`.

```
543 elements compared   380 identical (70%)   163 differing (30%)
```

Control run first (same build captured twice): 562 vs 562, 0 elements
added or removed, 1 differing -- a mid-animation `opacity`. The method is
sound; the 163 below are the conversion's.

## Differing elements, grouped

```
 28  model-box               display,width,height,padding-*,border-radius-*,background-color
 15  opblock-summary-method  background-color
 14  models-virtual-item     height
 14  model-container         height,margin-bottom
 14  models-jump-to-path     bottom
 14  model-box-control       display,width,border-radius-*
 14  model model-title       border-*-color,color,font-weight
 14  model-toggle collapsed  transform
 12  opblock opblock-get     box-shadow
  3  <div>                   height,padding-bottom
  3  opblock opblock-post    box-shadow
  2  wrapper                 height
  2  block col-12            height
  1  swagger-ui              height
  1  scheme-container        height,box-shadow
  1  schemes wrapper         height
  1  schemes-server-container width,height
```

## What it means

`opblock-summary-method` losing `background-color` is the HTTP verb colour:
every method badge renders the same. `.opblock.opblock-get
.opblock-summary-method` is a condition on a COMPOUND class, and the hoisted
variant was attached to a host element that does not carry `opblock-get` as a
literal -- it is applied at runtime, so the variant never matches.

`model-box` losing display/width/padding is the same shape of fault, and most
of the `height`/`width` rows are its descendants reflowing rather than
independent breakage.

So this is a handful of systematic faults around compound and runtime-applied
classes, not scattered damage. The conversion is NOT applied to the tree; it
is kept out until this report reads zero.
