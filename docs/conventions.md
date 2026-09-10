# Conventions

How to extend this stack. Keep it small and composable — small, adaptable, model-agnostic.

## Layout

| Directory | What lives there | Installed by |
|---|---|---|
| `skills/<name>/SKILL.md` | every workflow, whether Claude or the user starts it | `install.sh` (symlink) and the plugin |
| `agents/<name>.md` | subagent personas | both |
| `hooks/` | `hooks.json` + `scripts/` guardrails | plugin; `install.sh --hooks` |
| `rules/` | `working-agreement.md` (generic, shipped) and `personal-defaults.md` (one person's locale; opt-in) | `install.sh` as `~/.claude/rules/`; the plugin injects the agreement via a `SessionStart` hook |
| `evals/` | `claude plugin eval` cases; run with `scripts/eval.sh` | — |

There is no `commands/` directory: custom commands are a legacy mechanism merged into skills.
A user-started workflow is a skill with `disable-model-invocation: true`.

## Adding a skill
1. Create `skills/<name>/SKILL.md`. The opening `---` must be line 1. Frontmatter `name` must
   equal the directory name (for plugin skills `name` sets the command; elsewhere the directory
   does). Write a pushy, third-person `description` — "what it does + when to use it", concrete
   trigger phrases, and a routing line to any sibling skill. `description` + `when_to_use` are
   capped at 1,536 characters in the listing.
2. Decide who invokes it: default both; `disable-model-invocation: true` when the user always
   starts it by hand (its description then costs no context); `user-invocable: false` for
   background knowledge.
3. Push detail into bundled `references/`, `assets/`, or `scripts/` (reference them via
   `${CLAUDE_SKILL_DIR}`); keep `SKILL.md` under ~500 lines.
4. Add the skill to the table in `README.md`; add an eval case under `evals/` if it has a
   sibling it could be confused with.
5. Run `scripts/validate.sh` — it must print `OK` before you commit.

Avoid names of bundled Claude Code skills (`code-review`, `security-review`, `verify`, `simplify`,
`batch`, `loop`, `schedule`, `debug`, `doctor`, …); a same-named skill shadows the bundled one.

Only `name`, `description`, `license`, `compatibility`, `metadata`, and `allowed-tools` are part
of the cross-tool Agent Skills spec; `effort`, `context`, `agent`, `paths`,
`disable-model-invocation` and friends are Claude Code-only.

## Company-agnostic and person-agnostic
No employer, client, or internal-project names anywhere in `skills/`, `agents/`, `hooks/`, or
`rules/working-agreement.md`. Project specifics go in the per-repo `CONTEXT.md` (written by
`/bootstrap-context`); personal locale and output defaults go in `rules/personal-defaults.md`.
Skills refer to both by role ("the compliance lens from CONTEXT.md", "the product-link defaults
from the working agreement"), never by value.

## Full vs stub skills
- **Full** — the complete behavior is authored in-repo.
- **Stub** — frontmatter + a 3–5 line summary + a pointer to the upstream source. Use stubs for
  skills adopted from elsewhere; flesh them out in-repo or install the upstream version later.

## Releasing
Bump `version` in `.claude-plugin/plugin.json`, keep the marketplace entry's description identical,
update `metadata.verified_against`, then `claude plugin tag --dry-run` and `claude plugin tag --push`.

## Buckets
v1 uses a **flat** `skills/` directory. If the count grows, optional buckets
(`personal/`, `in-progress/`, `deprecated/`) may be introduced — but keep them OUT of
`plugin.json` and `README.md`. Do not over-organize early.
