---
name: coordinator-workers
description: Run a plan's issues with one subagent worker per issue, each in its own git worktree and branch, while this session stays the coordinator that briefs, reviews every diff, merges, closes issues and waits on outside events. Use when a repo has issues split from a plan (plan-to-issues) and more than one can run at once, or when the user says "let your agents build it", "fan out the issues", "one worker per issue".
metadata:
  source: pattern run on 2026-10-30 (MEGA.dev S01E04); Agent tool + git worktrees + gh, no extra harness
---

# coordinator-workers

A Coordinator and Workers that never talk to each other. Workers get a brief, a worktree and a branch;
they push and report; the Coordinator reads the diff, merges and closes. The Agent tool, git worktrees
and `gh` are enough.

## 1. Before any worker starts

1. Read the repo's AGENTS.md/CLAUDE.md, style guide and ADRs; they are the rules every brief repeats.
2. Land the shared contract first, on main, in one commit: the types file, the signature, the schema.
   Workers start against that commit, never against a promise.
3. From the issue list, mark which issues block which. Only unblocked issues go out together.
4. Pick the model per issue the way the repo says: the strongest for logic, a cheaper one for views
   and tests.

## 2. The brief (one per worker, Agent tool, model chosen above)

Every brief holds, in this order:
- the repo path, the issue number, and "do only that issue";
- the worktree command, verbatim:
  `git -C <repo> fetch -q && git -C <repo> worktree add ../<repo>-wt-<n> -b issue-<n> origin/main`,
  then "work only inside that folder", then the install command;
- the files to read (rules, the contract, the files it will touch, `gh issue view <n>`);
- what to build, with the edge cases spelled out (missing data, empty input, bad input) and where in
  a shared file to put its lines, so two workers' edits to one file merge clean;
- what not to touch (fixtures, `.env`, other workers' files, the contract);
- the checks to run, with the exact expected outputs;
- the commit message shape (`..., closes #<n>`), the attribution lines, `git push -u origin issue-<n>`;
- "do NOT merge, do NOT close the issue, do NOT comment on it";
- the report shape: commit sha, files changed, the checks' output verbatim, what it was unsure
  about, at most 12 lines.

Write the numbers in the brief from the data, not from memory: a worker once caught the
coordinator's "ok 11" when the file held 10. When a worker reports a mismatch, count again before
deciding.

## 3. When a worker reports

1. `git fetch`, then read the whole diff: `git diff main...origin/issue-<n>`. Accept nothing on the
   report alone.
2. Merge (`--ff-only` when it is first, `--no-edit` after). Run typecheck and tests on main. Two
   workers who import the same thing leave two import lines after a merge: fix that in the merge
   commit.
3. Check the issue's "Done when" yourself, the way the repo says (route, render, byte compare), not
   through the worker.
4. Push, then close with the repo's closing comment, crediting the worker's harness, model and
   effort, e.g. `worker: claude-code · sonnet-5.5 · low`, `commit: <sha>`.
5. Remove the worktree: `git worktree remove ../<repo>-wt-<n> --force`. Branches may stay on origin.

## 4. Issues that wait on the outside

An issue whose "Done when" is someone else's act (a review, a reply, a scheduled run) stays open
until that act lands, with a comment saying what it waits on. Closing it at send time has been
refused by a reviewer ("you closed it before I looked"). The clean-up issue is blocked by it.

Waiting: a background `sleep <retryAfter>` in Bash, then the same call again with the same answer.
Never a tight loop; take the delay the other side gives.

## 5. Before a public link goes out

Fetch it the way the other side will: a plain `curl` with no sign-in, byte-compared with the file
you uploaded. Where a preview lives is a rule of the working repo (CLAUDE.md or an ADR); a preview
is never a branch of the repo unless the repo says so.
