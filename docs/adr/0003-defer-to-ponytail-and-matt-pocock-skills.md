# 0003. Defer to ponytail and Matt Pocock's skills; retire the duplicates
- Status: Accepted
- Date: 2026-10-19
- Deciders: Jet

## Context
The ponytail plugin (coding, review, audit) and the mattpocock-skills plugin (TDD, debugging,
grilling, domain modelling, specs, tickets, handoff, prototype, teach) are now installed next to
this stack. Seventeen skills here did the same jobs with opposite rules: one question per turn vs
rounds, one hypothesis vs 3–5 ranked, refactor inside vs outside the TDD loop, file paths in specs
vs none, `CONTEXT.md` as project facts vs glossary only, new dependencies vs installed-first.
Two skills answering one request makes routing and behaviour unpredictable.

## Decision
We will treat ponytail as the main driver and Matt Pocock's skills as the second source, and
delete our duplicates: `tdd`, `diagnose`, `grill-me`, `grill-with-docs`, `adr`, `handoff`,
`prototype`, `improve-codebase-architecture`, `teach`, `to-cc-spec`, `to-issues`,
`bootstrap-context`, `humanizer`, `search-first`, `scope-review`, `simplicity-review`, `caveman`.
`CONTEXT.md` is the domain glossary only; stack, tracker and compliance live in the repo's
`CLAUDE.md`/`AGENTS.md` and `docs/agents/`. Remaining skills point to the replacements.

## Consequences
The stack shrinks to 26 skills that neither plugin covers. It now depends on both plugins being
installed for those workflows. Evals for the retired pairs are gone.

## Alternatives considered
- Keep both and rename ours: still two conflicting rule sets for one job.
- Hide ours with `skillOverrides`: the files stay and drift; `install.sh` keeps linking them.
