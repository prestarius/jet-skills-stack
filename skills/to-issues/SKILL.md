---
name: to-issues
description: Turn a plan, backlog, or work breakdown into independent, self-contained tracker issues that anyone can pick up cold. Use whenever the user says "make issues", "create tickets", "break this into tasks for the tracker", or has a finished plan ready to hand to a team. Tracker-agnostic — reads the tool and label vocabulary from CONTEXT.md.
---

Convert a plan into issues a contributor can grab without context from this conversation.

1. **Read the target.** Get the tracker and its label/triage vocabulary from `./CONTEXT.md` (the
   "Issue tracker" section). If it's not defined, ask once which tracker (GitHub, Jira, GitLab, Linear,
   plain Markdown) and output accordingly. Default to Markdown if unknown.
2. **Reuse the breakdown.** If the plan already uses Epic / User Story / Task structure, keep it and
   apply the `epic-numbering` convention; carry the IDs (`1.2.3`) into each issue as a stable reference.
   If it doesn't, structure it first.
3. **Make each issue independent.** Per issue, write:
   - **Title** — imperative, specific (`Add idempotency key to payment webhook handler`).
   - **Context** — the why and the just-enough background; assume no access to this chat.
   - **Scope** — what's in, what's explicitly out.
   - **Acceptance criteria** — verifiable, checkbox form; prefer a command/test that must pass.
   - **Labels / estimate** — from the project's vocabulary.
   - **Dependencies** — link blocking issues by their ID; otherwise state "none".
4. **Right-size.** One issue = one grabbable unit of work (hours-to-a-day-ish), not an epic and not a
   sub-task nobody would file separately. Split or merge to hit that.
5. **Output, then create.** Produce the full set as Markdown first for review. Only create them in a
   real tracker after the user confirms — and use the tracker's CLI/API (e.g. `gh issue create`) when
   that's the agreed tool. Never bulk-create against a live tracker unprompted.
