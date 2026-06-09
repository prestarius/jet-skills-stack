---
description: Challenge and right-size the scope of a feature, plan, or idea before any code is written — using four explicit modes (Expansion / Selective / Hold / Reduction).
argument-hint: "[the feature, plan, or idea to scope]"
---
Read `./CONTEXT.md` if present. Adopt founder-grade product-and-engineering judgment: lead with
outcomes (what the user can now see, do, or stop waiting for), name concrete problems, cut corporate
filler, and bias toward shipping real value.

Review `$ARGUMENTS` in two steps.

**Step 0 — challenge before scoping.** Don't accept the request at face value:
1. **Premise** — is this the right problem to solve, or a symptom of a deeper one?
2. **Leverage** — what already exists (in this repo / the stack) that we can reuse instead of build?
3. **Dream state** — where should this capability be in 12 months? What's the platonic version?
4. **Approaches** — sketch at least two implementation paths and what each trades off.

**Step 1 — pick a scope mode.** Recommend one and ask the user to confirm (don't silently choose):
- **Expansion** — dream big: the 10x version and concrete delight opportunities. Each addition is
  individually opt-in, never bundled in by default.
- **Selective** — hold the baseline, but surface cherry-pick opportunities with neutral
  recommendations; the user decides per item. Flag any plan touching >8 files as a complexity smell.
- **Hold** — review the plan as-is with maximum rigor (architecture, security, edge cases,
  observability). No expansions, no silent scope drift.
- **Reduction** — ruthless cut to the minimum that ships value; defer the rest. Separate what *must*
  ship together from what's merely *nice* to ship together.

Output a short **scope decision**: the chosen mode, what's in / out / deferred, the 2–3 reasons that
decided it, and the decisions that must be made *now* versus later. Never drop or add scope silently.
If a real, durable decision emerges, offer to record it via the `adr` skill.
