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

KEEP=(styles/application.css entrypoints/swagger.tsx lib/utils.ts lib/node-globals.ts
      hooks/use-mobile.ts types.d.ts)

tmp=$(mktemp -d)
for f in "${KEEP[@]}"; do
  [ -f "frontend/$f" ] || continue
  mkdir -p "$tmp/$(dirname "$f")"
  cp "frontend/$f" "$tmp/$f"
done

git -C "$(git rev-parse --show-toplevel)" checkout HEAD -- "$(git rev-parse --show-prefix)frontend"

for f in "${KEEP[@]}"; do
  [ -f "$tmp/$f" ] || continue
  mkdir -p "frontend/$(dirname "$f")"
  cp "$tmp/$f" "frontend/$f"
done
rm -rf "$tmp"
mkdir -p tmp/scss frontend/components/ui

echo "── graph ────────────────────────────────────────────"
node generators/scss-to-tailwind/graph.mjs frontend tmp/scss | head -8
echo "── plan ─────────────────────────────────────────────"
node generators/scss-to-tailwind/plan.mjs frontend/styles/swagger.css tmp/scss 2>/dev/null
echo "── apply ────────────────────────────────────────────"
node generators/scss-to-tailwind/apply.mjs frontend tmp/scss "${1:-}"
