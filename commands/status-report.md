---
description: Compose a stakeholder status update from recent work — git history plus the current conversation; PL or EN to match the audience.
argument-hint: "[period + audience, e.g. 'last week, steering group, PL']"
---
Read `./CONTEXT.md` if present. Build a status update for the period and audience in
`$ARGUMENTS` (default period: since last Monday; default audience: technical peers).

1. Gather what actually happened: `git log --since=...` in this repo, the current conversation,
   and any notes passed in `$ARGUMENTS`. Outcomes, not commit messages — translate "what changed"
   into "what the reader can now see, use, or stop waiting for".
2. Write four sections: **Done**, **In progress**, **Blocked / risks**, **Next**. If a section is
   empty, say "nothing" — never pad.
3. Match the audience: language (PL or EN), and altitude — no commit hashes or file paths for
   executives; keep them for engineering audiences.

Markdown only. State the covered period at the top. Don't invent progress: if something can't be
verified from the sources above, leave it out or mark it `TODO: confirm`.
