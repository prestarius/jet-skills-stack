#!/usr/bin/env bash
set -euo pipefail
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="${HOME}/.claude"
mkdir -p "${CLAUDE_DIR}/skills" "${CLAUDE_DIR}/commands" "${CLAUDE_DIR}/agents"

link() { # link <src> <dest>
  if [ -e "$2" ] && [ ! -L "$2" ]; then echo "skip (real file exists): $2"; return; fi
  ln -sfn "$1" "$2"; echo "linked: $2 -> $1"
}

for d in "${REPO_DIR}"/skills/*/;   do link "${d%/}" "${CLAUDE_DIR}/skills/$(basename "$d")"; done
for f in "${REPO_DIR}"/commands/*.md; do link "$f" "${CLAUDE_DIR}/commands/$(basename "$f")"; done
for f in "${REPO_DIR}"/agents/*.md;   do link "$f" "${CLAUDE_DIR}/agents/$(basename "$f")"; done

# CLAUDE.md: append between markers, idempotently
MARK_START="# >>> jet-skills >>>"; MARK_END="# <<< jet-skills <<<"
GLOBAL="${CLAUDE_DIR}/CLAUDE.md"; touch "${GLOBAL}"
if ! grep -qF "${MARK_START}" "${GLOBAL}"; then
  { echo "${MARK_START}"; cat "${REPO_DIR}/CLAUDE.md"; echo "${MARK_END}"; } >> "${GLOBAL}"
  echo "appended jet-skills guardrails to ${GLOBAL}"
else
  echo "jet-skills guardrails already present in ${GLOBAL}"
fi

echo
echo "Done. Hooks are NOT auto-installed (they edit settings.json)."
echo "To enable the command guardrails, add to ${CLAUDE_DIR}/settings.json:"
echo '  "hooks": { "PreToolUse": [ { "matcher": "Bash",'
echo "    \"hooks\": [ { \"type\": \"command\", \"command\": \"bash ${REPO_DIR}/hooks/scripts/command-guardrails.sh\" } ] } ] }"
echo
echo "Plugin/marketplace alternative:"
echo "  claude --plugin-dir ${REPO_DIR}        # one session"
echo "  /plugin marketplace add ${REPO_DIR}    # then: /plugin install jet-skills@jet-skills"
