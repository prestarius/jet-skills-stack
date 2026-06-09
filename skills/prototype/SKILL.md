---
name: prototype
description: Build a deliberately throwaway prototype to answer one specific design or feasibility question fast, then report what it proved. Use whenever the user wants to "spike", "try an approach", "see if X is feasible", "prototype this", or is choosing between designs and needs evidence rather than argument. Not for production code.
---

A prototype exists to answer a question, not to ship. Treat it as disposable from the first line.

1. **State the question.** Pin down the single thing the prototype must resolve ("can we stream this
   under 200ms?", "does library X fit our data model?", "which of these two APIs is simpler to use?").
   If there are several questions, do the riskiest one first. Refuse to start without a clear question.
2. **Build the minimum that answers it.** Hard-code, stub, and fake everything not under test. No
   error handling, no abstractions, no tests, no config, no polish — those would be wasted effort on
   code you intend to delete. Timebox it; smaller is better.
3. **Isolate it.** Put it somewhere clearly disposable (e.g. a `spike/` or `prototype/` dir, or a
   throwaway branch). Mark it as throwaway in a comment/README so it can't be mistaken for real code.
4. **Report the finding.** State the answer plainly, the evidence (numbers, the snippet that proved
   it, what broke), and a **recommendation**: which design to take forward, or what to spike next.
5. **Close it out.** Default to deleting the prototype. If a piece is worth keeping, say which part
   "graduates" — and note that graduating means rewriting it properly (with tests, error handling,
   real structure), not promoting the throwaway code as-is.

Never let prototype shortcuts leak into production unasked. The deliverable is the *answer*; the code
is scaffolding.
