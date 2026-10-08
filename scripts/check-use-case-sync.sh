#!/usr/bin/env bash
# Check that bundled copies of the use case format specs match the
# product-management originals. For use-case-builder, only the spec section above
# the worked examples is compared, since it uses its own examples. The copy inside
# use-case-test-cases must match exactly.
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

# Exact copies (same worked examples too)
if ! diff -u "$pm/use-case-uml/references/format.md" "$pm/use-case-test-cases/references/use-case-format.md"; then
  echo "Out of sync: $pm/use-case-test-cases/references/use-case-format.md (copy it from $pm/use-case-uml/references/format.md)" >&2
  status=1
fi

[ "$status" -eq 0 ] && echo "Use case format specs are in sync."
exit "$status"
