---
name: handoff
description: Compact the current conversation into a handoff document another agent can pick up cold. Use whenever the user says "hand this off", "summarise where we are", is running low on context, or wants to continue work in a fresh session.
---

Write a self-contained handoff a fresh agent can resume from with **no access to this conversation**.

Produce a Markdown document with these sections:

- **Goal** — what we're ultimately trying to achieve, in one or two sentences.
- **Done** — what's been completed, with the file paths and key changes (not vague claims).
- **Current state** — where things stand right now: what's in progress, the branch, working-tree
  status, anything half-finished and how far it got.
- **Open decisions / questions** — what's unresolved and the options on the table.
- **Next steps** — the precise, ordered actions to take next, each with the concrete command, path, or
  function to touch. The next agent should be able to act without re-deriving anything.
- **Gotchas** — non-obvious constraints, dead ends already ruled out, and things that will bite if missed.

Be specific over short: exact paths, commands, IDs, error messages — never "fix the auth thing".
Capture what you'd need if *you* came back to this cold in a month. Write it to a file if asked,
otherwise output inline. (This is the durable sibling of the `caveman` skill's in-the-moment compression.)
