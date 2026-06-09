---
name: write-a-skill
description: Create a new Claude Code skill with correct structure, frontmatter, and progressive disclosure. Use whenever the user wants to author a skill, says "make a skill for X", or is packaging a repeatable workflow into a SKILL.md.
---

Author a skill that triggers reliably and stays small.

1. **Nail the trigger.** The `description` *is* the trigger — under-triggering is the main failure
   mode. Write it specific and slightly pushy: name the concrete phrases and situations the user would
   actually be in ("use whenever the user says X / is about to Y"). Cover the behavior and when to fire.
2. **Scaffold the files.** `skills/<kebab-name>/SKILL.md` with YAML frontmatter `name` (kebab-case,
   matching the folder) + `description`. The body is a tight, decisive workflow — numbered steps, no padding.
3. **Apply progressive disclosure.** Keep `SKILL.md` short (well under ~500 lines). Push long detail,
   schemas, or templates into bundled `references/`, `assets/`, or `scripts/` and point to them from the body.
4. **Compose, don't duplicate.** If the skill overlaps an existing one, reference it (e.g. "use the
   `tradeoff-table` skill") rather than re-implementing. Check `skill-stocktake` territory — don't add a
   near-duplicate.
5. **Wire it in.** Add a row to `README.md`; follow `docs/conventions.md` (flat `skills/`, full-vs-stub
   policy). Match the house style: company-agnostic (no employer/client names — anything project-specific
   belongs in `CONTEXT.md`), decisive, surgical.
6. **Validate.** Confirm the frontmatter has `name` + `description`, any referenced bundled files exist,
   and the content passes the company-agnostic gate.

A good skill is one page that does one thing and fires when it should. Resist scope creep into a second skill.
