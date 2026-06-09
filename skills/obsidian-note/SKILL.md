---
name: obsidian-note
description: Generate a complete Obsidian note using Jet's frontmatter schema and section conventions. Use whenever the user wants a note for their vault, says "make an Obsidian note", "add this to my vault", or wants meeting/architecture/project notes captured. Notes from a Markdown source must be exhaustive, never summarized.
---

Produce a single `.md` note. Frontmatter (exact keys, fill all):
```
---
created: YYYY-MM-DD
tags: []
category:
status:
---
```
- `category` and `status` use the vault's existing vocabulary if `CONTEXT.md` defines it; otherwise ask once.
- Use fixed section headings appropriate to the note type; keep heading names consistent across notes.
- **Exhaustiveness rule:** if the note is derived from a Markdown document or a transcript, capture the full content faithfully — do not shorten into a summary. Restructure for clarity, but lose nothing.
- Never propose a starter vault. If a template/plugin is needed, suggest adding it as a single, separate step.

See `references/frontmatter-schema.md` for the schema rationale and `assets/note.template.md` for a blank template.
