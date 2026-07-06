# jet-skills

A personal, **company-agnostic** Claude Code stack: architect/engineering skills, role-based
slash-command workflows, behavioral guardrails, and a per-project context bootstrap. Designed to
be small and composable — model-agnostic, adaptable, and free of any employer/client specifics.

## Company-agnostic by design

Nothing in `skills/`, `commands/`, `agents/`, `hooks/`, or the global `CLAUDE.md` names any
employer, client, or internal project. All company/domain context is injected at use-time into a
per-repo `./CONTEXT.md`, produced by the `/bootstrap-context` command. Durable *personal*
preferences (language, OS, output-format defaults) live in the global `CLAUDE.md` because they
travel across every project.

## Install

Clone and run the installer (idempotent symlinks into `~/.claude`):

```bash
git clone https://github.com/prestarius/jet-skills-stack && cd jet-skills-stack && ./install.sh
```

The installer symlinks skills/commands/agents and appends the behavioral `CLAUDE.md` between
markers. Hooks are **not** auto-installed (they edit `settings.json`); the installer prints the
snippet to paste.

### Plugin alternative

```bash
claude --plugin-dir .                 # load for one session
/plugin marketplace add .             # then: /plugin install jet-skills@jet-skills
```

The plugin `name` namespaces components, e.g. `/jet-skills:architect-review`.

## Skills

| Skill | Type | What it does |
|---|---|---|
| [`humanizer`](skills/humanizer/SKILL.md) | full | Remove AI-writing tells (24 pattern categories) and rewrite to natural prose. |
| [`epic-numbering`](skills/epic-numbering/SKILL.md) | full | Epic / User Story / Task numbering convention for backlogs. |
| [`to-cc-spec`](skills/to-cc-spec/SKILL.md) | full | Turn a conversation into a Claude Code–ready implementation spec. |
| [`adr`](skills/adr/SKILL.md) | full | Author Architecture Decision Records, one per decision. |
| [`tradeoff-table`](skills/tradeoff-table/SKILL.md) | full | Side-by-side option comparison with a clear recommendation. |
| [`obsidian-note`](skills/obsidian-note/SKILL.md) | full | Generate a complete Obsidian note in the house schema. |
| [`meeting-notes`](skills/meeting-notes/SKILL.md) | full | Transcript/raw notes → structured minutes (decisions, actions, open questions), routed to obsidian-note / adr / to-issues. |
| [`postmortem`](skills/postmortem/SKILL.md) | full | Blameless incident postmortem: timeline, contributing factors, follow-up actions ready for to-issues. |
| [`interview-guide`](skills/interview-guide/SKILL.md) | full | Technical interview guide with rubric and evaluation template. |
| [`eval-tool`](skills/eval-tool/SKILL.md) | full | Evaluate/recommend a tool or model with mandatory web research. |
| [`simplicity-review`](skills/simplicity-review/SKILL.md) | full | Flag over-engineering and propose the simpler alternative. |
| [`slide-deck`](skills/slide-deck/SKILL.md) | full | Plan/generate a training deck with presenter script and lab. |
| [`improve-codebase-architecture`](skills/improve-codebase-architecture/SKILL.md) | full | Survey a codebase and surface prioritized architectural improvements (in domain language, captured as ADRs). |
| [`scaffold-exercises`](skills/scaffold-exercises/SKILL.md) | full | Generate incremental workshop exercises with starter code and solutions. |
| [`prototype`](skills/prototype/SKILL.md) | full | Build a throwaway spike to answer one design/feasibility question, then report the finding. |
| [`to-issues`](skills/to-issues/SKILL.md) | full | Turn a plan into independent, tracker-agnostic issues (pairs with epic-numbering). |
| [`teach`](skills/teach/SKILL.md) | full | Teach a topic across sessions, learning by doing, with persisted progress. |
| [`document`](skills/document/SKILL.md) | full | Generate Diataxis-structured docs (tutorial/how-to/reference/explanation) from the real code. |
| [`search-first`](skills/search-first/SKILL.md) | full | Search the repo, registries, and web for an existing solution before building; decide adopt/extend/compose/build. |
| [`skill-stocktake`](skills/skill-stocktake/SKILL.md) | full | Audit skills for overlap, stale references, and trigger drift; verdicts keep/improve/update/retire/merge. |
| [`article-writing`](skills/article-writing/SKILL.md) | full | Draft a long-form article/blog post in the author's voice (outline first, no AI tells). |
| [`market-research`](skills/market-research/SKILL.md) | full | Source-attributed landscape/market research; every claim cited and dated. |
| [`grill-me`](skills/grill-me/SKILL.md) | full | Relentless one-question-at-a-time plan interrogation. |
| [`grill-with-docs`](skills/grill-with-docs/SKILL.md) | full | grill-me, but records answers into CONTEXT.md + ADRs. |
| [`tdd`](skills/tdd/SKILL.md) | full | Red-green-refactor, one vertical slice at a time. |
| [`diagnose`](skills/diagnose/SKILL.md) | full | Reproduce → minimise → hypothesise → instrument → fix. |
| [`zoom-out`](skills/zoom-out/SKILL.md) | full | Explain unfamiliar code in whole-system context. |
| [`handoff`](skills/handoff/SKILL.md) | full | Compact the conversation into a handoff doc. |
| [`caveman`](skills/caveman/SKILL.md) | full | Ultra-compressed comms; fewer tokens, same accuracy. |
| [`write-a-skill`](skills/write-a-skill/SKILL.md) | full | Create new skills with proper structure + progressive disclosure. |
| [`power-phrase`](skills/power-phrase/SKILL.md) | full | Orchestrate a build session with the 6 Power Phrases framework, routing each phase to the stack's native skill. |
| [`headless-loop`](skills/headless-loop/SKILL.md) | full | Generate ready-to-run headless Claude Code automation loops (shell batch, feedback gate, Agent SDK). |
| [`design-doc`](skills/design-doc/SKILL.md) | full | Author a pre-decision design document / RFC — problem, requirements, options, proposed design; upstream of adr and to-cc-spec. |
| [`migration-plan`](skills/migration-plan/SKILL.md) | full | Phase a modernization: current → target with a coexistence mechanism, exit criteria, and rollback per phase. |
| [`estimate`](skills/estimate/SKILL.md) | full | Effort estimation with explicit assumptions and confidence ranges — never a single confident number. |

