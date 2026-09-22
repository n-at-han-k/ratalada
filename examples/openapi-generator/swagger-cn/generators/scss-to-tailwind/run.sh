#!/usr/bin/env bash
# The whole conversion, from the committed fork every time.
#
#   generators/scss-to-tailwind/run.sh
#
# Running the passes against an already-converted tree finds nothing and
# reports 0% -- so the reset is part of the run, not a thing to remember.
# Files that are ours rather than the fork's survive it.
set -euo pipefail
cd "$(dirname "$0")/../.."

# The fork as vendored, BEFORE any conversion. Not HEAD: once a converted
# tree is committed, HEAD is the conversion and resetting to it is a no-op --
# the passes then find nothing and report 0%, which is what happened.
BASELINE="${BASELINE:-swagger-fork-pristine}"

KEEP=(styles/application.css entrypoints/swagger.tsx lib/utils.ts lib/node-globals.ts
      hooks/use-mobile.ts types.d.ts)

tmp=$(mktemp -d)
for f in "${KEEP[@]}"; do
  [ -f "frontend/$f" ] || continue
  mkdir -p "$tmp/$(dirname "$f")"
  cp "frontend/$f" "$tmp/$f"
done

git -C "$(git rev-parse --show-toplevel)" checkout "$BASELINE" -- "$(git rev-parse --show-prefix)frontend"
echo "baseline $BASELINE: frontend/styles/swagger.css is $(wc -c < frontend/styles/swagger.css) bytes"

for f in "${KEEP[@]}"; do
  [ -f "$tmp/$f" ] || continue
  mkdir -p "frontend/$(dirname "$f")"
  cp "$tmp/$f" "frontend/$f"
done
rm -rf "$tmp"
mkdir -p tmp/scss frontend/components/ui

# Fork fixes that must survive the reset, because they are corrections to the
# vendored source rather than products of the conversion.
#
# `block` is a tailwind utility name. The Col component emits it, nothing in
# the fork's stylesheet defines it, and once that stylesheet moved into a
# layer below utilities tailwind's `display:block` began overriding real
# layout rules. Renaming it is the fix; it styles nothing either way.
sed -i 's/classesAr.push("block" + deviceClass)/classesAr.push("sw-block" + deviceClass)/' \
  frontend/components/swagger/layout-utils.jsx

if [ "${1:-}" = "--baseline-only" ]; then
  echo "baseline restored, no conversion applied"
  exit 0
fi

echo "── graph ────────────────────────────────────────────"
node generators/scss-to-tailwind/graph.mjs frontend tmp/scss | head -8
echo "── plan ─────────────────────────────────────────────"
node generators/scss-to-tailwind/plan.mjs frontend/styles/swagger.css tmp/scss 2>/dev/null
echo "── apply ────────────────────────────────────────────"
node generators/scss-to-tailwind/apply.mjs frontend tmp/scss "${1:-}"
