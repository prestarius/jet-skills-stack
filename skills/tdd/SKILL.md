---
name: tdd
description: Drive implementation test-first, red-green-refactor, one vertical slice at a time. Use whenever the user wants to build a feature with TDD, asks to "write a failing test first", or wants disciplined incremental delivery.
---

Build behavior in tight test-first loops. Never write implementation ahead of a failing test.

For each thin vertical slice of behavior:

1. **Pick the slice.** The smallest piece of behavior that's worth a test — not a whole feature.
2. **Red.** Write one test that names the behavior and *fails*. Run it and confirm it fails for the
   right reason (the behavior is missing, not the test is broken).
3. **Green.** Write the minimum code to pass — no speculative generality, no gold-plating. Run the
   test; see it pass. (Simplicity-first applies here harder than anywhere.)
4. **Refactor.** With the test green, clean up names, duplication, and structure. Re-run the tests;
   keep them green.
5. **Repeat** with the next slice.

Rules:
- One behavior at a time; keep the loop fast. If a step is big, the slice is too big — split it.
- Use the project's test framework and conventions (read `./CONTEXT.md`; default to `pytest` for
  Python, the stack's idiomatic runner otherwise).
- **Verify by running the tests**, not by reading the code. State the command and the result.
- Commit per green slice if the user works that way.

When a bug is the target rather than a feature, write the failing test that reproduces it first, then
make it pass — that hands off cleanly to the `diagnose` regression-test step.
