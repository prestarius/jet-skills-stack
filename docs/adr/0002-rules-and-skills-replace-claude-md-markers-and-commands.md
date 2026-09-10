# 0002. Ship the working agreement as rules and every workflow as a skill
- Status: Accepted
- Date: 2026-09-10
- Deciders: Jet

## Context
The stack shipped its behavioral guardrails by appending the repo `CLAUDE.md` between markers in
`~/.claude/CLAUDE.md`, which drifts from git and is not loaded at all for `/plugin install` users
(Claude Code ignores a `CLAUDE.md` at a plugin root). Personal locale defaults (PL/EN, macOS,
product-link sites) lived in the same file and in six skill bodies, contradicting "installable by
others". Eight role workflows lived in `commands/`, a legacy mechanism that has been merged into
skills and lacks supporting files, `context: fork`, `paths`, and invocation control. Claude Code
now supports user-level `~/.claude/rules/`, `SessionStart` context injection from a plugin hook,
and `disable-model-invocation: true`, which removes a skill's description from context entirely.

## Decision
We will keep the generic working agreement in `rules/working-agreement.md`, symlinked to
`~/.claude/rules/` by `install.sh` and injected by a `SessionStart` hook for plugin installs
(opt-out via the plugin's `working_agreement` setting). Personal defaults move to
`rules/personal-defaults.md`, installed only with `--personal`, and skills refer to those defaults
and to `CONTEXT.md` by role rather than by value. Every workflow is a skill; user-started
workflows carry `disable-model-invocation: true`. The `commands/` directory, the `/spec` wrapper,
and the `epic-numbering` skill (now one line in the working agreement) are removed.

## Consequences
- Positive: one source of truth for the agreement, tracked in git; plugin users get it too.
- Positive: the stack is person-agnostic as well as company-agnostic; forks change one file.
- Positive: hidden descriptions for eleven user-started skills reduce always-on context.
- Negative: `/spec` no longer exists; type `/to-cc-spec`. Hidden skills cannot be triggered by
  natural language, only by `/name`.
- Neutral: Cowork desktop sessions skip symlinked user rules that point outside the working
  directory; the plugin hook route covers that case.

## Alternatives considered
- **Keep marker-appending** — drifts, invisible to plugin installs, mixes personal and generic.
- **Wrap the agreement in a `user-invocable: false` skill** — Claude decides when to load it, so
  it is not always-on.
- **Keep `commands/` for user-started workflows** — no supporting files, no fork, and the
  platform lists it as legacy.
