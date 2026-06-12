#!/usr/bin/env bash
# Guard destructive shell commands. Reads the PreToolUse tool-call JSON on stdin.
#
# Three tiers:
#   - catastrophic        -> exit 2 (HARD BLOCK; the command cannot run)
#   - destructive         -> emit permissionDecision "ask" (warn; user may override)
#   - safe build cleanups -> allow silently (exit 0)
#
# Conservative by design: when in doubt it asks rather than blocks, and a benign
# command slipping through is preferable to a false block.
set -euo pipefail
input="$(cat)"

GUARD_INPUT="$input" python3 <<'PY'
import os, json, re, sys

try:
    data = json.loads(os.environ.get("GUARD_INPUT", "") or "{}")
except Exception:
    sys.exit(0)

cmd = ((data.get("tool_input") or {}).get("command") or "")
if not cmd.strip():
    sys.exit(0)
U = cmd.upper()

def block(reason):
    sys.stderr.write(f"BLOCKED by command-guardrails (catastrophic): {reason}\n")
    sys.exit(2)

def ask(reason):
    print(json.dumps({"hookSpecificOutput": {
        "hookEventName": "PreToolUse",
        "permissionDecision": "ask",
        "permissionDecisionReason": reason,
    }}))
    sys.exit(0)

SAFE = (r"node_modules|dist|build|out|coverage|\.next|\.nuxt|\.turbo|\.venv|venv|"
        r"__pycache__|\.pytest_cache|\.mypy_cache|\.ruff_cache|target|bin|obj|\.gradle|\.cache")

rm_present   = bool(re.search(r'\brm\b', cmd))
rm_recursive = rm_present and (bool(re.search(r'-[a-zA-Z]*[rR]', cmd)) or '--recursive' in cmd)

# --- Tier 1: catastrophic -> hard block ---
if re.search(r'\bgit\s+push\b.*(?:--force(?!-with-lease)|\s-f(?:\s|$))', cmd):
    block("git force push (use --force-with-lease, or push without --force)")
if re.search(r'\bmkfs\b', cmd):
    block("filesystem format (mkfs)")
if re.search(r'\bdd\b.*\bof=/dev/', cmd):
    block("raw disk write (dd to a device)")
if re.search(r'>\s*/dev/(sd|nvme|disk|hd)\w', cmd):
    block("redirect to a raw disk device")
if "DROP DATABASE" in U:
    block("SQL DROP DATABASE")
if rm_recursive and (
    re.search(r'\brm\b[^\n;&|]*\s(?:/|/\*|~|~/|\$\{?HOME\}?)(?:\s|$|\*|/)', cmd)
    or re.search(r'\brm\b[^\n;&|]*\s/(?:etc|usr|var|bin|lib|lib64|boot|sys|proc|dev|sbin|opt|root)(?:/|\s|$|\*)', cmd)
):
    block("recursive delete of root, home, or a system directory")

# --- Safe build-artifact cleanups -> allow silently ---
if rm_recursive:
    # tokens that look like paths (drop the 'rm', flags, and shell operators)
    toks = [t for t in re.split(r'\s+', cmd.strip())
            if t and t != 'rm' and not t.startswith('-') and t not in ('&&', '||', ';', '|')]
    if toks and all(re.fullmatch(rf'(?:\./)?(?:{SAFE})/?', t) for t in toks):
        sys.exit(0)

# --- Tier 2: destructive -> ask (warn, allow override) ---
if rm_recursive:
    ask("recursive delete (rm -r); double-check the path before proceeding")
if re.search(r'\bgit\s+reset\s+--hard\b', cmd):
    ask("git reset --hard discards staged and uncommitted work (commits stay reachable via reflog)")
if re.search(r'\bgit\s+stash\s+(?:drop|clear)\b', cmd):
    ask("git stash drop/clear permanently discards stashed changes")
if re.search(r'\bfind\b[^\n;&|]*\s-delete\b', cmd):
    ask("find -delete removes every matched file; double-check the predicate")
if re.search(r'\bgit\s+clean\b.*-[a-zA-Z]*f', cmd) and re.search(r'\bgit\s+clean\b.*-[a-zA-Z]*d', cmd):
    ask("git clean will permanently delete untracked files")
if re.search(r'\bgit\s+(?:checkout|restore)\s+(?:--\s+)?\.(?:\s|$)', cmd):
    ask("this discards all uncommitted working-tree changes")
if re.search(r'\bgit\s+branch\s+-D\b', cmd):
    ask("force-delete branch may drop unmerged commits")
if re.search(r'\bdocker\s+(?:system\s+prune|image\s+prune|volume\s+rm|rm\s+-f)\b', cmd):
    ask("destructive docker cleanup")
if re.search(r'\bkubectl\s+delete\b', cmd):
    ask("kubectl delete removes live cluster resources")
if "DROP TABLE" in U:
    ask("SQL DROP TABLE")
if re.search(r'\bTRUNCATE\s+(?:TABLE\s+)?\w', U):
    ask("SQL TRUNCATE empties a table")

sys.exit(0)
PY
