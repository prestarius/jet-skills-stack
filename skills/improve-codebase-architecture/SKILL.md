---
name: improve-codebase-architecture
description: Proactively survey a codebase and surface the highest-leverage architectural improvements, framed in the project's own domain language and captured as decision records. Use whenever the user asks "how should this be structured", "where's the architectural debt", "what should we refactor first", is planning a modernization, or wants an architecture health-check rather than a line-by-line review.
effort: high
---

Find the architectural improvements that matter, prioritized — don't rewrite anything.

1. **Ground in the domain.** Read `./CONTEXT.md` first (ubiquitous language, stack, constraints,
   where ADRs live). Use the project's own terms for components and boundaries throughout — not
   generic labels. If no `CONTEXT.md` exists, infer the domain from the code and say so.
2. **Survey, don't audit line-by-line.** Map the real structure: module boundaries, coupling and
   cohesion, dependency direction, where business logic leaks into the wrong layer, sync/async
   boundaries, data ownership, seams that are missing for testing or change.
3. **Name the improvements.** For each, write:
   - **What** — the smell, in domain language ("orders logic reaches into the billing store directly").
   - **Why it matters** — the concrete cost today (change amplification, blast radius, untestability),
     not a hypothetical.
   - **The change** — the smallest structural move that fixes it. Bias to the simplest option that
     works; don't propose a rewrite where a seam will do.
   - **Effort / risk** — rough size and what could break.
4. **Prioritize.** Order by leverage = (pain relieved) ÷ (effort + risk). Lead with the one or two
   that unblock the most future work. Be explicit that the rest can wait.
5. **Record the decision.** For any improvement the user commits to, offer to capture the direction
   as an ADR via the `adr` skill (one decision per record, with the rejected alternatives).

Stay surgical: this skill *recommends*, it does not refactor. Flag pre-existing issues; never edit
adjacent code unasked. If the architecture is genuinely fine, say so plainly rather than inventing work.
