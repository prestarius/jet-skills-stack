---
name: document
description: Generate complete, structured documentation for a feature, module, API, or project using the Diataxis framework (tutorial / how-to / reference / explanation). Use whenever the user asks to "write docs", "document this", "generate documentation", "write a tutorial", "write a how-to", or "explain this module". Reads the real code before writing and never documents behavior the code doesn't have.
---

Produce documentation a reader can actually use, partitioned by what they need — not one
undifferentiated wall of prose.

1. **Scope & intent.** Confirm what to document and for whom. Ask once whether output should be
   inline (docstrings/README sections) or standalone files under `docs/` — default to standalone.
   Read `./CONTEXT.md` if present for the stack, domain language, and where docs already live.
2. **Read the code first (non-negotiable).** Before writing a line, read the implementation, its
   tests, config, and the public surface. Documentation is derived from what the code *does*, not
   what it should do. If something is undocumented because it's unclear, say so — don't invent it.
3. **Partition by Diataxis.** Decide which of the four quadrants the subject actually needs (not
   everything needs all four):
   - **Reference** — complete, accurate, factual description of the surface (API, flags, config).
     Information-oriented. Tie every entry to the code.
   - **Explanation** — *why* it works this way: design decisions, trade-offs, alternatives rejected.
     Understanding-oriented. (If a decision is load-bearing, suggest capturing it via the `adr` skill.)
   - **How-to** — task-oriented recipes that assume basic familiarity ("how to add a new handler").
   - **Tutorial** — a learning-oriented walkthrough for a newcomer, with a working example that
     produces a visible result early. Every step must actually run.
4. **Write reference first, then explanation, then how-to, then tutorial.** Reference grounds the
   rest; the others link back to it.
5. **Cross-link and index.** Connect the quadrants to each other and update the README / docs index
   so the new pages are discoverable. Don't leave orphans.
6. **Self-review against the code.** Check every factual claim against the implementation, confirm
   examples run (macOS-first commands), and keep the voice plain — apply the `humanizer` patterns to
   your own output. Markdown by default.

Don't pad, don't duplicate the same content across quadrants, and don't auto-commit — present the
files for review.
