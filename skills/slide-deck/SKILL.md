---
name: slide-deck
description: Plan and generate a training/working-session slide deck in Jet's house style (charcoal/teal) as a self-contained HTML deck, with presenter script and lab material. Use whenever the user wants slides, a deck, a training session, or a workshop. For .pptx output, defer file generation to a pptx-capable skill if one is installed but apply this skill's theme and structure.
---

Default format: a **self-contained HTML deck**. Offer **.pptx** only if a pptx-capable skill is
available (Anthropic's document skills, `pptx` in github.com/anthropics/skills — source-available,
installable from that repo's marketplace); never hand-roll a .pptx generator. Apply the house
theme either way (see `references/theme.md`).

Deck structure for a training session:
- Title + session number + one-line objective
- "Where we are" recap (for a series)
- 3–6 content sections, each: concept slide → demo/example slide → "your turn" slide
- A **lab** slide pointing to lab materials
- Recap + next-session teaser

Always produce, alongside the deck:
- a **presenter script** (speaker notes, what to say per slide), and
- **lab material** (the hands-on exercise) as separate Markdown.

Facilitation defaults for larger rooms: breakout groups of 3, cold-call by group, chat-first
participation. Surface these as presenter notes, not slides.

See `references/theme.md` for the palette and type scale.
