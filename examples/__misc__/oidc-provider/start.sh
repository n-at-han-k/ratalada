#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"
export SESSION_SECRET="${SESSION_SECRET:-$(openssl rand -hex 32)}"

# Each side has its own flake, so enter it from inside its own directory.
trap 'kill 0' EXIT
(cd api && nix develop --command bundle exec ruby app.rb) &
(cd app && nix develop --command bin/dev) &
wait -n
