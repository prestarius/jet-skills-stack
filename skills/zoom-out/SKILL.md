---
name: zoom-out
description: Explain unfamiliar code in the context of the whole system, not just the file in front of you. Use whenever the user is onboarding to a codebase, asks "what does this do / how does this fit", or needs the big picture before changing something.
---

Explain code by its place in the system, not line by line. Context before specifics.

1. **Locate it.** Trace outward with `Grep`/`Explore`: what calls this (callers), what it calls
   (dependencies), and the data that flows in and out. Identify the subsystem it belongs to.
2. **Explain the surroundings first.** Describe the subsystem's responsibility, its boundaries, and how
   this piece fits the larger flow — using the project's own domain language (read `./CONTEXT.md`).
3. **Then the specifics.** Now explain what the code itself does and, more importantly, *why it lives
   where it does* — the role it plays, the contracts it honors, the assumptions it relies on.
4. **Surface what matters for change.** Call out the blast radius: who depends on this, what would
   break if it changed, and the non-obvious couplings. If the user is here to modify it, this is the
   payload.

Output a short map first — `callers → this → callees`, plus the data flow — then the explanation. Use
a diagram where it's clearer than prose. Don't narrate every line; explain the shape and the seams.
