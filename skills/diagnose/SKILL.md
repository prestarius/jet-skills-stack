---
name: diagnose
description: Debug methodically — reproduce, minimise, hypothesise, instrument, fix, then add a regression test. Use whenever the user is chasing a bug, says "why is this failing", "help me debug", or has a flaky/mysterious failure.
effort: high
---

**Iron law: no fix without a reproduction and a confirmed cause.** Don't shotgun changes hoping one sticks.

Work the loop:

1. **Reproduce.** Get a reliable, ideally deterministic repro before touching anything. If you can't
   reproduce it, *that* is the first problem to solve (control inputs, seeds, environment, timing).
2. **Minimise.** Shrink to the smallest failing case — strip away unrelated code, data, and config
   until only the essentials that still fail remain. Each thing removed is a variable eliminated.
3. **Hypothesise.** State a single, falsifiable hypothesis about the cause ("the cache returns a stale
   value because the key omits the tenant id"). One at a time.
4. **Instrument.** Add a log, assertion, breakpoint, or probe that will *confirm or deny* the
   hypothesis. Let the evidence decide — never guess-patch before the cause is proven. If the evidence
   refutes the hypothesis, form the next one and repeat.
5. **Fix the root cause**, not the symptom. If you're tempted to patch a symptom, name the root cause
   you're choosing not to fix and why.
6. **Regression test.** Add a test that fails before the fix and passes after, so the bug can't return.
   (Hand the failing-test-first part to the `tdd` skill.)

For flaky/intermittent bugs, the repro step *is* the work: pin down the nondeterminism (ordering,
concurrency, time, external state) before hypothesising. Report what you ruled out, not just the fix.
