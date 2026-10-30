---
name: plan-to-issues
description: Split a repo's plan file into GitHub issues with gh, one per unit of work, in dependency order, after the human has approved the split as a table and said what every issue must carry. Use when a plan is written and has no issues yet, when the user says "turn the plan into issues", "split this into tickets", or before coordinator-workers can hand issues to workers. Not for issues from data or reports (that is a per-repo list, not a plan).
license: MIT
metadata:
  source: MEGA-DOT-DEV/rig-handover template, .agents/skills/plan-to-issues (MIT), generalized 2026-10-30
---

# plan-to-issues

Turns a plan file (`plan.md`, `docs/plans/<name>.md`, whatever the repo uses) into GitHub issues that a
worker can pick up cold. Easiest with `gh`, authenticated, in a shell this agent can run. Running the
issues afterwards is `coordinator-workers`.

## Steps

1. Read the plan, `AGENTS.md`/`CLAUDE.md` and `docs/adr/` (or wherever the repo keeps its rules).
2. Draft the split as a table: title · plan section · scope · done when · blocked by.
   One issue per unit of work. Put the shared contract (types, schema, signature) in its own first
   issue when more than one issue depends on it.
3. **Stop and show the table to the human.** Publish nothing until they approve it.
4. Ask the human what every issue must carry (fields, labels, wording), unless it is already written
   down in this session or in the repo. Offer this default and use it on "default":
   first line `Source: <plan file> § <n>`, then `## Scope`, `## Done when`, `## Blocked by`
   (real issue numbers, or `none`), and the label `plan:<plan name>`. A reviewer sorts by the first
   line and the label. Once the human decides, write the shape into the repo (its skill or
   AGENTS.md) so the next session does not ask again.
5. Create each issue in dependency order, so blocked-by can cite real numbers. Write the body to a
   file first; long quoted one-liners break in zsh.

   ```sh
   gh issue create --title "<title>" --body-file <tmp.md> --label "plan:<name>"
   ```

6. Record every issue URL from gh's output (not from memory) and reply with the list.

Closing one, with the repo's closing comment shape (AGENTS.md often prescribes it):

```sh
gh issue close <n> -c "<closing comment>"
```

An issue whose "done when" is someone else's act (a review, a reply, a scheduled run) stays open
until that act lands, with a comment saying what it waits on. A clean-up issue is blocked by it.

## No `gh`

Steps 1–4 hold either way. GitHub reachable another way (a connector, the REST API, the web UI):
the same issues, made that way. GitHub out of reach altogether: write them as files in `docs/issues/`
in the repo's format, then commit and push.

## Don'ts

- Don't paste the whole plan into one issue, and don't keep issues only in chat.
- Don't invent sections the plan doesn't have. If the plan is unclear, ask.
- Don't create a repo or issues before the human's yes; say who will see them.
