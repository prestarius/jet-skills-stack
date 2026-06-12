---
name: meeting-notes
description: Turn raw meeting notes or a transcript into structured minutes — decisions, action items with owners, open questions — and route them onward (Obsidian note, ADRs, tracker issues). Use whenever the user pastes a transcript or messy notes and says "write this up", "minutes", "notatka ze spotkania", "what did we decide", or wants meeting output captured rather than lost.
---
Read `./CONTEXT.md` if present — use its glossary for terms and its tracker vocabulary for actions.

Produce minutes with these sections, in the language of the source material unless asked otherwise:
1. **Context** — what meeting, when, attendees (only if stated in the source).
2. **Decisions** — one line each: what was decided and why, as stated.
3. **Action items** — `owner — action — due` ; if owner or due date is not in the source, write
   `TODO:` rather than inventing one.
4. **Open questions** — unresolved points, each with who can answer it if known.
5. **Parking lot** — raised but deferred topics.

Rules:
- Extract, don't summarize away: if the source is Markdown, the output must be full and
  exhaustive (per the working agreement) — every decision and action in the source appears here.
- Never attribute opinions to named people unless the source does.
- Quote ambiguous statements verbatim instead of interpreting them.

Then offer routing (each opt-in, never automatic): the obsidian-note skill to file it in the
vault, the adr skill for any durable architecture decision, the to-issues skill for the action
items.
