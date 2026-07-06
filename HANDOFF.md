# Handoff — jet-skills

A resume doc for picking this project up cold. Update it as state changes.

## Goal
Build and maintain **jet-skills**: a personal, company-agnostic Claude Code "stack" — skills +
role-based slash commands + a behavioral `CLAUDE.md` + per-project `/bootstrap-context` — packaged as
a plugin (`/plugin install jet-skills@jet-skills`) and installable via `./install.sh`.
Repo: `github.com/prestarius/jet-skills-stack`, branch `master`.

## Done
- Scaffolded the repo; identity set to **Jet** (`prestarius@proton.me`, `prestarius.dev`).
- Ported the real `humanizer` verbatim (24-pattern `references/ai-patterns.md`).
- Genericized the `solution-architect` agent / `architect-review` persona.
- Harvested + adapted patterns from four upstreams (see README credits): `document`/Diataxis,
  `/scope-review`, the tiered guardrail (gstack); `search-first`, `skill-stocktake`,
  `article-writing`, `market-research` (ECC); the `grill-*`/`tdd`/`diagnose`/`zoom-out`/`handoff`/
  `caveman` skills (mattpocock); the four `CLAUDE.md` guardrails (karpathy).
- Fleshed every stub skill out to full.
- Broadened the guard hook → `hooks/scripts/command-guardrails.sh` (block / ask / allow tiers).

## Current state
- **35 full skills (0 stubs), 8 commands, 2 agents, 1 guardrail hook.** README tables + credits in sync.
- 2026-07-06 revision: sharpened the `handoff` / `to-cc-spec` trigger split (removed the shared
  "hand this off" phrase); added mutual routing lines across the `eval-tool` / `tradeoff-table` /
  `market-research` trio; heavy analysis skills now run forked (`context: fork` — `market-research`
  → new `researcher` agent, `improve-codebase-architecture` → `solution-architect`,
  `skill-stocktake` → default fork); added `researcher` agent and `design-doc`, `migration-plan`,
  `estimate` skills. Considered and rejected `disable-model-invocation` for humanizer/caveman/
  headless-loop/power-phrase — the field makes a skill slash-only, which would break their
  natural-language triggers; the prose "only when explicitly asked" guard is the right mechanism.
- 2026-06-12 revision: dropped `commands/adr.md` (shadowed — skills are slash-invocable and take
  precedence over same-name commands); renamed `/security-review` → `/threat-model` (collided with
  the bundled Claude Code skill); fixed `epic-numbering` frontmatter name to match its directory;
  demoted `git reset --hard` to the ask tier and added `git stash drop/clear` + `find -delete`;
  added `meeting-notes` + `postmortem` skills, `/status-report` command, a refresh mode in
  `/bootstrap-context`, symlink pruning in `install.sh`, and `scripts/validate.sh`.

## Open decisions
- None blocking.

## Next steps
1. (Optional) Run the **`skill-stocktake`** skill over `skills/` to catch overlap/drift at 35 skills.
2. New component → write/update → validate (below) → update README tables/credits → commit when asked → `git push origin master`.

## Gotchas (read before changing anything)
- **Identity:** the author/persona is **Jet** only. The user's real legal name must NEVER appear in any
  shipped file.
- **Company-agnostic:** no employer / client / internal-project names anywhere in `skills/ commands/
  agents/ hooks/ CLAUDE.md`. All company/domain specifics live ONLY in a per-project `./CONTEXT.md`.
- **Acceptance gate + per-change validation:** run `scripts/validate.sh` — it encodes the whole
  checklist (skill frontmatter + name/dir match, bundled-file references, JSON parse, `bash -n`,
  guard smoke tests, README links) and the **denylist** grep. The denylist stays out of this repo
  on purpose: the script reads `~/.claude/jet-skills-denylist.txt` (override with
  `JET_DENYLIST_FILE`) and skips with a note if absent — see the `~/.claude` project memory
  `jet-skills-stack`. Must print `OK` / zero denylist matches before committing.
- **Commit policy:** commit only when asked; end messages with the
  `Co-Authored-By: Claude Opus 4.8 (1M context)` trailer. `.DS_Store` is gitignored.
- **Philosophy:** minimalist, Claude-first, no MCP/infra in v1, flat `skills/`. When evaluating other
  repos, harvest a few self-contained *patterns* in house style — don't adopt frameworks or language packs.
