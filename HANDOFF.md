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
- **28 full skills (0 stubs), 8 commands, 1 agent, 1 guardrail hook.** README tables + credits in sync.
- Working tree clean; `master` synced to `origin`. Verify: `git rev-parse HEAD origin/master` (should match).

## Open decisions
- None blocking.

## Next steps
1. (Optional) Run the **`skill-stocktake`** skill over `skills/` to catch overlap/drift at 28 skills.
2. New component → write/update → validate (below) → update README tables/credits → commit when asked → `git push origin master`.

## Gotchas (read before changing anything)
- **Identity:** the author/persona is **Jet** only. The user's real legal name must NEVER appear in any
  shipped file.
- **Company-agnostic:** no employer / client / internal-project names anywhere in `skills/ commands/
  agents/ hooks/ CLAUDE.md`. All company/domain specifics live ONLY in a per-project `./CONTEXT.md`.
- **Acceptance gate:** before committing, run a case-insensitive `grep -riE` over the shipped files for
  the personal-name + former-employer/client **denylist** (kept out of this repo on purpose — see the
  `~/.claude` project memory `jet-skills-stack`). It must return **zero matches**.
- **Per-change validation (no test suite):** every `SKILL.md` has `name` + `description`; referenced
  `references/`/`assets/` files exist; `python3 -m json.tool` parses the 3 JSON files; `bash -n
  install.sh`; guard smoke test
  `echo '{"tool_input":{"command":"git push --force"}}' | bash hooks/scripts/command-guardrails.sh; echo $?`
  → prints BLOCKED, exit 2; README links resolve.
- **Commit policy:** commit only when asked; end messages with the
  `Co-Authored-By: Claude Opus 4.8 (1M context)` trailer. `.DS_Store` is gitignored.
- **Philosophy:** minimalist, Claude-first, no MCP/infra in v1, flat `skills/`. When evaluating other
  repos, harvest a few self-contained *patterns* in house style — don't adopt frameworks or language packs.
