#!/usr/bin/env bash
# Install jet-skills into ~/.claude via symlinks (idempotent).
#
#   ./install.sh              skills + agents + working-agreement rule
#   ./install.sh --personal   also link rules/personal-defaults.md (Jet's locale/output defaults)
#   ./install.sh --hooks      also merge the guardrail hooks into ~/.claude/settings.json
set -euo pipefail
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="${HOME}/.claude"
PERSONAL=0; HOOKS=0
for a in "$@"; do
  case "$a" in
    --personal) PERSONAL=1 ;;
    --hooks) HOOKS=1 ;;
    *) echo "unknown option: $a" >&2; exit 1 ;;
  esac
done
mkdir -p "${CLAUDE_DIR}/skills" "${CLAUDE_DIR}/agents" "${CLAUDE_DIR}/rules"

link() { # link <src> <dest>
  if [ -e "$2" ] && [ ! -L "$2" ]; then echo "skip (real file exists): $2"; return; fi
  ln -sfn "$1" "$2"; echo "linked: $2 -> $1"
}

for d in "${REPO_DIR}"/skills/*/; do link "${d%/}" "${CLAUDE_DIR}/skills/$(basename "$d")"; done
for f in "${REPO_DIR}"/agents/*.md; do link "$f" "${CLAUDE_DIR}/agents/$(basename "$f")"; done
link "${REPO_DIR}/rules/working-agreement.md" "${CLAUDE_DIR}/rules/jet-working-agreement.md"
if [ "$PERSONAL" = 1 ]; then
  link "${REPO_DIR}/rules/personal-defaults.md" "${CLAUDE_DIR}/rules/jet-personal-defaults.md"
fi

# prune symlinks that point into this repo but whose target no longer exists (renamed/removed components)
for dir in skills commands agents rules; do
  for l in "${CLAUDE_DIR}/${dir}"/*; do
    [ -L "$l" ] || continue
    target="$(readlink "$l")"
    case "$target" in
      "${REPO_DIR}"/*) [ -e "$target" ] || { rm "$l"; echo "pruned stale link: $l"; } ;;
    esac
  done
done

# one-time migration: the working agreement used to be appended to ~/.claude/CLAUDE.md between markers
GLOBAL="${CLAUDE_DIR}/CLAUDE.md"
if [ -f "$GLOBAL" ] && grep -qF "# >>> jet-skills >>>" "$GLOBAL"; then
  cp "$GLOBAL" "${GLOBAL}.bak"
  awk '/^# >>> jet-skills >>>$/{skip=1; next} /^# <<< jet-skills <<<$/{skip=0; next} !skip' "${GLOBAL}.bak" > "$GLOBAL"
  echo "removed the old jet-skills block from ${GLOBAL} (backup: ${GLOBAL}.bak); it now loads from ~/.claude/rules/"
fi

# hooks: merge into settings.json only on request (it edits a file you own)
SETTINGS="${CLAUDE_DIR}/settings.json"
if [ "$HOOKS" = 1 ]; then
  [ -f "$SETTINGS" ] || echo '{}' > "$SETTINGS"
  cp "$SETTINGS" "${SETTINGS}.bak"
  REPO_DIR="$REPO_DIR" SETTINGS="$SETTINGS" python3 - <<'PY'
import json, os
repo, path = os.environ["REPO_DIR"], os.environ["SETTINGS"]
s = json.load(open(path))
hooks = s.setdefault("hooks", {})
wanted = {
    "PreToolUse": [
        ("Bash",            f"bash {repo}/hooks/scripts/command-guardrails.sh"),
        ("Read|Write|Edit", f"bash {repo}/hooks/scripts/file-guardrails.sh"),
    ],
}
added = 0
for event, entries in wanted.items():
    lst = hooks.setdefault(event, [])
    present = {h.get("command") for e in lst for h in e.get("hooks", [])}
    for matcher, cmd in entries:
        if cmd in present:
            continue
        lst.append({"matcher": matcher, "hooks": [{"type": "command", "command": cmd, "timeout": 10}]})
        added += 1
json.dump(s, open(path, "w"), indent=2); open(path, "a").write("\n")
print(f"hooks: {added} added to {path} (backup: {path}.bak)")
PY
else
  if grep -qF "command-guardrails.sh" "$SETTINGS" 2>/dev/null; then
    echo "hooks: already present in ${SETTINGS}"
  else
    echo "hooks: NOT installed. Re-run with --hooks to merge the guardrails into ${SETTINGS}."
  fi
fi

echo
echo "Done. Plugin/marketplace alternative (skills + agents + hooks, no rules symlink needed):"
echo "  claude --plugin-dir ${REPO_DIR}        # one session"
echo "  /plugin marketplace add ${REPO_DIR}    # then: /plugin install jet-skills@jet-skills"
echo "Tip: run /skill-doctor after a couple of weeks to see which skills never fire and what they cost."
