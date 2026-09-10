# Evals

Trigger-accuracy and output-shape cases for the collision-prone skill pairs, in the
`claude plugin eval` layout: one directory per case with `prompt.md` (frontmatter: name, tags,
plugins, runs, max_turns, timeout_seconds) and `graders/*.md` (frontmatter `type:` — `tool_used`
with `tool: Skill` + `input_match` for "did the right skill fire", `llm` with the rubric in the
body, `file_exists`, `regex`).

`claude plugin eval` is in early access; on a first-party account it switches on by itself
after `claude update` and a fresh session. Until then the runner prints only
"`plugin eval` is currently in early access". Run by hand — it costs money:

```bash
scripts/eval.sh                  # all cases, with a no-plugin baseline arm
scripts/eval.sh 'handoff*'       # one case
```

Results land in `evals/results/` (gitignored). Add a case whenever a skill's description
changes or a new sibling skill lands.
