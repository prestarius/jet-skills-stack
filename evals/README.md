# Evals

Trigger-accuracy and output-shape cases for the collision-prone skill pairs, in the
`claude plugin eval` case format (one `case.yaml` per directory; graders `tool_used`, `llm`,
`file_exists`). Run by hand — they cost money:

```bash
scripts/eval.sh                  # all cases, with a no-plugin baseline arm
scripts/eval.sh 'handoff*'       # one case
```

Results land in `evals/results/latest.json` (gitignored). Add a case whenever a skill's
description changes or a new sibling skill lands.
