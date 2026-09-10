# Handoff — jet-skills

A resume doc for picking this project up cold. Update it as state changes.

## Goal
Build and maintain **jet-skills**: a personal, company-agnostic Claude Code "stack" — skills +
subagents + hook guardrails + a working agreement shipped as rules + per-project
`/bootstrap-context` — packaged as a plugin (`/plugin install jet-skills@jet-skills`) and
installable via `./install.sh`. Repo: `github.com/prestarius/jet-skills-stack`, branch `master`.

## Done
- Scaffolded the repo; identity set to **Jet** (`prestarius@proton.me`, `prestarius.dev`).
- Ported the real `humanizer` verbatim (24-pattern `references/ai-patterns.md`; upstream
  blader/humanizer now uses a different 25-pattern taxonomy, checked 2026-09-10 — no port needed).
- Harvested + adapted patterns from four upstreams (see README credits).
- 2026-09-10 audit (`BACKLOG.md`) and the first implementation pass — see "Current state".

## Current state (2026-09-10, verified against Claude Code 2.1.267)
- **Released 0.2.0**: commit `fda05f1` on `master`, pushed; annotated tag `jet-skills--v0.2.0`
  on origin (`claude plugin tag --push`). Follow-ups `530454a` (handoff) and `8269c76` (eval
  cases rewritten). Working tree clean.
- **Installed on this machine** via `./install.sh --personal --hooks`: 42 skill symlinks, both
  rules linked, old marker block removed from `~/.claude/CLAUDE.md` (now empty; backup
  `CLAUDE.md.bak`), both guard hooks in `~/.claude/settings.json` (backup `settings.json.bak`).
- **43 skills (33 model-invocable, 10 user-started), 2 agents, 3 hook scripts, 2 rules files,
  6 eval cases.** No `commands/` directory any more (ADR 0002). Every skill that uses a
  Claude-only frontmatter field carries a `compatibility:` line; `npx skills add
  prestarius/jet-skills-stack` lists all skills (verified 2026-09-10).
- `changelog-watch` (user-started) diffs the changelog against `metadata.verified_against` using
  `references/keyword-map.md`; schedule with `/schedule` → `/changelog-watch`.
- Working agreement ships as `rules/working-agreement.md` → `~/.claude/rules/` (installer) or a
  `SessionStart` hook (plugin, `working_agreement` userConfig). Personal defaults in
  `rules/personal-defaults.md`, `install.sh --personal`. Root `CLAUDE.md` imports the agreement
  and holds repo-only notes.
- Skills refer to compliance/locale defaults by role (`CONTEXT.md` `## Compliance`, working
  agreement), never by value.
- `install.sh --hooks` merges both guardrail hooks into `~/.claude/settings.json` (backup kept);
  it also removes the old marker block from `~/.claude/CLAUDE.md` once (backup kept).
- `scripts/validate.sh` now also checks frontmatter line 1, unknown keys, description length,
  file guard + session-start hook smoke tests, `claude plugin validate --strict`, and the
  always-on token budget (`JET_MAX_ALWAYS_ON_TOKENS`, default 6000). CI: `.github/workflows/validate.yml`.
- Plugin 0.2.0; `metadata.verified_against` = 2.1.267.

## Open decisions
- `solution-architect` persistent memory (BACKLOG 3.3.3): decided **no** — memory grants
  Write/Edit for its directory, conflicting with the agent's read-only `disallowedTools`, and
  project/local scopes write into reviewed repos.
- `claude plugin details` reported ~5,037 always-on tokens after hiding 13 descriptions, barely
  down from 5,063 — the estimator may ignore `disable-model-invocation`. Confirm with `/context`
  or `/skill-doctor` in a live session before trusting the validator's budget check.
- **`claude plugin eval` is early access and not enabled on this account** (2.1.267 prints
  "`plugin eval` is currently in early access" for every subcommand, even `init`). First-party
  accounts get it automatically after `claude update` + a fresh session; nothing to configure
  locally. The six cases now use the layout the CLI reads (`prompt.md` + `graders/*.md`;
  `tool_used` with `tool: Skill` + `input_match`, `llm` rubric in the body, `file_exists`,
  `regex`). Unverified until a run succeeds: whether `plugins: ["../.."]` in `prompt.md` is
  redundant when the plugin dir is passed on the command line.

## Next steps
1. In a fresh session: `/context` should list `jet-working-agreement.md` and
   `jet-personal-defaults.md` under Memory files; `/hooks` should show the two PreToolUse
   entries; the 9 user-started skills should be absent from Claude's skill listing. Check the
   GitHub Actions run for commit `fda05f1` (first run of `.github/workflows/validate.yml`).
2. After `claude update`, in a fresh session try `scripts/eval.sh 'handoff*'`; if it still prints
   the early-access line the flag has not reached the account. On the first real run fix any
   frontmatter the CLI rejects (see Open decisions).
3. Remaining backlog: 3.1.3 (`/skill-doctor` review, due 2026-09-24) and 5.1.2 (skill-creator
   description tuning; needs an interactive session and the eval early-access flag). Everything
   else in `BACKLOG.md` is done or decided.
4. Delete `~/.claude/CLAUDE.md.bak` and `~/.claude/settings.json.bak` once the new session checks out.
5. Update procedure from now on: `git pull && ./install.sh` (idempotent). Releases: bump
   `plugin.json` version, `claude plugin tag --dry-run .`, then `claude plugin tag --push .`.

## Gotchas (read before changing anything)
- **Identity:** the author/persona is **Jet** only. The user's real legal name must NEVER appear in any
  shipped file.
- **Company- and person-agnostic:** no employer / client / internal-project names in `skills/
  agents/ hooks/ rules/working-agreement.md`; no personal locale values in skill bodies.
- **Acceptance gate:** `scripts/validate.sh` must print `OK` before committing. The denylist stays
  out of this repo on purpose: the script reads `~/.claude/jet-skills-denylist.txt` (override with
  `JET_DENYLIST_FILE`) and skips with a note if absent.
- **Commit policy:** commit only when asked; use the attribution trailer the session provides.
  `.DS_Store` and `evals/results/` are gitignored.
- **User-started skills** (`disable-model-invocation: true`) cannot be triggered by natural
  language; if one should be, drop the flag and pay its description cost.
- **Plugin agents** ignore `hooks`, `mcpServers`, `permissionMode` — use `tools`/`disallowedTools`.
- **Philosophy:** minimalist, Claude-first, no MCP/infra, flat `skills/`. Harvest self-contained
  *patterns* from other repos in house style — don't adopt frameworks or language packs.
