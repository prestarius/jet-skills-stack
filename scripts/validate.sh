#!/usr/bin/env bash
# Per-change validation gate for this repo (no test suite needed).
# Run from anywhere: scripts/validate.sh   — exits non-zero if any check fails.
#
# Checks:
#   1. every skills/*/SKILL.md: frontmatter starts on line 1, has `name` + `description`,
#      name == directory, only documented frontmatter keys, description (+ when_to_use) <= 1536 chars
#   2. references/ assets/ scripts/ paths mentioned in a SKILL.md exist in that skill dir
#   3. all JSON files parse
#   4. shell scripts pass bash -n
#   5. guardrail hooks smoke tests (block / ask / allow; file guard; session-start hook)
#   6. relative Markdown links in README.md resolve; rules/ files exist
#   7. denylist grep (only if a denylist file exists — kept out of this repo on purpose)
#   8. `claude plugin validate --strict` and the always-on token budget (only if `claude` is on PATH)
set -uo pipefail
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${REPO_DIR}"
FAIL=0
MAX_DESC=1536; WARN_DESC=700; MAX_ALWAYS_ON="${JET_MAX_ALWAYS_ON_TOKENS:-6000}"
KNOWN_KEYS='name|description|when_to_use|argument-hint|arguments|disable-model-invocation|user-invocable|allowed-tools|disallowed-tools|model|effort|context|agent|background|hooks|paths|shell|metadata|license|compatibility'
err() { echo "FAIL: $*" >&2; FAIL=1; }

# 1. skill frontmatter
for f in skills/*/SKILL.md; do
  dir="$(basename "$(dirname "$f")")"
  [ "$(head -1 "$f")" = "---" ] || err "$f: frontmatter must start on line 1"
  fm="$(awk '/^---$/{c++; next} c==1' "$f")"
  name="$(echo "$fm" | sed -n 's/^name:[[:space:]]*//p' | head -1)"
  echo "$fm" | grep -q '^description:' || err "$f: missing description"
  [ -n "$name" ] || err "$f: missing name"
  [ -z "$name" ] || [ "$name" = "$dir" ] || err "$f: name '$name' != directory '$dir'"
  while read -r key; do
    echo "$key" | grep -qE "^(${KNOWN_KEYS})$" || err "$f: unknown frontmatter key '$key'"
  done < <(echo "$fm" | grep -oE '^[A-Za-z_-]+:' | tr -d ':')
  len="$(echo "$fm" | awk '
    /^(description|when_to_use):/ {d=1; sub(/^[a-z_]+:[ ]*\|?[ ]*/,""); s=s" "$0; next}
    d && /^[ ]+/ {s=s" "$0; next}
    d && /^[A-Za-z_-]+:/ {d=0}
    END{gsub(/[ ]+/," ",s); print length(s)}')"
  [ "$len" -le "$MAX_DESC" ] || err "$f: description+when_to_use is $len chars (> $MAX_DESC, truncated in the listing)"
  [ "$len" -le "$WARN_DESC" ] || echo "warn: $f: description is $len chars (> $WARN_DESC) — consider trimming"
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

