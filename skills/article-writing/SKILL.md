---
name: article-writing
description: Draft a long-form article, blog post, essay, or technical write-up in the author's own voice — outline first, then a full draft that reads like a person wrote it. Use whenever the user asks to "write an article", "draft a blog post", "write a long-form piece", "turn this into an essay", or wants a publishable write-up rather than notes or a spec.
---

Write something worth reading: a clear argument in the author's voice, not generic AI filler.

1. **Set the brief.** Pin down topic, audience, the one thing the reader should take away, rough length,
   and **voice**. If the user gave a writing sample or `./CONTEXT.md` defines a tone, match it; otherwise
   ask once. Respond in the language the user is writing in (PL or EN).
2. **Get the facts straight.** If the piece makes claims that could be wrong or dated, research them
   first (use the `search-first` / `market-research` skills) and verify on the web. Don't invent
   sources, quotes, or statistics.
3. **Outline, then confirm.** Propose a structure — a strong lede (a hook or a sharp claim, not a
   warm-up paragraph), the body beats, and a real takeaway. Get a nod before drafting a long piece.
4. **Draft in voice.** Write the full piece. Make an argument; be concrete and specific; have a point
   of view where the genre allows it. Vary sentence rhythm. Avoid the AI tells — apply the `humanizer`
   patterns to your own prose as you write (no "in today's fast-paced world", no rule-of-three padding,
   no hollow conclusion).
5. **Finish clean.** Markdown by default. If it's destined for the vault, emit it via the
   `obsidian-note` schema instead. If the source was a Markdown document, stay **exhaustive** — restructure
   for readability but don't quietly drop content.

Don't pad to hit a word count, and don't bury the point. One strong draft the author can edit beats a
hedged, voiceless one.
