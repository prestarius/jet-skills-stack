---
description: Set up or refresh this repo's project context — writes a local CONTEXT.md so every other skill/command has company/domain specifics without anything being hardcoded.
argument-hint: "[optional: path to a brief or existing docs]"
---
You are setting up per-project context for this repository. Nothing about the user's
employer/client is hardcoded in this stack — it lives only in the CONTEXT.md you create.

**If `./CONTEXT.md` already exists, refresh instead of recreating:** read it, compare it
against the current repo reality (stack, conventions, glossary, tracker), and propose a diff —
new entries to add, stale entries to update or drop. Preserve manual edits and unresolved
`TODO:` lines; never silently overwrite. Then apply the confirmed changes and stop (skip the
steps below).

Otherwise, create it:

1. Gather context, in this priority order:
   a. Read the current repo (README, package manifests, existing docs/, code structure).
   b. Read anything passed in `$ARGUMENTS`.
   c. Pull from the current conversation.
   d. Only if still missing, ask the user — one question at a time.
2. From `templates/CONTEXT.template.md` (in the jet-skills repo), write `./CONTEXT.md` in THIS
   repo covering: project one-liner, domain glossary (ubiquitous language), tech stack,
   conventions, issue tracker + label vocabulary, where docs/ADRs live.
3. Confirm with the user before writing. Never invent company facts; if unknown, leave a
   `TODO:` line for them to fill.
