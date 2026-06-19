---
name: power-phrase
description: |
  Orchestrate a full build session with the 6 Power Phrases framework — interview, spec,
  verify, sub-agents, skill-capture, automate — sequencing the phases and routing each to
  this stack's own skill. Use only for the whole-session framing: when the user says "power
  phrases", "run the power-phrase framework", "set up this session properly", "which phase
  am I in", or is starting a non-trivial build with no spec or verification plan yet. For a
  single phase, defer to its native skill (to-cc-spec, grill-with-docs, verify, write-a-skill,
  loop/schedule) rather than this orchestrator.
---

A 6-phrase system for building faster and with higher quality in Claude Code.
Source: "Type This Into Claude, It'll Make You Build 10x Faster" (The AI Playbook).

This skill is an **orchestrator**: each phase hands off to the stack's native skill
rather than re-implementing it. Phrases stack in sequence — run them in order for any
non-trivial build, or pick only the ones that apply.

## Step 0 — Orient

If no specific phase was requested, ask which one applies:

> 1. Starting a new project → **Interview**, then **Spec**
> 2. About to build → **Verify**, then **Sub Agents**
> 3. Just finished something repeatable → **Build a Skill**
> 4. Considering automation → **Automate This**
> 5. Full session from scratch → run all 6 in sequence

If the goal is already clear, skip the question and go to the relevant phase.

## Phrase 1 — Launch sub agents

**Fire when:** there are parallel, independent workstreams, or multiple perspectives are
needed on one input. **Composes with:** the native Agent tool; for deep architecture work
use the `solution-architect` agent.

```
[TASK]

Launch [N] sub agents, each with a specific focus:
- Agent 1: [FOCUS]
- Agent 2: [FOCUS]
Each works independently without seeing the others' output.
```

- Clarity is non-negotiable — vague tasks produce bad parallel output.
- Don't parallelize work that is sequential by nature (one output feeds the next).

## Phrase 2 — Write me a spec

**Fire when:** the user is about to build without a plan. **Composes with:** the
`to-cc-spec` skill / `/spec` command — invoke that to produce the spec; this phase just
frames the ask. If the user can't yet evaluate a spec, run **Interview** (Phrase 3) first.

```
Write me an implementation spec to build [WHAT]. For each step, show the key decisions
and why. Include: core problem, recommended approach, decision points I can override,
and your assumptions. Do not start building yet.
```

- "For each step, show the key decisions" is the load-bearing line — always include it.
- Plan mode helps draft a spec but doesn't replace one.

## Phrase 3 — Interview me

**Fire when:** the user has a goal but is unclear on the specifics. **Composes with:**
`grill-with-docs` (records answers into CONTEXT.md + ADRs as you go) or `grill-me`
(pressure-test an existing plan). Prefer those skills' one-question-at-a-time discipline.

```
Interview me to build [WHAT]. One question at a time:
1. Identify the core problem and who it is / isn't for.
2. Walk each decision with me — if I don't know, I'll say "use your best judgment".
3. Summarize back as an implementation spec.
Start with your first question.
```

- "Use your best judgment" is a valid answer — it delegates that decision.
- Run before **Spec** when details are still fuzzy.

## Phrase 4 — Verify before you build

**Fire when:** starting a build, or after Claude has marked work done that wasn't.
Sets up the verification *strategy* across three layers. **Composes with:** the bundled
`/verify` skill for actually running and observing the app; `update-config` if a layer
should become a hook.

- **Layer 1 — bias toward verifying.** Add to CLAUDE.md: *"Before doing any work, state
  how you will verify that work once it's done."* Persists across sessions; set once.
- **Layer 2 — give Claude eyes.** Ask what tools let Claude *see* its own output for this
  build (browser for web, a validator for content). Highest-leverage move.
- **Layer 3 — human validation zones.** Identify high cost-of-error areas needing explicit
  sign-off (auth, payments, prod data are always candidates) vs. low-stakes areas that can
  move fast.

```
I'm starting: [PROJECT]. Set up verification across three layers:
1. A one-line CLAUDE.md addition that biases you toward stating your verification plan first.
2. Verification tools for this kind of project (internal/external, technical/non-technical).
3. My human validation zones — high vs. low cost-of-error. Do not start building yet.
```

## Phrase 5 — Based on this conversation, build me a skill

**Fire when:** a repeatable process just happened in this conversation. **Composes with:**
`write-a-skill` — hand off to it so the result follows house structure and conventions.
Never build skills abstractly; always from a conversation that already validated the use case.

```
Based on this conversation, build me a skill so I can repeat this automatically.
Capture: the goal, the steps, the decisions that mattered, and any gotchas.
```

To enhance an existing skill after friction:

```
Based on this conversation, add a gotchas section to the skill I just used so we don't
repeat this. What went wrong: [DESCRIBE].
```

- First version won't be perfect — update the gotchas the moment friction recurs.

## Phrase 6 — Automate this ⚠️

**Fire when:** the user wants to automate a process. Most powerful and most dangerous —
every broken automation adds operational debt. Run both filters before proceeding.
**Composes with:** the `loop` and `schedule` skills, and `update-config` for hooks.

- **Taste test:** does judging the output require taste, or is it fully quantifiable?
  Requires taste → **augment**. Quantifiable → automation candidate.
- **80/20 test:** would 80%-as-good-as-you output be acceptable? Yes → **automate**.
  No → **augment**.

```
I want to automate: [PROCESS]. Before setting anything up:
1. Confirm it passes the taste test (output fully quantifiable?).
2. Confirm I'm okay with 80% quality — flag where quality loss would hurt.
3. Suggest which Claude Code feature fits: hooks (event), schedule (time), loop (iterative).
4. Identify validation zones that should stay manual. Proceed only after I confirm.
```

When automation isn't right, augment instead — Claude handles [WHAT], the user retains
control over [WHAT]. Focus on reducing friction, not removing the human.

## Full-session sequence

```
1. Interview        → grill-with-docs / grill-me   (extract what you know)
2. Verify           → strategy + /verify           (CLAUDE.md, tools, validation zones)
3. Spec             → to-cc-spec / /spec            (finalize the plan)
4. Sub agents       → Agent tool                    (execute in parallel)
5. Build a skill    → write-a-skill                 (capture for next time)
6. Automate         → loop / schedule / hooks       (only if both filters pass)
```

## Quick reference

| Phrase | Routes to | Best for |
|---|---|---|
| Launch [N] sub agents | Agent / `solution-architect` | Parallel work, multiple perspectives |
| Write me a spec | `to-cc-spec` / `/spec` | Before any build |
| Interview me | `grill-with-docs` / `grill-me` | When details are unclear |
| Verify before you build | `/verify` + `update-config` | Every project |
| Build me a skill | `write-a-skill` | After a repeatable process |
| Automate this ⚠️ | `loop` / `schedule` / hooks | Only after taste + 80/20 pass |
