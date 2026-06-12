# Conventions

How to extend this stack. Keep it small and composable — small, adaptable, model-agnostic.

## Adding a skill
1. Create `skills/<name>/SKILL.md` with YAML frontmatter `name` + a pushy `description`
   (the description is the trigger; under-triggering is the main failure mode).
   The frontmatter `name` must equal the directory name — the directory is what becomes the
   `/command`; `name` is display-only.
2. Push detail into bundled `references/`, `assets/`, or `scripts/`; keep `SKILL.md` under ~500 lines.
3. Add the skill to the table in `README.md`.
4. If it should ship in the plugin, no manifest edit is needed — components in `skills/`,
   `commands/`, `agents/`, `hooks/` are auto-discovered.
5. Run `scripts/validate.sh` — it must print `OK` before you commit.

Skills are directly slash-invocable, so don't add a wrapper command with the same name as a
skill — the skill takes precedence and the command is dead weight. Also avoid names of bundled
Claude Code skills (`code-review`, `security-review`, `verify`, …).

## Adding a command
- Create `commands/<name>.md`. Optional frontmatter: `description`, `argument-hint`, `allowed-tools`.
- Body is the prompt; `$ARGUMENTS` / `$1` placeholders are supported. Commands may invoke skills
  and set a persona. Add it to the commands table in `README.md`.

## Full vs stub skills
- **Full** — the complete behavior is authored in-repo.
- **Stub** — frontmatter + a 3–5 line summary + a pointer to the upstream source. Use stubs for
  skills adopted from elsewhere; flesh them out in-repo or install the upstream version later.

## Buckets
- v1 uses a **flat** `skills/` directory. If the count grows, optional buckets
  (`personal/`, `in-progress/`, `deprecated/`) may be introduced — but keep them OUT of
  `plugin.json` and `README.md`. Do not over-organize early.
