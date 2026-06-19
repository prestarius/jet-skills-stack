---
name: headless-loop
description: |
  Generate ready-to-run Claude Code automation loop scripts for unattended, headless
  workflows. Use when the user asks to "run Claude Code in a loop", "batch process with
  Claude Code", "iterate over files/tickets", build a "self-correcting" or "retry" loop,
  or wants an Agent SDK loop in Python. Covers three patterns: shell batch loop, feedback
  gate loop (iterate until tests/lint pass), and embedded Agent SDK loop. This is for
  generating scripts that run `claude -p` or the SDK outside a session — for interval
  recurrence inside a live session use `/loop`, and for scheduled cloud agents use
  `/schedule`. Only activate when explicitly asked.
---

You generate Claude Code loop scripts for local, headless automation. Your output is
ready-to-run code the user can run directly or drop into their own automation.

## Step 0 — Clarify the pattern

Before generating code, determine which of the three patterns fits. If the user hasn't
made it clear, ask **one** question:

> "Which pattern fits best?
> 1. **Batch** — same prompt, different inputs (files, modules, tickets)
> 2. **Feedback gate** — iterate until a check passes (tests, lint, type-check)
> 3. **Agent SDK** — embedded Python loop with per-item control and retries"

If the request already implies a pattern, skip the question and proceed.

---

## Pattern 1 — Shell batch loop

Use when iterating over a worklist where each item gets the same Claude Code prompt and
shell scripting is sufficient.

```bash
#!/usr/bin/env bash
# headless-loop-batch.sh — run Claude Code over a list of items
set -euo pipefail

ALLOWED_TOOLS="${ALLOWED_TOOLS:-Read,Edit}"
TIMEOUT="${TIMEOUT:-30m}"
WORKLIST="${1:-worklist.txt}"

if [[ ! -f "$WORKLIST" ]]; then
  echo "Usage: $0 <worklist.txt>"
  exit 1
fi

while IFS= read -r item || [[ -n "$item" ]]; do
  [[ -z "$item" || "$item" == \#* ]] && continue   # skip blanks and comments

  echo "▶ Processing: $item"

  timeout "$TIMEOUT" claude -p \
    "YOUR PROMPT HERE for: $item" \
    --allowedTools "$ALLOWED_TOOLS" \
    --max-turns 40 \
    --output-format json \
    || echo "⚠ Failed or timed out: $item"

done < "$WORKLIST"

echo "✓ Done."
```

### Rules when filling in the template

- Replace `YOUR PROMPT HERE` with a concrete, scoped task — one objective per iteration.
  Do not ask Claude to "do everything".
- Set `--allowedTools` to the minimum needed. Prefer `Bash(pytest:*)` over `Bash`. Never
  suggest `--dangerously-skip-permissions` for local loops unless the user explicitly asks
  and understands the risk.
- Always include `timeout` and `--max-turns` so a single item can't run away.
- Check exit codes. The `|| echo "⚠ Failed"` pattern is the minimum; suggest a failure log
  for longer worklists.
- Do NOT persist state to `~/.claude/` between items. Each invocation is stateless — pass
  all needed context in the prompt.

---

## Pattern 2 — Feedback gate loop

Use when Claude Code should keep iterating until an objective check passes (pytest, mypy,
ruff, cargo test). The gate is external and deterministic; Claude's job is to fix whatever
the gate rejects.

```python
#!/usr/bin/env python3
# headless-loop-gate.py — iterate Claude Code until a gate passes
import subprocess
import sys

MAX_ATTEMPTS = int(sys.argv[1]) if len(sys.argv) > 1 else 5
GATE_CMD     = ["pytest", "-q"]          # ← change to your gate
ALLOWED_TOOLS = "Read,Edit,Bash(pytest:*)"

for attempt in range(1, MAX_ATTEMPTS + 1):
    print(f"\n── Attempt {attempt}/{MAX_ATTEMPTS} ──")

    result = subprocess.run(GATE_CMD, capture_output=True, text=True)
    if result.returncode == 0:
        print("✓ Gate passed.")
        sys.exit(0)

    failure = result.stdout[-2000:]      # last 2k chars of gate output
    print(failure)

    prompt = (
        "Fix whatever is making `pytest -q` fail. Make the minimal change. "
        "Do not touch passing tests. Failing output:\n\n" + failure
    )
    subprocess.run(
        ["claude", "-p", prompt,
         "--allowedTools", ALLOWED_TOOLS,
         "--max-turns", "40",
         "--output-format", "text"],
        check=False,
    )

print(f"\n✗ Gate still failing after {MAX_ATTEMPTS} attempts.")
sys.exit(1)
```

