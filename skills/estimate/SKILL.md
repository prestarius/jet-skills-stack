---
name: estimate
description: Estimate effort for a feature, plan, or backlog with explicit assumptions and confidence ranges — never a single confident number. Use whenever the user asks "how long will this take", "estimate this", "size the backlog", "t-shirt sizes for these", or a plan/issue set needs effort attached before commitment.
---

Produce estimates a stakeholder can trust *because* the uncertainty is visible, not hidden.

1. **Decompose first.** Break the work into independently estimable items (reuse the
   `epic-numbering` structure if the input is a backlog; if items are too vague to size,
   say which and why). Read `./CONTEXT.md` for the team's units and velocity conventions.
2. **Estimate per item, as a range.** Three-point (optimistic / likely / pessimistic) for
   anything consequential; T-shirt sizes only when the audience asked for rough order.
   State the unit explicitly (person-days, sprints) — never bare numbers.
3. **Surface what drives the spread.** List the assumptions each estimate rests on and the
   unknowns that dominate the pessimistic tail. Where one unknown dwarfs the rest, recommend
   a spike via the `prototype` skill to shrink it before anyone commits to the number.
4. **Aggregate honestly.** Sum the ranges, don't sum the likely values and call it the total.
   Give the total as a range with a stated confidence, and flag dependency chains where one
   slip cascades.
5. **State the invalidation conditions.** What change (scope, staffing, a discovered constraint)
   would void the estimate — so the reader knows when to ask again.

An estimate with no assumptions listed is a guess in a suit. If the input is genuinely
un-estimable, say so and name the one question that would change that.