## Commands

| Command | What it does |
|---|---|
| [`/bootstrap-context`](commands/bootstrap-context.md) | Write or refresh this repo's `CONTEXT.md` (the company-agnostic mechanism). |
| [`/architect-review`](commands/architect-review.md) | Review a design/PR as a Staff Solution Architect. |
| [`/scope-review`](commands/scope-review.md) | Challenge and right-size a plan's scope before building (4 modes). |
| [`/ea-briefing`](commands/ea-briefing.md) | Enterprise-Architecture briefing with governance questions. |
| [`/threat-model`](commands/threat-model.md) | OWASP Top 10 + STRIDE threat analysis of a design or code path (named to avoid the bundled `/security-review` skill). |
| [`/status-report`](commands/status-report.md) | Stakeholder status update from git history + conversation (PL/EN per audience). |
| [`/cost-forecast`](commands/cost-forecast.md) | Forecast LLM workload cost (web-researched pricing). |
| [`/spec`](commands/spec.md) | Thin wrapper → the `to-cc-spec` skill. |

Skills are directly invocable as `/<skill-name>` (commands and skills are merged in current
Claude Code), so skills don't get wrapper commands; `/spec` exists only to shorten
`/to-cc-spec`.

## Agents

| Agent | What it does |
|---|---|
| [`solution-architect`](agents/solution-architect.md) | Staff Solution Architect persona for deep design review; also hosts forked `improve-codebase-architecture` runs. |
| [`researcher`](agents/researcher.md) | Web-research fan-out with mandatory citations; hosts forked `market-research` runs. |

Heavy analysis skills (`improve-codebase-architecture`, `market-research`, `skill-stocktake`) declare
`context: fork` and run in a subagent, keeping the main session's context clean.

## Hooks

`hooks/scripts/command-guardrails.sh` is a `PreToolUse` hook that guards destructive shell commands
in three tiers:

- **Block** — catastrophic commands are refused outright: force push, `rm -rf`
  of `/` / `~` / a system directory, `mkfs`, `dd` to a device, `DROP DATABASE`.
- **Ask** — recoverable-but-dangerous commands prompt for a confirmation you can override: `rm -rf`
  of other paths, `git reset --hard`, `git stash drop/clear`, `git clean -fd`,
  `git checkout .` / `restore .`, `git branch -D`, `find … -delete`,
  `docker system prune`, `kubectl delete`, `DROP TABLE`, `TRUNCATE`.
- **Allow** — safe cleanups pass silently: `rm -rf` of build artifacts (`node_modules`, `dist`,
  `__pycache__`, `bin`/`obj`, `.venv`, …), non-recursive `rm`, and read-only git.

Hooks are **not** auto-installed (they edit `settings.json`); `install.sh` prints the snippet to enable them.

## Adding a skill

See [`docs/conventions.md`](docs/conventions.md) for how to add skills/commands and the
full-vs-stub policy. Before committing any change, run [`scripts/validate.sh`](scripts/validate.sh)
— it checks skill frontmatter, bundled-file references, JSON/shell syntax, the guardrail hook,
and README links.

## Credits

Design inspired by [mattpocock/skills](https://github.com/mattpocock/skills) (bucket layout,
`SKILL.md` frontmatter, `CONTEXT.md` glossary, setup skill; the `grill-me`, `grill-with-docs`,
`tdd`, `diagnose`, `zoom-out`, `handoff`, and `caveman` skills are adapted from it),
[multica-ai/andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills)
(behavioral guardrails), [garrytan/gstack](https://github.com/garrytan/gstack) (role-based slash
commands; the Diataxis `document` skill, the `/scope-review` scope modes, and the tiered command
guardrails are adapted from it),
[affaan-m/ECC](https://github.com/affaan-m/ECC) (the `search-first`, `skill-stocktake`,
`article-writing`, and `market-research` skills are adapted from it), and
[anthropics/skills](https://github.com/anthropics/skills) (marketplace + progressive disclosure).

The four behavioral guardrails from
[multica-ai/andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills) —
*think before coding*, *simplicity first*, *surgical changes*, and *goal-driven execution* — are
not shipped as a separate skill. They are folded into the always-on `CLAUDE.md` working agreement
(so they apply to every session, not only when a skill triggers), and the *simplicity first*
principle is operationalized on demand by the [`simplicity-review`](skills/simplicity-review/SKILL.md) skill.

## License

MIT.