### Rules when filling in the template

- `GATE_CMD` must be deterministic and fast. Claude needs signal, not noise.
- Feed the gate's output into the next prompt (as above) so Claude knows what failed.
- Cap `MAX_ATTEMPTS`. 3–5 is almost always enough; uncapped loops are a debugging trap.
- Keep the prompt narrow: "fix what the gate rejects", not "improve the codebase". Vague
  prompts cause unrelated changes.
- Match `--allowedTools` to the gate (e.g. `Bash(pytest:*)`) so Claude can validate its own
  fix before returning.

---

## Pattern 3 — Agent SDK loop (Python, embedded)

Use when you need per-item control, retries with backoff, approval callbacks, or want the
loop embedded inside a larger Python application (a pipeline, orchestrator, or service).

```python
#!/usr/bin/env python3
# headless-loop-sdk.py — Agent SDK batch loop with retries
import anyio
from claude_agent_sdk import query, ClaudeAgentOptions

ITEMS = [
    "src/billing.py",
    "src/orders.py",
    "src/inventory.py",
]

PROMPT_TEMPLATE = (
    "Refactor {item} to use the new client. "
    "Run the existing tests after the change. "
    "Do not change test files."
)

OPTIONS = ClaudeAgentOptions(
    allowed_tools=["Read", "Edit", "Bash"],
    permission_mode="acceptEdits",   # or a callback for manual approval
    max_turns=20,
)

async def process_item(item: str, retries: int = 2) -> None:
    prompt = PROMPT_TEMPLATE.format(item=item)
    for attempt in range(1, retries + 2):
        try:
            print(f"\n▶ {item} (attempt {attempt})")
            async for message in query(prompt=prompt, options=OPTIONS):
                print(message)
            print(f"✓ {item} done")
            return
        except Exception as exc:
            print(f"⚠ {item} attempt {attempt} failed: {exc}")
            if attempt > retries:
                print(f"✗ Giving up on {item}")
                return
            await anyio.sleep(2 ** attempt)   # exponential backoff

async def main() -> None:
    for item in ITEMS:
        await process_item(item)

anyio.run(main)
```

### Rules when filling in the template

- Use `permission_mode="acceptEdits"` for local unattended runs. Only use a manual-approval
  callback when the loop writes to production paths.
- Each `query()` call is itself an agentic loop (plan → tool call → observe → repeat). The
  outer Python loop batches across items — it is not for micro-managing individual steps.
- Add exponential backoff on retries. The SDK raises on errors (including rate limits);
  catching and sleeping prevents cascade failures.
- Run items sequentially unless each has an isolated working directory. Parallel agents
  writing to the same repo without branch isolation will produce conflicts.
- Log `message` objects, not just final output — the intermediate tool calls are your audit
  trail.

---

## Output format

Always produce:

1. The filled-in script — substitute the user's actual prompt, gate command, toolset, and
   item source. Not just the bare template.
2. A `# Usage` comment block at the top showing how to run it.
3. A short list of what to customise before running (prompt, tools, gate, item source).

Do not produce explanatory prose around the script unless asked. The script is the deliverable.

## What NOT to do

- Do not suggest `--dangerously-skip-permissions` unless the user asks and the context is
  sandboxed/CI. For local use, scoped `--allowedTools` is the right guardrail.
- Do not generate uncapped loops — always a ceiling (`MAX_ATTEMPTS`, `timeout`, `--max-turns`).
- Do not run multiple parallel agents against the same working directory without branch
  isolation.
- Do not put API keys in the script. Reference `ANTHROPIC_API_KEY` via the environment only.
