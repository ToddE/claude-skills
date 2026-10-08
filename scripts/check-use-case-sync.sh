#!/usr/bin/env bash
# Check that the standalone use-case-builder skill's format specs match the
# product-management originals. Only the spec section above the worked examples
# is compared, since the standalone skill uses its own examples.
set -euo pipefail

cd "$(dirname "$0")/.."

pm=product-management/skills
uc=use-cases/skills/use-case-builder/references
status=0

spec() { sed '/^## Worked Example/,$d' "$1"; }

check() {
  local source="$1" copy="$2"
  if ! diff -u <(spec "$source") <(spec "$copy") --label "$source" --label "$copy"; then
    echo "Out of sync: $copy (update it to match $source)" >&2
    status=1
  fi
}

check "$pm/use-case-uml/references/format.md" "$uc/use-case-format.md"
check "$pm/use-case-discovery/references/format.md" "$uc/candidate-list.md"

[ "$status" -eq 0 ] && echo "Use case format specs are in sync."
exit "$status"
