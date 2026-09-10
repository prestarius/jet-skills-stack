---
name: write-a-skill
description: Create a new Claude Code skill with correct structure, frontmatter, and progressive disclosure. Use whenever the user wants to author a skill, says "make a skill for X", or is packaging a repeatable workflow into a SKILL.md.
---

Author a skill that triggers reliably, stays small, and can be measured.

1. **Nail the trigger.** The `description` *is* the trigger — under-triggering is the main failure
   mode. Write it in third person, "what it does + when to use it", naming the concrete phrases and
   situations the user would actually be in. Add a negative boundary when a sibling skill is close
   ("for X use `y` instead"). Split any description with more than one "and". Put extra trigger
   phrases in `when_to_use:`; the two fields share a 1,536-character cap in the listing.
2. **Decide who invokes it.** Default: both. `disable-model-invocation: true` for anything the
   user always starts by hand or that has side effects — its description then costs no context at
   all. `user-invocable: false` for background knowledge Claude should apply but nobody types.
3. **Scaffold the files.** `skills/<kebab-name>/SKILL.md`; the `---` must be line 1; frontmatter
   `name` (kebab-case, matching the folder) + `description`. The body is a tight, decisive
   workflow — numbered steps, no padding. Other fields only when needed: `argument-hint`,
   `allowed-tools` (e.g. `Bash(${CLAUDE_SKILL_DIR}/scripts/*)`), `effort`, `model`,
   `context: fork` + `agent` for heavy work that should not pollute the main context, `paths` to
   load only when matching files are touched. Reference bundled files via `${CLAUDE_SKILL_DIR}`.
4. **Apply progressive disclosure.** Keep `SKILL.md` well under ~500 lines and the body under
   ~5,000 tokens. Push long detail, schemas, or templates into `references/`, `assets/`, or
   `scripts/` (one level deep) and point to them from the body.
5. **Compose, don't duplicate.** If the skill overlaps an existing one, reference it ("use the
   `tradeoff-table` skill") rather than re-implementing. Check with `skill-stocktake` — don't add a
   near-duplicate.
6. **Wire it in.** Add a row to `README.md`; follow `docs/conventions.md` (flat `skills/`,
   full-vs-stub policy). Company-agnostic: no employer/client names, no personal locale defaults
   — anything project-specific belongs in `CONTEXT.md`, anything personal in the rules files.
7. **Validate and measure.** Run the repo's `validate.sh` gate (frontmatter, bundled files,
   description length) and `claude plugin validate .`. Add 2–3 eval cases under `evals/` (a should-trigger
   prompt, a should-not-trigger prompt, one edge case) so trigger accuracy can be checked with
   `claude plugin eval`. Only `name`, `description`, `license`, `compatibility`, `metadata`,
   `allowed-tools` travel to other Agent-Skills tools; note Claude-only fields in `compatibility`.

A good skill is one page that does one thing and fires when it should. Resist scope creep into a
second skill.
