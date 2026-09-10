#!/usr/bin/env bash
# SessionStart hook: print the working agreement so plugin installs get the guardrails
# (a CLAUDE.md at the plugin root is not loaded by Claude Code). Stdout on SessionStart
# becomes context. Opt out with the plugin's `working_agreement` setting.
#
# Self-test:
#   CLAUDE_PLUGIN_ROOT=. bash hooks/scripts/working-agreement.sh | head -3
set -euo pipefail
opt="${CLAUDE_PLUGIN_OPTION_WORKING_AGREEMENT:-true}"
case "$(printf '%s' "$opt" | tr '[:upper:]' '[:lower:]')" in
  false|0|no|off) exit 0 ;;
esac
root="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
file="${root}/rules/working-agreement.md"
[ -f "$file" ] || exit 0
echo "# jet-skills working agreement (loaded by the plugin's SessionStart hook)"
cat "$file"
