---
name: changelog-watch
description: Diff the Claude Code changelog since this stack's verified baseline and report which skills, hooks, or docs are possibly stale. Invoke as /changelog-watch by hand or on a schedule; not model-triggered.
argument-hint: "[optional: baseline version, default from plugin.json metadata.verified_against]"
disable-model-invocation: true
allowed-tools: WebFetch, Read, Bash(git log *), Bash(claude --version)
compatibility: "Claude Code (uses disable-model-invocation, argument-hint, allowed-tools); name + description work in any Agent Skills tool"
---

Keep the stack current without re-auditing everything. Output a short "possibly stale" list.

1. **Baseline.** Read `metadata.verified_against` from `${CLAUDE_SKILL_DIR}/../../.claude-plugin/plugin.json`
   (or the version given in `$ARGUMENTS`). Run `claude --version` for the installed version.
2. **Fetch the changelog.** `https://code.claude.com/docs/en/changelog.md`. Keep only entries newer
   than the baseline. Ignore "bug fixes and reliability" lines.
3. **Map entries to components** with `${CLAUDE_SKILL_DIR}/references/keyword-map.md`. An entry
   that *changes a default or removes a feature* outranks one that adds an option: mark the former
   **possibly stale**, the latter **new material, consider adding**.
4. **Report.** A table: version → entry (one line) → affected component → verdict. Then the three
   highest-leverage follow-ups as concrete edits (file + what to change). If nothing maps, say
   "no drift since <baseline>" and stop.
5. **Never edit files.** This skill reports; the user applies changes and bumps
   `metadata.verified_against` + `verified_date` in `plugin.json` when done.

To run it weekly: `/schedule` with the prompt `/changelog-watch` (cloud routine; the plugin must
be in `enabledPlugins` there), or `/loop 7d /changelog-watch` in a long-lived local session.
