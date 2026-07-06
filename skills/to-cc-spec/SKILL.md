---
name: to-cc-spec
description: Turn the current conversation (a design, idea, or half-finished plan) into a self-contained Claude Code–ready implementation spec that a fresh agent can execute without the chat. Use whenever the user says "write a spec", "make this Claude Code–ready", "turn this into an implementation plan", or is about to delegate a build to another agent. For a session-continuity snapshot ("summarise where we are", pick up in a fresh session) use the handoff skill instead — this one specs a build, it doesn't compact a conversation.
---

Produce ONE Markdown file a fresh Claude Code agent can execute end-to-end with no access to this conversation. Name it `<THING>_SPEC.md` in SCREAMING_SNAKE.

Required sections, in order:
1. **Goal & non-goals** — what gets built; what is explicitly out of scope.
2. **Context & assumptions** — everything the executing agent needs; mark each assumption explicitly (don't bury them). If something is genuinely undecided, list it under *Open questions* instead of guessing.
3. **Architecture decisions** — the concrete choices (stack, data stores, boundaries, auth, hosting) with one-line rationale each. Prefer the simplest design that works (see guardrail #2).
4. **Repo / file layout** — a tree, then per-file purpose.
5. **Phased implementation plan** — numbered phases; each phase ends with an explicit **verify:** step (a command to run or a check to make). Goal-driven, not imperative.
6. **Exact commands** — setup/run/test commands, macOS-first, Python-first unless the stack dictates otherwise.
7. **Open questions** — anything the human must still decide.

Style: decisive, terse, no hedging. Include real code/config where it removes ambiguity. Do not pad. If the conversation lacks something load-bearing, ask one question before writing rather than inventing it.
