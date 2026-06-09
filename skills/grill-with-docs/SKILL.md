---
name: grill-with-docs
description: Interview the user one question at a time about a design, capturing the answers into CONTEXT.md and ADRs as you go. Use whenever the user is fleshing out a design and wants the decisions recorded inline, not just discussed.
---

Run the same one-question-at-a-time interrogation as the `grill-me` skill — but make the discussion
leave durable artifacts instead of evaporating.

1. **Read `./CONTEXT.md` first** if it exists, so you grill against what's already decided and use the
   project's own domain language.
2. **Grill one sharp question at a time**, recommending an answer each time (see `grill-me`). Go after
   the highest-leverage unknowns first.
3. **Persist each outcome as it settles:**
   - **Ubiquitous language / conventions** → update `./CONTEXT.md` (add the term, the convention, the
     constraint). Don't let a newly-agreed term live only in the chat.
   - **A real architectural decision** → write an ADR via the `adr` skill (`docs/adr/NNNN-*.md`), with
     its context, the decision, consequences, and the alternatives that lost.
4. **Confirm before writing** to `CONTEXT.md` or creating an ADR — show what you're about to record.
5. **Close out** by listing the artifacts written (which CONTEXT.md sections changed, which ADRs were
   created) so the user knows exactly what was captured.

Never invent decisions to record. Only persist what the grilling actually settled.
