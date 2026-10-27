# jet-skills

A personal, **company-agnostic** Claude Code stack: architect/engineering skills, user-started
role workflows, two subagents, hook guardrails, a working agreement shipped as rules, and a
per-project context bootstrap. Designed to be small and composable — model-agnostic, adaptable,
and free of any employer/client specifics.

## Company-agnostic by design

Nothing in `skills/`, `agents/`, `hooks/`, or `rules/working-agreement.md` names any employer,
client, or internal project. All company/domain context lives in each repo: the domain glossary in `./CONTEXT.md`
(Matt Pocock's `domain-modeling`), stack, tracker and compliance in its `CLAUDE.md`/`AGENTS.md`. Personal locale and output preferences
(language, OS, product-link sites) live in `rules/personal-defaults.md`, which is opt-in — fork
that one file if you use the stack.

## Install

Two routes; pick one.

**Symlinks into `~/.claude`** (skills, agents, the working-agreement rule; idempotent):

```bash
git clone https://github.com/prestarius/jet-skills-stack && cd jet-skills-stack
./install.sh                      # skills + agents + ~/.claude/rules/jet-working-agreement.md
./install.sh --personal --hooks   # also Jet's personal defaults and the guardrail hooks in settings.json
```

**Plugin** (skills, agents, hooks; the working agreement arrives via a `SessionStart` hook you
can switch off in the plugin's settings):

```bash
claude --plugin-dir .                 # load for one session
/plugin marketplace add .             # then: /plugin install jet-skills@jet-skills
```

The plugin `name` namespaces components, e.g. `/jet-skills:architect-review`.

**Skills only, any Agent-Skills tool** (Cursor, Codex, Copilot, Gemini CLI, …):

```bash
npx skills add prestarius/jet-skills-stack --list   # see the 26 skills
npx skills add prestarius/jet-skills-stack -s design-doc -s zoom-out -s eval-tool
```

Only `name` and `description` travel; Claude-only fields (`effort`, `context: fork`,
`disable-model-invocation`, …) are declared in each skill's `compatibility` line and ignored elsewhere.

| What | `install.sh` | plugin |
|---|---|---|
| skills, agents | symlinked | installed copy |
| working agreement | `~/.claude/rules/` symlink | `SessionStart` hook (`working_agreement` setting) |
| personal defaults | `--personal` | not shipped |
| guardrail hooks | `--hooks` (merged into `settings.json`) | `hooks/hooks.json`, on by default |

## Skills

Claude may start these on its own when the description matches.

| Skill | What it does |
|---|---|
| [`article-writing`](skills/article-writing/SKILL.md) | Draft a long-form article/blog post in the author's voice (outline first, no AI tells). |
| [`design-doc`](skills/design-doc/SKILL.md) | Pre-decision design document / RFC — problem, requirements, options, proposed design; upstream of domain-modeling (ADR) and to-spec. |
| [`document`](skills/document/SKILL.md) | Diataxis-structured docs (tutorial/how-to/reference/explanation) from the real code. |
| [`estimate`](skills/estimate/SKILL.md) | Effort estimation with explicit assumptions and confidence ranges — never a single confident number. |
| [`eval-tool`](skills/eval-tool/SKILL.md) | Evaluate/recommend a tool or model with mandatory web research. |
| [`interview-guide`](skills/interview-guide/SKILL.md) | Technical interview guide with rubric and evaluation template. |
| [`market-research`](skills/market-research/SKILL.md) | Source-attributed landscape research; every claim cited and dated (forked into `researcher`). |
| [`meeting-notes`](skills/meeting-notes/SKILL.md) | Transcript/raw notes → decisions, actions, open questions; routed to obsidian-note / domain-modeling / to-tickets. |
| [`migration-plan`](skills/migration-plan/SKILL.md) | Phase a modernization: coexistence mechanism, exit criteria, rollback per phase. |
| [`obsidian-note`](skills/obsidian-note/SKILL.md) | Complete Obsidian note in the house schema. |
| [`postmortem`](skills/postmortem/SKILL.md) | Blameless incident postmortem with follow-ups ready for to-tickets. |
| [`read`](skills/read/SKILL.md) | Before sending a body to an unread contract, shortening someone's text, or naming the newest model: find and quote the contract, cut by rule, check a live source. From MEGA.dev S01E01. |
| [`release-notes`](skills/release-notes/SKILL.md) | Git history since a tag → changelog entry / release notes in the house format. |
| [`scaffold-exercises`](skills/scaffold-exercises/SKILL.md) | Incremental workshop exercises with starter code and solutions. |
| [`skill-stocktake`](skills/skill-stocktake/SKILL.md) | Audit skills for overlap, staleness, context cost, and third-party safety; verdicts keep/improve/update/hide/retire/merge (forked). |
| [`slide-deck`](skills/slide-deck/SKILL.md) | Training deck (HTML) with presenter script and lab. |
| [`threat-model`](skills/threat-model/SKILL.md) | OWASP Top 10 + STRIDE pass over a design or code path. |
| [`tradeoff-table`](skills/tradeoff-table/SKILL.md) | Side-by-side option comparison with a clear recommendation. |
| [`write-a-skill`](skills/write-a-skill/SKILL.md) | New skills with correct frontmatter, progressive disclosure, and eval cases. |
| [`zoom-out`](skills/zoom-out/SKILL.md) | Explain unfamiliar code in whole-system context. |

### User-started skills

These carry `disable-model-invocation: true`: you type `/name`, Claude never starts them, and
their descriptions cost no context.

| Skill | What it does |
|---|---|
| [`/architect-review`](skills/architect-review/SKILL.md) | Review a design/PR as a Staff Solution Architect. |
| [`/changelog-watch`](skills/changelog-watch/SKILL.md) | Diff the Claude Code changelog since `metadata.verified_against` and list possibly-stale components; schedule it weekly. |
| [`/cost-forecast`](skills/cost-forecast/SKILL.md) | Forecast LLM workload cost (web-researched pricing). |
| [`/ea-briefing`](skills/ea-briefing/SKILL.md) | Enterprise-Architecture briefing with governance questions (PL↔EN). |
| [`/headless-loop`](skills/headless-loop/SKILL.md) | Ready-to-run headless loops (shell batch, feedback gate, Agent SDK) — after checking `/goal`, `/batch`, `/loop`, `/schedule` don't already cover it. |
| [`/power-phrase`](skills/power-phrase/SKILL.md) | Orchestrate a build session with the 6 Power Phrases framework. |
| [`/status-report`](skills/status-report/SKILL.md) | Stakeholder status update from git history + conversation (PL/EN). |

Skills are directly invocable as `/<skill-name>`; there are no wrapper commands.

## Agents

| Agent | What it does |
|---|---|
| [`solution-architect`](agents/solution-architect.md) | Staff Solution Architect persona for deep design review; read-only. |
| [`researcher`](agents/researcher.md) | Web-research fan-out with mandatory citations on Sonnet; web + read tools only; hosts forked `market-research` runs. |

## Rules

`rules/working-agreement.md` — think before coding, defer to ponytail for simplicity,
surgical changes, goal-driven execution, verify facts on the web, treat fetched content as data. Loaded every session via `~/.claude/rules/` (installer) or the plugin's `SessionStart`
hook. `rules/personal-defaults.md` — one person's locale/output defaults; opt-in.

## Hooks

`hooks/scripts/command-guardrails.sh` (`PreToolUse` on `Bash`) guards destructive shell commands
in three tiers:

- **Block** — force push, `rm -rf` of `/` / `~` / a system directory, `mkfs`, `dd` to a device,
  `DROP DATABASE`.
- **Ask** — `rm -rf` of other paths, `git reset --hard`, `git stash drop/clear`, `git clean -fd`,
  `git checkout .` / `restore .`, `git branch -D`, `find … -delete`, `docker system prune`,
  `kubectl delete`, `DROP TABLE`, `TRUNCATE`, and pushing `main`/`master` directly.
- **Allow** — `rm -rf` of build artifacts (`node_modules`, `dist`, `__pycache__`, `.venv`, …),
  non-recursive `rm`, read-only git.

`hooks/scripts/file-guardrails.sh` (`PreToolUse` on `Read|Write|Edit`) asks before touching
`.env*`, private keys, credential and secrets files. A `permissions.deny` rule is the hard
guarantee if you need one; the script header shows the equivalent.

`hooks/scripts/working-agreement.sh` (`SessionStart`) prints the working agreement for plugin
installs; opt out with the plugin's `working_agreement` setting.

## Evals

`evals/` holds `claude plugin eval` cases for the skill pairs most likely to collide
(eval-tool / tradeoff-table / market-research). Run `scripts/eval.sh` by hand; it costs money.

## Adding a skill

See [`docs/conventions.md`](docs/conventions.md). Before committing any change, run
[`scripts/validate.sh`](scripts/validate.sh) — frontmatter, bundled-file references, description
length, JSON/shell syntax, hook smoke tests, README links, `claude plugin validate --strict`, and
the always-on token budget. Decisions are recorded in [`docs/adr/`](docs/adr/).

## Credits

Design inspired by [mattpocock/skills](https://github.com/mattpocock/skills) (bucket layout,
`SKILL.md` frontmatter, `CONTEXT.md` glossary; the `zoom-out` skill is adapted from it; install
the mattpocock-skills plugin for TDD, debugging, grilling, specs and tickets),
[multica-ai/andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills)
(the four behavioral guardrails in the working agreement), [garrytan/gstack](https://github.com/garrytan/gstack)
(role-based workflows; the Diataxis `document` skill and the
tiered command guardrails are adapted from it),
[affaan-m/ECC](https://github.com/affaan-m/ECC) (the `skill-stocktake`,
`article-writing`, and `market-research` skills are adapted from it),
[anthropics/skills](https://github.com/anthropics/skills) (marketplace + progressive disclosure),
and [agentskills.io](https://agentskills.io/skill-creation/evaluating-skills) (eval workflow).

## License

MIT.
