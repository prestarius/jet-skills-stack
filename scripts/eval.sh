#!/usr/bin/env bash
# Run the trigger/output evals against this plugin. Costs money; run by hand, not in CI.
#   scripts/eval.sh                 all cases, USD 2 ceiling
#   scripts/eval.sh 'handoff*'      one case glob
set -euo pipefail
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
mkdir -p "${REPO_DIR}/evals/results"
exec claude plugin eval "${REPO_DIR}" \
  --ablation with-without \
  --max-cost-usd "${JET_EVAL_MAX_USD:-2}" \
  ${1:+--case "$1"} \
  --json "${REPO_DIR}/evals/results/latest.json"
