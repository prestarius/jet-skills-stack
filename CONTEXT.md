# jet-skills

A personal Claude Code stack: skills, role commands, guardrails, and a bootstrap.
Skills are model-agnostic and company-agnostic; per-project context is injected via a
local `CONTEXT.md` emitted by `/bootstrap-context`.

## Language
**Skill** — one instruction set in `skills/<name>/SKILL.md`, triggered by its description.
**Command** — a slash-command workflow in `commands/<name>.md`; may invoke skills and set a persona.
**Guardrail** — a durable behavior in the global `CLAUDE.md`.
**Project CONTEXT.md** — the per-repo glossary + conventions written by `/bootstrap-context`; this is where all company/domain specifics live. _Avoid_: "company config", "tenant file".
