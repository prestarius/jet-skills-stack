#!/usr/bin/env bash
# Per-change validation gate for this repo (no test suite needed).
# Run from anywhere: scripts/validate.sh   — exits non-zero on the first hard failure class.
#
# Checks:
#   1. every skills/*/SKILL.md has frontmatter `name` + `description`, and name == directory name
#   2. references/ assets/ scripts/ paths mentioned in a SKILL.md exist in that skill dir
#   3. all JSON files parse
#   4. shell scripts pass bash -n
#   5. command-guardrails smoke test (block / ask / allow)
#   6. relative Markdown links in README.md resolve
#   7. denylist grep (only if a denylist file exists — kept out of this repo on purpose)
set -uo pipefail
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${REPO_DIR}"
FAIL=0
err() { echo "FAIL: $*" >&2; FAIL=1; }

# 1. skill frontmatter
for f in skills/*/SKILL.md; do
  dir="$(basename "$(dirname "$f")")"
  fm="$(awk '/^---$/{c++; next} c==1' "$f")"
  name="$(echo "$fm" | sed -n 's/^name:[[:space:]]*//p' | head -1)"
  echo "$fm" | grep -q '^description:' || err "$f: missing description"
  [ -n "$name" ] || err "$f: missing name"
  [ -z "$name" ] || [ "$name" = "$dir" ] || err "$f: name '$name' != directory '$dir'"
done

# 2. bundled files referenced from SKILL.md exist
for f in skills/*/SKILL.md; do
  d="$(dirname "$f")"
  while read -r p; do
    [ -z "$p" ] || [ -e "$d/$p" ] || err "$f: referenced $p does not exist"
  done < <(grep -oE '(references|assets|scripts)/[A-Za-z0-9._/-]+' "$f" | sort -u)
done

# 3. JSON parses
while read -r j; do
  python3 -m json.tool "$j" >/dev/null 2>&1 || err "$j: invalid JSON"
done < <(find . -name '*.json' -not -path './.git/*')

# 4. shell syntax
while read -r s; do
  bash -n "$s" || err "$s: bash -n failed"
done < <(find . -name '*.sh' -not -path './.git/*')

# 5. guardrails smoke test
GUARD=hooks/scripts/command-guardrails.sh
out="$(echo '{"tool_input":{"command":"git push --force"}}' | bash "$GUARD" 2>&1)"; rc=$?
{ [ $rc -eq 2 ] && echo "$out" | grep -q BLOCKED; } || err "$GUARD: force push not blocked (rc=$rc)"
out="$(echo '{"tool_input":{"command":"git reset --hard"}}' | bash "$GUARD" 2>&1)"; rc=$?
{ [ $rc -eq 0 ] && echo "$out" | grep -q '"permissionDecision": "ask"'; } || err "$GUARD: git reset --hard should ask (rc=$rc)"
out="$(echo '{"tool_input":{"command":"rm -rf node_modules"}}' | bash "$GUARD" 2>&1)"; rc=$?
{ [ $rc -eq 0 ] && [ -z "$out" ]; } || err "$GUARD: safe cleanup should pass silently (rc=$rc)"

# 6. README relative links resolve
while read -r p; do
  [ -z "$p" ] || [ -e "$p" ] || err "README.md: broken link $p"
done < <(grep -oE '\]\([^)]+\)' README.md | sed -E 's/^\]\(//; s/\)$//' | grep -vE '^(https?:|#|mailto:)' | sort -u)

# 7. denylist (file lives outside this repo; skip silently if absent)
DENYLIST="${JET_DENYLIST_FILE:-$HOME/.claude/jet-skills-denylist.txt}"
if [ -f "$DENYLIST" ]; then
  pat="$(grep -v '^\s*$\|^#' "$DENYLIST" | paste -sd'|' -)"
  if [ -n "$pat" ] && grep -riE "$pat" skills commands agents hooks CLAUDE.md README.md templates docs 2>/dev/null; then
    err "denylist match found above — scrub before committing"
  fi
else
  echo "note: no denylist at $DENYLIST — skipping check 7"
fi

[ $FAIL -eq 0 ] && echo "OK: all checks passed"
exit $FAIL