# 5. guardrails smoke tests
GUARD=hooks/scripts/command-guardrails.sh
out="$(echo '{"tool_input":{"command":"git push --force"}}' | bash "$GUARD" 2>&1)"; rc=$?
{ [ $rc -eq 2 ] && echo "$out" | grep -q BLOCKED; } || err "$GUARD: force push not blocked (rc=$rc)"
out="$(echo '{"tool_input":{"command":"git reset --hard"}}' | bash "$GUARD" 2>&1)"; rc=$?
{ [ $rc -eq 0 ] && echo "$out" | grep -q '"permissionDecision": "ask"'; } || err "$GUARD: git reset --hard should ask (rc=$rc)"
out="$(echo '{"tool_input":{"command":"rm -rf node_modules"}}' | bash "$GUARD" 2>&1)"; rc=$?
{ [ $rc -eq 0 ] && [ -z "$out" ]; } || err "$GUARD: safe cleanup should pass silently (rc=$rc)"
out="$(echo '{"tool_input":{"command":"git push origin feature/x"}}' | bash "$GUARD" 2>&1)"; rc=$?
{ [ $rc -eq 0 ] && [ -z "$out" ]; } || err "$GUARD: push of an explicit feature branch should pass (rc=$rc)"
FGUARD=hooks/scripts/file-guardrails.sh
out="$(echo '{"tool_input":{"file_path":"/repo/.env"}}' | bash "$FGUARD" 2>&1)"; rc=$?
{ [ $rc -eq 0 ] && echo "$out" | grep -q '"permissionDecision": "ask"'; } || err "$FGUARD: .env should ask (rc=$rc)"
out="$(echo '{"tool_input":{"file_path":"/repo/.env.example"}}' | bash "$FGUARD" 2>&1)"; rc=$?
{ [ $rc -eq 0 ] && [ -z "$out" ]; } || err "$FGUARD: .env.example should pass (rc=$rc)"
out="$(echo '{"tool_input":{"file_path":"/repo/src/app.py"}}' | bash "$FGUARD" 2>&1)"; rc=$?
{ [ $rc -eq 0 ] && [ -z "$out" ]; } || err "$FGUARD: ordinary file should pass (rc=$rc)"
out="$(CLAUDE_PLUGIN_ROOT="$REPO_DIR" bash hooks/scripts/working-agreement.sh 2>&1)"; rc=$?
{ [ $rc -eq 0 ] && echo "$out" | grep -q 'Think before coding'; } || err "working-agreement.sh: should print the agreement (rc=$rc)"
out="$(CLAUDE_PLUGIN_ROOT="$REPO_DIR" CLAUDE_PLUGIN_OPTION_WORKING_AGREEMENT=false bash hooks/scripts/working-agreement.sh 2>&1)"; rc=$?
{ [ $rc -eq 0 ] && [ -z "$out" ]; } || err "working-agreement.sh: opt-out should print nothing (rc=$rc)"

# 6. README relative links resolve; rules present
while read -r p; do
  [ -z "$p" ] || [ -e "$p" ] || err "README.md: broken link $p"
done < <(grep -oE '\]\([^)]+\)' README.md | sed -E 's/^\]\(//; s/\)$//' | grep -vE '^(https?:|#|mailto:)' | sort -u)
[ -f rules/working-agreement.md ] || err "rules/working-agreement.md missing"
[ -f rules/personal-defaults.md ] || err "rules/personal-defaults.md missing"

# 7. denylist (file lives outside this repo; skip silently if absent)
DENYLIST="${JET_DENYLIST_FILE:-$HOME/.claude/jet-skills-denylist.txt}"
if [ -f "$DENYLIST" ]; then
  pat="$(grep -v '^\s*$\|^#' "$DENYLIST" | paste -sd'|' -)"
  if [ -n "$pat" ] && grep -riE "$pat" skills agents hooks rules CLAUDE.md README.md docs 2>/dev/null; then
    err "denylist match found above — scrub before committing"
  fi
else
  echo "note: no denylist at $DENYLIST — skipping check 7"
fi

# 8. always-on budget: descriptions of model-invocable skills (hidden ones cost nothing),
#    ~4 chars/token + ~15 tokens of listing overhead each; then plugin validate (needs the CLI)
visible=0; chars=0
for f in skills/*/SKILL.md; do
  fm="$(awk '/^---$/{c++; next} c==1' "$f")"
  echo "$fm" | grep -qiE '^disable-model-invocation:[[:space:]]*(true|yes|on|1)' && continue
  visible=$((visible+1))
  n="$(echo "$fm" | awk '
    /^(description|when_to_use):/ {d=1; sub(/^[a-z_]+:[ ]*\|?[ ]*/,""); s=s" "$0; next}
    d && /^[ ]+/ {s=s" "$0; next}
    d && /^[A-Za-z_-]+:/ {d=0}
    END{gsub(/[ ]+/," ",s); print length(s)}')"
  chars=$((chars+n))
done
est=$((chars/4 + visible*15))
echo "always-on estimate: ${visible} model-visible skills, ~${est} tokens of descriptions (budget ${MAX_ALWAYS_ON})"
[ "$est" -le "$MAX_ALWAYS_ON" ] || err "always-on estimate ${est} > ${MAX_ALWAYS_ON}; hide (disable-model-invocation) or trim descriptions"
if command -v claude >/dev/null 2>&1; then
  claude plugin validate . --strict >/tmp/jet-validate.$$ 2>&1 || { cat /tmp/jet-validate.$$; err "claude plugin validate --strict failed"; }
  grep -qi 'warning' /tmp/jet-validate.$$ && { echo "warn: plugin validate reported warnings:"; grep -A3 -i 'warning' /tmp/jet-validate.$$; }
  rm -f /tmp/jet-validate.$$
else
  echo "note: claude CLI not on PATH — skipping plugin validate"
fi

[ $FAIL -eq 0 ] && echo "OK: all checks passed"
exit $FAIL
