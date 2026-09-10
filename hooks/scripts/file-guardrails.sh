#!/usr/bin/env bash
# Guard reads/writes of secret material. Reads the PreToolUse tool-call JSON on stdin
# (matcher: Read|Write|Edit) and asks for confirmation on files that usually hold secrets.
#
# Self-test:
#   echo '{"tool_input":{"file_path":"/repo/.env"}}' | bash hooks/scripts/file-guardrails.sh
#   -> permissionDecision "ask" on stdout, exit 0
#
# Ask, never block: a legitimate edit of .env.example or a rotated key must stay possible.
# A permissions.deny rule is the hard guarantee if you need one:
#   "permissions": { "deny": ["Read(./.env)", "Read(./.env.*)", "Read(**/*.pem)"] }
set -euo pipefail
input="$(cat)"

GUARD_INPUT="$input" python3 <<'PY'
import os, json, re, sys

try:
    data = json.loads(os.environ.get("GUARD_INPUT", "") or "{}")
except Exception:
    sys.exit(0)

path = ((data.get("tool_input") or {}).get("file_path") or "")
if not path.strip():
    sys.exit(0)
name = os.path.basename(path)

SECRET = [
    (r'^\.env(\..+)?$',               "dotenv file"),
    (r'\.(pem|key|p12|pfx|jks)$',      "private key / keystore"),
    (r'^id_(rsa|ed25519|ecdsa|dsa)$',  "SSH private key"),
    (r'^\.credentials\.json$',         "credentials file"),
    (r'^secrets\.(toml|ya?ml|json)$',  "secrets file"),
    (r'^\.netrc$|^\.npmrc$|^\.pypirc$', "auth rc file"),
]
if re.search(r'^\.env\.(example|sample|template)$', name):
    sys.exit(0)

for pat, why in SECRET:
    if re.search(pat, name):
        print(json.dumps({"hookSpecificOutput": {
            "hookEventName": "PreToolUse",
            "permissionDecision": "ask",
            "permissionDecisionReason": f"{why} ({name}); confirm before reading or writing secret material",
        }}))
        sys.exit(0)

sys.exit(0)
PY
