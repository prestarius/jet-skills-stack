---
name: migration-plan
description: Turn a modernization goal or architectural finding into a phased migration plan — current state to target state with coexistence, cutover criteria, and rollback per phase. Use whenever the user asks "how do we get from X to Y", "plan the migration", "phase out the legacy system", "strangler this", or commits to an improvement from improve-codebase-architecture and needs the route, not just the destination.
effort: high
---

Plan the route from current to target in phases that each leave the system working. Read
`./CONTEXT.md` first; describe both states in the project's own domain language.

1. **Pin down both ends.** Current state (what actually runs, including the ugly parts) and
   target state. If the target itself is undecided, stop — route to `design-doc` or `grill-me`
   first; a migration plan toward a vague target is fiction.
2. **Bias to incremental.** Default to strangler-fig-style coexistence: new and old running
   side by side, traffic/data moving over in slices. A big-bang cutover needs explicit
   justification (and a rehearsal plan).
3. **Phase the work.** For each numbered phase:
   - **Scope** — the slice that moves, and what explicitly stays on the old path.
   - **Coexistence mechanism** — routing, facade, dual-write/backfill, feature flag; name it.
   - **Exit criteria** — the measurable condition that ends the phase (a **verify:** step, not a date).
   - **Rollback** — the concrete way back if the phase fails, and what it costs.
4. **Name the classic risks where they apply:** data migration and backfill integrity, dual-write
   drift, contract/consumer breakage, freeze windows, the long tail of stragglers on the old path,
   and the danger of the coexistence layer becoming permanent — give each phase an owner condition
   for removing scaffolding.
5. **Route onward.** Capture the chosen strategy as an ADR (`adr` skill), break phases into
   tracker issues (`to-issues`), and size them with the `estimate` skill if asked.

Prefer the smallest first phase that proves the mechanism end-to-end over a "foundations" phase
that delivers nothing observable.
