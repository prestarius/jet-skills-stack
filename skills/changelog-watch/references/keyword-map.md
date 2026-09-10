# Changelog → component keyword map

Match case-insensitively against the changelog entry text. An entry can map to several
components. Entries matching nothing significant are listed under `unmapped` (at most five).

| Keywords in changelog entry | Component(s) in this stack |
|---|---|
| skill, SKILL.md, frontmatter, disable-model-invocation, user-invocable, allowed-tools, when_to_use, paths, skillOverrides, /skill-doctor, description budget, bundled skill | `write-a-skill`, `skill-stocktake`, `docs/conventions.md`, `scripts/validate.sh` (frontmatter checks) |
| plugin, marketplace, plugin.json, marketplace.json, CLAUDE_PLUGIN_ROOT, userConfig, plugin validate, plugin eval, plugin tag, plugin details | `.claude-plugin/*.json`, `scripts/validate.sh`, `scripts/eval.sh`, `evals/`, `docs/conventions.md` |
| hook, PreToolUse, SessionStart, permissionDecision, matcher, hooks.json, timeout, async | `hooks/hooks.json`, `hooks/scripts/*.sh`, `install.sh --hooks` |
| subagent, sub-agent, agent frontmatter, tools, disallowedTools, memory, maxTurns, context: fork, SubagentStart | `agents/*.md`, `improve-codebase-architecture`, `market-research`, `skill-stocktake` |
| CLAUDE.md, rules, .claude/rules, memory, auto memory, @import, claudeMd | `rules/`, `CLAUDE.md`, `install.sh` (rules symlinks), `hooks/scripts/working-agreement.sh` |
| headless, -p, --print, --bare, --output-format, --json-schema, --max-budget, --max-turns, --permission-mode, --allowedTools, Agent SDK, ClaudeAgentOptions | `headless-loop` |
| /goal, /loop, /batch, /schedule, routine, workflow, ultracode, agent team, worktree | `headless-loop` (Step 0 table), `power-phrase` |
| /verify, /code-review, /security-review, /simplify, artifact | `power-phrase` (Phrase 4), `to-cc-spec` (verification plan), `threat-model` (routing line) |
| permission, deny rule, allow rule, sandbox | `hooks/scripts/file-guardrails.sh` header, README "Hooks" |
| effort, model alias, thinking | any skill with `effort:` (`design-doc`, `diagnose`, `grill-me`, `migration-plan`, `simplicity-review`, `tradeoff-table`, `architect-review`, `scope-review`, `threat-model`, `improve-codebase-architecture`) |
| Agent Skills spec, compatibility, metadata, agentskills.io | `compatibility:` lines in skills, `docs/conventions.md` |
| context window, compaction, token, cost, /context, /usage | `scripts/validate.sh` (always-on budget), README "Skills" |
