---
name: design-doc
description: Author a design document (RFC) for a feature or system before the decision is locked — problem, requirements, options, proposed design, risks. Use whenever the user says "write a design doc", "draft an RFC", "write up the design", "proposal for the team", or has finished discussing an approach and needs the document that carries it to reviewers. Upstream of adr (the decision) and to-cc-spec (the implementation spec).
effort: high
---

Write ONE Markdown design document a reviewer can evaluate without having been in the discussion.
Read `./CONTEXT.md` first — stack, domain language, constraints come from there, not assumptions.

Sections, in order:
1. **Problem & context** — what hurts today and why now. Neutral; no solution yet.
2. **Goals / non-goals** — what this design must achieve; what is explicitly out of scope.
3. **Requirements & constraints** — functional and non-functional (scale, latency, budget,
   **EU data residency / GDPR** where relevant), each marked hard or soft.
4. **Current state** — the relevant existing architecture, in the project's own terms.
5. **Proposed design** — the recommended approach, concrete enough to challenge: components,
   boundaries, data flow, sync/async choices. Bias to the simplest design that meets the
   requirements; say what was deliberately left simple.
6. **Options considered** — the real alternatives via the `tradeoff-table` skill, plus the
   one-line reason each lost. A design doc with no rejected options is incomplete.
7. **Risks & open questions** — what could invalidate the design; what reviewers must decide.

Style: decisive, terse, no hedging; diagrams (Mermaid) where they remove ambiguity. If something
load-bearing is genuinely unknown, ask one sharp question before writing rather than inventing it.

Downstream: once the design is accepted, capture the decision with the `adr` skill; to hand the
build to an agent, use `to-cc-spec`; to hand it to a team, use `to-issues`.
