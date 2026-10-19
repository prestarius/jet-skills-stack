# jet-skills

A personal Claude Code stack: skills, role commands, guardrails, and a bootstrap.
Skills are model-agnostic and company-agnostic; per-project context lives in the working repo.
Ponytail drives coding, review and audit; Matt Pocock's skills cover TDD, debugging, grilling,
domain modelling, specs and tickets. This stack keeps only what neither covers.

## Language
**Skill** — one instruction set in `skills/<name>/SKILL.md`, triggered by its description.
**Command** — a slash-command workflow in `commands/<name>.md`; may invoke skills and set a persona.
**Guardrail** — a durable behavior in the global `CLAUDE.md`.
**Project CONTEXT.md** — the per-repo domain glossary, owned by Matt Pocock's `domain-modeling`. Stack, conventions, tracker and compliance live in the repo's `CLAUDE.md`/`AGENTS.md` and `docs/agents/`. _Avoid_: "company config", "tenant file".
